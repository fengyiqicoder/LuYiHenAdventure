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

class man:SKSpriteNode  {
  
  //血量
  var blood:Int = 100{
    didSet{
      if blood > 100 {
        blood = 100
      }
    }
  }
  
  var alive:Bool {
    return blood <= 0
  }
  
  
  
  
}
