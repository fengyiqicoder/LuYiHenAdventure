//
//  MonsterSpecies.swift
//  AnimatedBearSwift
//
//  Created by 冯奕琦 on 2018/4/23.
//  Copyright © 2018年 Ray Wenderlich. All rights reserved.
//  Model

import Foundation
import UIKit
import SpriteKit

class MonsterSpecies {
//属性
  var amount:Int
  
  private var moveSpeedAround:CGFloat
  private var speedFloating:CGFloat
  var speed:CGFloat{//每次返回不同的速度
    let eachGearSpeed = speedFloating/4
    let gear = CGFloat(arc4random_uniform(5))
    return eachGearSpeed*gear+moveSpeedAround
  }
  
  var hurt:Int
  var canBeHit:Int
  var Ypostion:CGFloat
//spriteNode
  var textureName:String
  var imageName:String
  var faceLeft:Bool
  var animationTime:TimeInterval
  
  init(amount:Int,speed:CGFloat,speedFloating:CGFloat,hurt:Int,
       canBeHit:Int,textureName:String,imageName:String,Ypostion:CGFloat,
       faceLeft:Bool,animationTime:TimeInterval) {
    self.amount = amount
    self.moveSpeedAround = speed
    self.speedFloating = speedFloating
    self.hurt = hurt
    self.canBeHit = canBeHit
    self.textureName = textureName
    self.imageName = imageName
    self.Ypostion = Ypostion
    self.faceLeft = faceLeft
    self.animationTime = animationTime
  }
  
}

class Monster: SKSpriteNode {
  
  //MARK:SpriteNode
  var textureArray:[SKTexture]!
  var YPostion:CGFloat{
    get{
      return position.y
    }
    set{
      position.y = newValue
    }
  }
  var showingFromRight:Bool!
  
  //MARK:数值
  var hurt:Int!
  var moveSpeed:CGFloat!
  var animationTime:TimeInterval!
  
  var canBeHit:Int!{
    didSet{
      if canBeHit <= 0 {
        isAlive = false
      }
    }
  }
  var isAlive:Bool = true{
    didSet{
      if !isAlive {
        //删除这个SpriteNode
        run(SKAction.fadeAlpha(to: 0, duration: 0.6), completion: {
          self.removeFromParent()
        })
      }
    }
  }
  
  //MARK: - Method
  
  convenience init(texture:SKTexture,textureArray:[SKTexture],yPosition:CGFloat,showFromRight:Bool,hurt:Int,speed:CGFloat,canBeHit:Int,animationTime:TimeInterval) {
    self.init(texture: texture)
    self.textureArray = textureArray
    self.YPostion = yPosition
    self.hurt = hurt
    self.moveSpeed = speed
    self.canBeHit = canBeHit
    self.zPosition = 2.0
    self.animationTime = animationTime
    
    self.showingFromRight = showFromRight
    if showingFromRight{
      position.x = 1120
    }else{
      position.x = 0-size.width
    }
  }
  
  override init(texture: SKTexture?, color: UIColor, size: CGSize) {
    super.init(texture: texture, color: color, size: size)
  }
  
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func runAnimation() {
    run(SKAction.repeatForever(SKAction.animate(with: textureArray, timePerFrame: animationTime, resize: true, restore: false)))
  }
  
}
