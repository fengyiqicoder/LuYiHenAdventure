//
//  bloodBar.swift
//  AnimatedBearSwift
//
//  Created by 冯奕琦 on 2018/4/23.
//  Copyright © 2018年 Ray Wenderlich. All rights reserved.
//

import UIKit

class bloodBar: UIView {
  
  @IBOutlet weak var fullBloodBarView: UIView!
  @IBOutlet weak var bloodBarView: UIView!
  @IBOutlet weak var bloodBarWeight: NSLayoutConstraint!
  
  var blood:Int = 100{
    didSet{
      if (blood<=100)&&(blood>=0){
        let radio = 1-CGFloat(blood)/CGFloat(100)
        let constant:CGFloat = -(radio*bloodBarFullWidth)
        bloodBarWeight.constant = constant
        //Animation loss
      }else{
        print("超出范围")
      }
    }
  }
  var bloodBarFullWidth:CGFloat{
    return fullBloodBarView.bounds.width
  }
  
  
  //连接代码
  var view:UIView!
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  func setup() { //加入xib中的view
    view = loadXibView()
    view.backgroundColor = UIColor.clear
    addSubview(view)
  }
  func loadXibView() -> UIView { //获取view
    let bundle = Bundle(for: type(of:self))
    let file = UINib(nibName: "bloodBar", bundle: bundle)//修改bundle
    let view = file.instantiate(withOwner: self, options: nil)[0] as! UIView
    return view
  }

   
}
