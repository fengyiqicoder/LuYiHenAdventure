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
    ["background":"Background1",
     "emeny":"toothBrush",
      "emenyLevel":1],
    ["background":"Background2"]
  ]
  
  //获取元素
  static func getResource(scenesNumber:Int)->[String:Any]{
    return ScenesData.resource[scenesNumber]
  }
  
}

struct GameSetting {
  static let manRuningspeed:CGFloat = 10
  static let runningAnimateSpeed:TimeInterval = 0.1
}

