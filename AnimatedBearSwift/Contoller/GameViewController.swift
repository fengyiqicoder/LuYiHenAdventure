
import UIKit
import SpriteKit

var scene:GameScene!

class GameViewController: UIViewController,ScenseDelegate {
  
  @IBOutlet weak var bloodBar: bloodBar!
  @IBOutlet weak var LevelName: UILabel!
  @IBOutlet weak var goToRighSceneImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    restartGame()
//    if let view = view as? SKView {
//      // Create the scene programmatically
//      scene = GameScene(size: view.bounds.size)
//      scene.viewControllerDelegate = self
//      scene.scaleMode = .resizeFill
//      view.ignoresSiblingOrder = true
//      view.showsFPS = true
//      view.showsNodeCount = true
//      view.presentScene(scene)
//      bloodBar.blood = 100
//      //获取关卡名称
//      let name = GameSetting.levelName[0]
//      LevelName.text = name
//    }
  }
  
  @IBOutlet weak var gameRestartButton: UIButton!
  @IBOutlet weak var gameWinningImageView: UIImageView!
  @IBOutlet weak var gameOverImageView: UIImageView!
  //游戏结束
  func manDead(){
    if let view = view as? SKView{
      view.presentScene(nil)
    }
    gameRestartButton.isHidden = false
    gameOverImageView.isHidden = false
  }
  
  //关卡重启
  @IBAction func restartGame() {
    gameRestartButton.isHidden = true
    gameOverImageView.isHidden = true
    if let view = view as? SKView {
      scene = GameScene(size: view.bounds.size)
      scene.viewControllerDelegate = self
      scene.scaleMode = .resizeFill
      view.ignoresSiblingOrder = true
      view.showsFPS = true
//      view.showsNodeCount = true
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
  
  func showNextSceneImage() {
    goToRighSceneImageView.isHidden = false
  }
  
  func hiddenNextSceneImage() {
    goToRighSceneImageView.isHidden = true
  }
  
  func winTheGame() {
    //停止游戏运行
    if let view = view as? SKView{
      view.presentScene(nil)
    }
    gameWinningImageView.isHidden = false
  }
  
}

protocol ScenseDelegate:class {
  func changeLevelName(newName:String)
  func changeBloodBar(value:Int)
  func showNextSceneImage()
  func hiddenNextSceneImage()
  func manDead()
  func winTheGame()
}
