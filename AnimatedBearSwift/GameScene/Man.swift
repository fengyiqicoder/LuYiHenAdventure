//
//  Man.swift
//  AnimatedBearSwift
//
//  Created by 冯奕琦 on 2018/4/23.
//  Copyright © 2018年 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Man:SKSpriteNode  {
  
  weak var bloodBarDelegate:ScenseDelegate!
  weak var soundDelegate:SoundPlayDelegate!
  
  var flying = false

  func checkPostion() {
    if position.x < -10 , !flying {
      fly(fromLeft: true)
      flying = true
    } else if position.x > 1040 , !flying{
      fly(fromLeft: false)
      flying = true
    }else{
      flying = false
    }
  }


  func fly(fromLeft:Bool)  {
    let xDistance = fromLeft ? 1000 : -1000
    super.physicsBody?.applyImpulse(CGVector(dx: xDistance, dy: 2000))
  }
 
  //血量
  var blood:Int = 100{
    didSet{
      if blood < 0 {
        //游戏结束
        blood = 0
        bloodBarDelegate.manDead()
        //声音
        soundDelegate.stopBackGroundMusic()
        run(SKAction.playSoundFileNamed("gameOver.wav", waitForCompletion: false))
      }
      //更新血条
      bloodBarDelegate.changeBloodBar(value: blood)
    }
  }
  
  var alive:Bool {
    return blood <= 0
  }
  
  func beingHit(fromRight:Bool,lossblood:Int) {
    
    let xImpuseValue = fromRight ? -GameSetting.beingHitJumpDistance : GameSetting.beingHitJumpDistance
    //animation
    self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    self.physicsBody?.applyImpulse(CGVector(dx: xImpuseValue, dy: GameSetting.beingHitJumpHeight))
    //掉血
    self.blood -= lossblood
    //声音
    run(SKAction.playSoundFileNamed("manGetHit.wav", waitForCompletion: false))
  }
  
  
  
  
  
}
