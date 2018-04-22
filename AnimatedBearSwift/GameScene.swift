
//Bug 记录

import SpriteKit

class GameScene: SKScene {
  
  var sceneNumber = 0
  var resourceDictionary:[String:Any] {
    return ScenesData.getResource(scenesNumber: sceneNumber)
  }
  
  private var man = SKSpriteNode()
  private var background = SKSpriteNode()
  private var manWalkingFrames: [SKTexture] = []
  private var kickingTextures:[SKTexture] = []
  private var punchingTextures:[SKTexture] = []
  
  //testing
  private var cuteMonster = SKSpriteNode()
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
    physicsBody = SKPhysicsBody(edgeFrom:CGPoint(x:-2000,y:440),to:CGPoint(x:2000,y:440))
    self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
    print(frame)
//    buildGravity()
//    buildGround()
    buildMan()
//    buildMonster()
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
    man = SKSpriteNode(texture: firstFrameTexture)
    man.position = CGPoint(x: GameSetting.manStartPointX,
                           y: GameSetting.manStartPointY)
//    man.size = GameSetting.manSize
    man.zPosition = 2.0
    //创建物理属性
    man.physicsBody = SKPhysicsBody(rectangleOf: man.size, center: man.position)
    man.physicsBody!.affectedByGravity = true
    man.physicsBody!.allowsRotation = false
    addChild(man)
  
  }
  //testing
  func buildMonster() {
    loadTexture(folderName: "cuteMonsterTexture", imageName: "monster", textureArray: &cuteMonsterTextures)
    
    let firstFrameTexture = cuteMonsterTextures[0]
    cuteMonster = SKSpriteNode(texture: firstFrameTexture)
    cuteMonster.position = CGPoint(x: frame.midX+100, y: 240)
    cuteMonster.zPosition = 3.0
    
    addChild(cuteMonster)
    
    cuteMonster.run(SKAction.repeatForever(SKAction.animate(with: cuteMonsterTextures, timePerFrame: 0.14, resize: true, restore: false)))
 
  }
  
//  func buildGravity()  {
//    let gravity = SKFieldNode.linearGravityField(withVector:float3(0,-9.8,0))
//    gravity.region = SKRegion(size: CGSize(width: 300, height: 300))
//    gravity.isEnabled = true
//    gravity.position = CGPoint(x: frame.midX, y: frame.midY)
//    addChild(gravity)
//  }
//
//  func buildGround() {
//    let ground = SKSpriteNode(color: UIColor.black, size: CGSize(width:frame.width,height:30))
//    ground.position = CGPoint(x:frame.minX,y:50)
//    ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size, center: ground.position)
//    ground.zPosition = 4.0
//    ground.physicsBody!.affectedByGravity = false
//    ground.physicsBody!.allowsRotation = false
//    addChild(ground)
//  }
  
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
    print("doing Action \(isDoingAction)")
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
    //物理判断（击打声音）
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
    print("man size \(man.size)")
  }
  
  func updateManPosition()  {
    if isDoingAction {return}
    let position = man.position.x
    //边缘判断
    if position < leftMaxDistance{
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
    
    if position > rightMaxDistance{
      if updateBackground(level: sceneNumber+1){
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
  
  //MARK: - clear code
  
  func clearScreen() {
    background.removeFromParent()
  }
  
  func cancelMove() {
    runingDirectionToRight = nil
    man.removeAllActions()
  }
  
  // MARK: - Handle touches
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//    if event?.allTouches?.count == 1 {
//      let location = touches.first!.location(in: self)
//      if location.x > frame.midX {
//        moveMan(toRight: true)
//      } else {
//        moveMan(toRight: false)
//      }
//    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//    cancelMove()
  }
  
  override func update(_ currentTime: TimeInterval) {
    updateManPosition()
    print(man.physicsBody!.velocity)
  }
  
}
