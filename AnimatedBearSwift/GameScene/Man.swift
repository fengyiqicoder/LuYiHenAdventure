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
 
  //血量
  var blood:Int = 100{
    didSet{
      if blood < 0 {
        //游戏结束
        blood = 0
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
    self.physicsBody?.applyImpulse(CGVector(dx: xImpuseValue, dy: GameSetting.beingHitJumpHeight))
    //掉血
    self.blood -= lossblood
  }
  
  
  
}
