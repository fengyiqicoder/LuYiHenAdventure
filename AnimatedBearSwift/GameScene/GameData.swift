//
//  GameData.swift
//  AnimatedBearSwift
//
//  Created by 冯奕琦 on 2018/4/9.
//  Copyright © 2018年 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit

struct ScenesData {
  //每个场景的元素
  static let resource:[[String:Any]] = [
    ["background":"Background1-1" ],
    ["background":"Background1-2"],
    ["background":"Background2-1"],
    ["background":"Background2-2"],
    ["background":"Background3-1"],
    ["background":"Background3-2"],
    ["background":"Background4-1"],
    ["background":"Background4-2"]
  ]
  
  //获取元素
  static func getResource(scenesNumber:Int)->[String:Any]{
    return ScenesData.resource[scenesNumber]
  }
  
}

struct GameSetting {
  static let screenSize = UIScreen.main.bounds.size
  static let manRuningspeed:CGFloat = GameSetting.screenSize.width*0.012
  static let runningAnimateSpeed:TimeInterval = 0.08
  static let manStartPointX:CGFloat =
    GameSetting.screenSize.width*0.3
  static let manStartPointY:CGFloat = GameSetting.screenSize.height*0.4
  static let jumpHeight:CGFloat = 2000
  static let beingHitJumpDistance:CGFloat = 300
  static let beingHitJumpHeight:CGFloat = 900
  
  static let punchDistance:CGFloat = 130
  static let kickDistance:CGFloat = 140

  static let levelName = ["紫色秘境","希望田野","绝望戈壁","决战黄昏"]
}

