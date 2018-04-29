
import UIKit
import SpriteKit

var scene:GameScene!

class GameViewController: UIViewController,ScenseDelegate {
  
  @IBOutlet weak var bloodBar: bloodBar!
  @IBOutlet weak var LevelName: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let view = view as? SKView {
      // Create the scene programmatically
      scene = GameScene(size: view.bounds.size)
      scene.viewControllerDelegate = self
      scene.scaleMode = .resizeFill
      view.ignoresSiblingOrder = true
      view.showsFPS = true
      view.showsNodeCount = true
      view.presentScene(scene)
      bloodBar.blood = 100
      //获取关卡名称
      let name = GameSetting.levelName[0]
      LevelName.text = name
    }
  }
  
  @IBAction func moveMan(_ sender: UIButton) {
//    print("move")
    if sender.tag == 1 {
      scene.moveMan(toRight: false)
    }else{
      scene.moveMan(toRight: true)
    }
  }
  
  @IBAction func StopMan(_ sender: UIButton) {
//    print("stop")
    scene.stopMoving()
  }
  
  @IBAction func attack(_ sender:UIButton){
    if sender.tag == 1 {
      scene.attack(punch: false)
    }else{
      scene.attack(punch: true)
    }
  }
  
  @IBAction func jump(){
    scene.jump()
  }
  
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  func changeLevelName(newName: String) {
    self.LevelName.text = newName
  }
  
  func changeBloodBar(value: Int) {
    bloodBar.blood = value
  }
  
}

protocol ScenseDelegate:class {
  func changeLevelName(newName:String)
  func changeBloodBar(value:Int)
}
