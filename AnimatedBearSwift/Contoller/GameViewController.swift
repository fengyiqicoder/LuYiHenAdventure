
import UIKit
import SpriteKit

var scene:GameScene!

class GameViewController: UIViewController {
  
  @IBOutlet weak var bloodBar: bloodBar!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let view = view as? SKView {
      // Create the scene programmatically
      scene = GameScene(size: view.bounds.size)
      scene.scaleMode = .resizeFill
      view.ignoresSiblingOrder = true
      view.showsFPS = true
      view.showsNodeCount = true
      view.presentScene(scene)
      bloodBar.blood = 78
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
}
