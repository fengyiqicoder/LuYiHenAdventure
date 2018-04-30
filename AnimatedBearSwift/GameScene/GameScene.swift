
//Bug 记录

import SpriteKit

class GameScene: SKScene {
  
  weak var viewControllerDelegate:ScenseDelegate!
  
  //MARK:Model
  var resourceDictionary:[String:Any] {
    return ScenesData.getResource(scenesNumber: sceneNumber)
  }
  
  //MARK: 关卡控制
  var maxSceneCanReach:Int = 0
  var sceneNumber = 0{
    didSet{
      let level = sceneNumber/2
      let levelName = GameSetting.levelName[level]
      viewControllerDelegate.changeLevelName(newName: levelName)
    }
  }
  
  
  
  //MARK: SpirteNode
  private var man:Man = Man()
  private var background = SKSpriteNode()
  private var manWalkingFrames: [SKTexture] = []
  private var kickingTextures:[SKTexture] = []
  private var punchingTextures:[SKTexture] = []
  
  //testing Monster
  private var monsters:[Monster] = []
  //cuteMonster
  private var cuteMonsterTextures:[SKTexture] = []
  
  //边缘
  lazy var rightMaxDistance:CGFloat =  { [unowned self] in return self.size.width  }()
  var leftMaxDistance:CGFloat = 0
  
  
  //MARK:states
  var runingDirectionToRight:Bool?
  var isJumping:Bool{
    if ((man.physicsBody!.velocity.dy != 0.0))
    {
      return true
    }
    return false
  }
  
  var isDoingAction:Bool {
    if ((man.action(forKey: "kick") != nil)||(man.action(forKey: "punch") != nil))
    {
      return true
    }
    return false
  }
  
  var manFacingRight:Bool{
    if man.xScale == -1 {
      return false
    }else{
      return true
    }
  }
  
  //MARK: - loadCode
  
  
  override func didMove(to view: SKView) {
    backgroundColor = .blue
    let physicsBounds = CGMutablePath()
    physicsBounds.addLines(between: [CGPoint(x:-500,y:440),
                                     CGPoint(x:1400,y:440)])
    physicsBody = SKPhysicsBody(edgeChainFrom: physicsBounds)
    self.physicsWorld.gravity = CGVector(dx: 0, dy: -8.8)
    
    print(rightMaxDistance)
    buildMan()
    buildMonster()
    loadBackground()
    
  }
  
  func loadBackground() {
    //getBackgroundImageName
    let name = resourceDictionary["background"] as! String
    background = SKSpriteNode(imageNamed: name)
    background.size = self.view!.frame.size
    background.position = self.view!.center
    background.zPosition = 1.0
    addChild(background)
  }
  
  func buildMan() {
    //load all texture
    loadTexture(folderName: "manTexture", imageName: "walk", textureArray: &manWalkingFrames)
    loadTexture(folderName: "kickAction", imageName: "kick", textureArray: &kickingTextures)
    loadTexture(folderName: "punchAction", imageName: "punch", textureArray: &punchingTextures)
    
    let firstFrameTexture = manWalkingFrames[0]
    man = Man(texture: firstFrameTexture)
    man.bloodBarDelegate = viewControllerDelegate
    man.position = CGPoint(x: GameSetting.manStartPointX,
                           y: GameSetting.manStartPointY)
    //    man.size = GameSetting.manSize
    man.zPosition = 3.0
    //创建物理属性
    man.physicsBody = SKPhysicsBody(rectangleOf: man.size, center: man.position)
    man.physicsBody!.affectedByGravity = true
    man.physicsBody!.allowsRotation = false
    addChild(man)
    
  }
  
  func buildMonster() {
    loadTexture(folderName: "cuteMonsterTexture", imageName: "monster", textureArray: &cuteMonsterTextures)
    //创建怪物
    let firstFrameTexture = cuteMonsterTextures[0]
    let newMonster = Monster(texture: firstFrameTexture, textureArray: cuteMonsterTextures,
                             yPosition: 240, showFromRight: false, hurt: 8, speed: 5.6, canBeHit: 3)
    let newMonster2 = Monster(texture: firstFrameTexture, textureArray: cuteMonsterTextures,
                              yPosition: 240, showFromRight: true, hurt: 8, speed: 3, canBeHit: 3)
    //使用循环动画
    newMonster.runAnimation()
    newMonster2.runAnimation()
    monsters.append(newMonster)
    addChild(newMonster)
    monsters.append(newMonster2)
    addChild(newMonster2)
    
  }
  
  //载入材质
  func loadTexture(folderName:String,imageName:String, textureArray:inout [SKTexture]){
    //load moving texture
    let bearAnimatedAtlas = SKTextureAtlas(named:folderName)
    var walkFrames: [SKTexture] = []
    
    let numImages = bearAnimatedAtlas.textureNames.count
    for i in 1...numImages {
      let bearTextureName = "\(imageName)\(i)"
      walkFrames.append(bearAnimatedAtlas.textureNamed(bearTextureName))
    }
    textureArray = walkFrames
  }
  
  func updateBackground(level:Int) -> Bool {
    let maxLevel = ScenesData.resource.count-1
    if 0 <= level&&level <= maxLevel {//在范围之内
      self.sceneNumber = level
      return true
    }
    return false
  }
  
