/**
 * GameScene.swift
 * AnimatedBearSwift
 *
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import SpriteKit

class GameScene: SKScene {
  
  var sceneNumber = 0
  var resourceDictionary:[String:Any] {
    return ScenesData.getResource(scenesNumber: sceneNumber)
  }
  
  private var man = SKSpriteNode()
  private var background = SKSpriteNode()
  private var manWalkingFrames: [SKTexture] = []
  
  //边缘
  lazy var rightMaxDistance:CGFloat =  { [unowned self] in return self.size.width  }()
  var leftMaxDistance:CGFloat = 0
  
  //states
  var runingDirectionToRight:Bool?
  
  override func didMove(to view: SKView) {
    backgroundColor = .blue
    buildMan()
    loadBackground()
    print("something")
  }
  //MARK: - loadCode
  
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
    let bearAnimatedAtlas = SKTextureAtlas(named: "manTexture")
    var walkFrames: [SKTexture] = []
    
    let numImages = bearAnimatedAtlas.textureNames.count
    for i in 1...numImages {
      let bearTextureName = "walk\(i)"
      walkFrames.append(bearAnimatedAtlas.textureNamed(bearTextureName))
    }
    manWalkingFrames = walkFrames
    
    let firstFrameTexture = manWalkingFrames[0]
    man = SKSpriteNode(texture: firstFrameTexture)
    man.position = CGPoint(x: frame.midX-100, y: 320)
    man.zPosition = 2.0
    
    addChild(man)
  }
  
  func updateBackground(level:Int) -> Bool {
    let maxLevel = ScenesData.resource.count-1
    print("maxLevel \(maxLevel)")
    if 0 <= level&&level <= maxLevel {//在范围之内
      self.sceneNumber = level
      return true
    }
    return false
  }
  
  //MARK: - man's move
  func moveMan(toRight:Bool) {
    
    runingDirectionToRight = toRight
    man.xScale = toRight ? 1 : -1
    animateMan()
  }
  
  func animateMan() {
    man.run(SKAction.repeatForever(
      SKAction.animate(with: manWalkingFrames,
                       timePerFrame: 0.1,
                       resize: false,
                       restore: false)),
             withKey:"walkingMan")
  }
  
  func updateManPosition()  {
    
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
  }
  
}
