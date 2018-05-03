
import UIKit
import SpriteKit
import AVKit

var scene:GameScene!

class GameViewController: UIViewController,ScenseDelegate {
  
  @IBOutlet weak var bloodBar: bloodBar!
  @IBOutlet weak var LevelName: UILabel!
  @IBOutlet weak var goToRighSceneImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if isFirstLaunch(){
      playVideoAndStartGame()
    }else{
      restartGame()
    }
  }
  func isFirstLaunch() -> Bool {
    if !(UserDefaults.standard.bool(forKey: "HasLaunchedOnce")) {
      // This is the first launch ever
      print("my first time launch")
      //set date to today and date value
      UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")//set the launch value
      return true
    }
    return false
  }
  //游戏开始
  var playerLayer:AVPlayerLayer!
  var blackBackGroundView:UIView!
  func playVideoAndStartGame(){
    //定义一个视频文件路径
    let filePath = Bundle.main.path(forResource: "gameStartVideo", ofType: "mp4")
    let videoURL = URL(fileURLWithPath: filePath!)
    //定义一个playerItem，并监听相关的通知
    let playerItem = AVPlayerItem(url: videoURL)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(playerDidFinishPlaying),
                                           name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                           object: playerItem)
    //定义一个视频播放器，通过playerItem径初始化
    let player = AVPlayer(playerItem: playerItem)
    //设置大小和位置（全屏）
    playerLayer = AVPlayerLayer(player: player)
    playerLayer.frame = self.view.bounds
    //添加背景
    blackBackGroundView = UIView(frame: self.view.bounds)
    blackBackGroundView.backgroundColor = UIColor.black
    self.view.addSubview(blackBackGroundView)
    //添加到界面上
    self.view.layer.addSublayer(playerLayer)
    //开始播放
    player.play()
  }
  
  @objc func playerDidFinishPlaying(){
    blackBackGroundView.removeFromSuperview()
    playerLayer.removeFromSuperlayer()
    restartGame()
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
      //完成之后进行更改
//      view.showsFPS = true
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