  //MARK: - man's move
  func moveMan(toRight:Bool) {
    if isDoingAction {return}
    runingDirectionToRight = toRight
    man.xScale = toRight ? 1 : -1
    animateMan()
  }
  
  func jump() {
    if isDoingAction||isJumping {return}
    man.physicsBody!.applyImpulse(CGVector(dx: 0, dy: GameSetting.jumpHeight))
  }
  
  func attack(punch:Bool)  {
    //正在执行动作
    if isDoingAction||isJumping {return}
    //animation
    cancelMove()
    if punch{
      punchAnimation()
    }else{
      kickAnimation()
    }
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.29*Double(NSEC_PER_SEC)))/Double(NSEC_PER_SEC)) {
      //code
      self.checkAttackAffect(punch: punch)
    }
    
  }
  
  func checkAttackAffect(punch:Bool){
    
    for monster in monsters {
      if monster.isAlive {
        //物理判断（击打声音）
        
        //效果判断
        let faceToRight = man.xScale == 1
        let hitDistance = punch ? GameSetting.punchDistance : GameSetting.kickDistance
        let hitPointX = man.position.x+(faceToRight ? hitDistance : -hitDistance)
        //单个monster判断
        let hitMoster = checkXDistanceBetween(hitX: hitPointX,
                                              monsterLeft: monster.frame.minX, monsterRight: monster.frame.maxX)
        if hitMoster {
          //击中操作
          let monsterInRight = man.position.x < monster.position.x
          monster.position.x += monsterInRight ? 100 : -100
          monster.canBeHit! -= 1
        }
      }
    }
    
    
  }
  
  
  func kickAnimation() {
    man.run(SKAction.animate(with: kickingTextures,
                             timePerFrame: 0.06,
                             resize: true,
                             restore: true),
            withKey:"kick")
  }
  
  func punchAnimation() {
    man.run(SKAction.animate(with: punchingTextures,
                             timePerFrame: 0.08,
                             resize: true,
                             restore: true),
            withKey:"punch")
  }
  
  func animateMan() {
    man.run(SKAction.repeatForever(
      SKAction.animate(with: manWalkingFrames,
                       timePerFrame: 0.12,
                       resize: false,
                       restore: false)),
            withKey:"walk")
    //    print("man size \(man.size)")
  }
  
  func updateManPosition()  {
    if isDoingAction {return}
    let position = man.position.x
    //边缘判断
    if position < leftMaxDistance {
      if updateBackground(level: sceneNumber-1){
        //更改背景
        clearScreen()
        loadBackground()
        //更改角色
        man.position.x = rightMaxDistance
      }
      //在边界堵住
      if runingDirectionToRight == false{
        return
      }
    }
    
    if position > rightMaxDistance {
      if sceneNumber+1<=maxSceneCanReach,updateBackground(level: sceneNumber+1){
        //更改图像
        clearScreen()
        loadBackground()
        //更改角色
        man.position.x = leftMaxDistance
      }
      //在边界堵住
      if runingDirectionToRight == true{
        return
      }
    }
    //    print(leftMaxDistance,"",position," ",rightMaxDistance)
    
    if let direction = runingDirectionToRight{
      if direction {
        man.position.x += GameSetting.manRuningspeed
      }else{
        man.position.x -= GameSetting.manRuningspeed
      }
    }
  }
  
  func stopMoving() {
    if !isDoingAction {
      cancelMove()
    }
  }
  
  //MARK: - Monster code
  
  func updateMonster() {//抓人
//    let monsterMaxLeft = leftMaxDistance
//    let monsterMaxRight = rightMaxDistance
    for monster in monsters {
      if monster.isAlive {
        let inRightSide = man.position.x > monster.position.x
        if inRightSide {
          monster.xScale = 1
          monster.position.x += monster.moveSpeed
        }else{
          monster.xScale = -1
          monster.position.x -= monster.moveSpeed
        }
      }
    }
  }
  
  func checkCrash(){
    
    for monster in monsters {
      if monster.isAlive {
        let manFrame = man.frame.insetBy(dx: 40, dy: 0)
        let monsterFrame = monster.frame.insetBy(dx: 40, dy: 0)
        
        if manFrame.intersects(monsterFrame) {
          let monsterInRight = man.position.x < monster.position.x
          man.beingHit(fromRight: monsterInRight, lossblood: monster.hurt)
        }
      }
    }
  }
  
  
  //MARK: - clear code
  
  func clearScreen() {
    background.removeFromParent()
  }
  
  func cancelMove() {
    runingDirectionToRight = nil
    man.removeAllActions()
  }
  
  // MARK: - Handle touches
  
  
  override func update(_ currentTime: TimeInterval) {
    checkCrash()
    updateManPosition()
    updateMonster()
    man.checkPostion()
  }
  
  //MARK: Tool Method
  
  func checkXDistanceBetween(hitX:CGFloat,monsterLeft:CGFloat,monsterRight:CGFloat) -> Bool {
    if ( monsterLeft<hitX && hitX<monsterRight) {
      return true
    }else{
      return false
    }
  }
  
}
