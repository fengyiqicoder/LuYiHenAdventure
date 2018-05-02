//
//  GameData.swift
//  AnimatedBearSwift
//
//  Created by 冯奕琦 on 2018/4/9.
//  Copyright © 2018年 Ray Wenderlich. All rights reserved.
//"Mosters":MonsterSpecies(amount:3,speed:4,speedFloating:2,hurt:5,canBeHit:3,
//textureName:"cuteMonsterTexture",imageName:"monster",Ypostion:240)

import Foundation
import UIKit

struct ScenesData {
  //每个场景的元素
  static let resource:[[String:Any]] = [
    ["background":"Background1-1",
     "Mosters":MonsterSpecies(amount:3,speed:4,speedFloating:2,hurt:3,canBeHit:3,
                              textureName:"cuteMonsterTexture",imageName:"monster",Ypostion:240,
                              faceLeft:false,animationTime:0.14)
    ],
    ["background":"Background1-2",
     "Mosters":MonsterSpecies(amount:5,speed:4,speedFloating:2,hurt:3,canBeHit:3,
                              textureName:"cuteMonsterTexture",imageName:"monster",Ypostion:240,
                              faceLeft:false,animationTime:0.12)
    ],
    ["background":"Background2-1",
     "Mosters":MonsterSpecies(amount:3,speed:4,speedFloating:3,hurt:4,canBeHit:4,
                              textureName:"blueMonster",imageName:"blueMonster",Ypostion:270,
                              faceLeft: false,animationTime:0.09)],
    ["background":"Background2-2",
     "Mosters":MonsterSpecies(amount:4,speed:4,speedFloating:3,hurt:4,canBeHit:4,
                              textureName:"blueMonster",imageName:"blueMonster",Ypostion:270,
                              faceLeft: false,animationTime:0.1)],
    ["background":"Background3-1",
     "Mosters":MonsterSpecies(amount:3,speed:4,speedFloating:2,hurt:3,canBeHit:3,
                              textureName:"greenMonster",imageName:"greenMonster",Ypostion:240,
                              faceLeft:false,animationTime:0.12)
     ],
    ["background":"Background3-2",
     "Mosters":MonsterSpecies(amount:4,speed:4,speedFloating:2,hurt:3,canBeHit:3,
                              textureName:"greenMonster",imageName:"greenMonster",Ypostion:240,
                              faceLeft:false,animationTime:0.09)
     ],
    ["background":"Background4-1",
     "Mosters":MonsterSpecies(amount:1,speed:6,speedFloating:2,hurt:3,canBeHit:2,
                              textureName:"boss",imageName:"",Ypostion:310,
                              faceLeft: true,animationTime:0.16)
    ],
    ["background":"Background4-2",
     "Mosters":MonsterSpecies(amount:2,speed:6,speedFloating:2,hurt:3,canBeHit:2,
                              textureName:"boss",imageName:"",Ypostion:310,
                              faceLeft: true,animationTime:0.16)
    ]
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
  
  static let winningScenceNumber = 9
}

