//
//  ViewController.swift
//  Ryukito_AR
//
//  Created by 又吉琉稀斗 on 2020/05/26.
//  Copyright © 2020 又吉琉稀斗. All rights reserved.
//
import UIKit
import SceneKit
import ARKit

extension UIColor {
    class func rgba(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}

class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate{

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ワイヤーフレームを表示
        //sceneView.debugOptions = .showWireframe
        //シーンビューのデリゲートになる
        sceneView.delegate = self
        //fpsなどを表示
        sceneView.showsStatistics = true
        //シーンを作る
        let scene = SCNScene()
        sceneView.scene = scene
        scene.physicsWorld.contactDelegate = self
        
        CreateObj(0,1,-2.3,0,255,255,1,"target1")
        CreateObj(-0.3,1,-2.0,0,255,255,1,"target2")
        CreateObj(0.3,1,-2.0,0,255,255,1,"target3")
        //CreateObj(0,1,-2.0)
        //CreateObj(0,1,-1.7)
        //CreateObj(0,1,2.3)
        //CreateObj(-0.3,1,2.0)
        //CreateObj(0.3,1,2.0)
        /*CreateObj(0,1,-2.3)
        CreateObj(-0.3,1,-2.0)
        CreateObj(0.3,1,-2.0)
        CreateObj(0,1,-2.3)
        CreateObj(-0.3,1,-2.0)
        CreateObj(0.3,1,-2.0)*/
        setFloor()
        CreateBox(0,0,-2.3,128,128,128,1)
        CreateBox(-0.3,0,-2.0,128,128,128,1)
        CreateBox(0.3,0,-2.0,128,128,128,1)
        //CreateBox(0,0,-2.0)
        //CreateBox(0,0,-1.7)
        //CreateBox(0,0,2.3)
        //CreateBox(-0.3,0,2.0)
        //CreateBox(0.3,0,2.0)
        /*CreateBox(0,0,-2.3)
        CreateBox(-0.3,0,-2.0)
        CreateBox(0.3,0,-2.0)
        CreateBox(0,0,-2.3)
        CreateBox(-0.3,0,-2.0)
        CreateBox(0.3,0,-2.0)*/
        CreateTarget()
        
        
    }
    @IBOutlet weak var testlab: UILabel!
    
    func CreateTarget() {
        
    }
    
    func CreateObj(_ positionX: Float,_ positionY: Float,_ positionZ: Float,_ red: Int,_ green: Int,_ blue: Int,_ alpha: Int,_ NodeName: String) {
        //球体を生成 --rediusは半径
        let TargetObj = SCNBox(width: 0.1, height: 0.3, length: 0.1, chamferRadius: 0)
        //マテリアル（表面）を生成する
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.rgba(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
        TargetObj.materials = [material]
        
        //物理情報の設定
        let physicsShape = SCNPhysicsShape(geometry: TargetObj, options: nil)
        let sphereBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        sphereBody.restitution = 0
        sphereBody.physicsShape = physicsShape
        
        let sphereNode = SCNNode(geometry: TargetObj)
        sphereNode.position = SCNVector3(positionX, positionY, positionZ)
        sphereNode.name = NodeName
        //Body情報をノードにセット
        sphereNode.physicsBody = sphereBody
        //AR空間に球体を追加
        sceneView.scene.rootNode.addChildNode(sphereNode)
    }
    
    func setFloor() {
        let floor = SCNFloor()
        floor.reflectivity = 0.1
        //マテリアル（表面）を生成する
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.clear
        floor.materials = [material]
        //Body情報を設定 --物理設定
        let floorShape = SCNPhysicsShape(geometry: floor, options: nil)
        let floorBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        floorBody.physicsShape = floorShape
        //ノードを設定
        let floorNode = SCNNode(geometry: floor)
        floorNode.position = SCNVector3(0,-1,0)
        floorNode.name = "floor"
        //Body情報をノードにセット
        floorNode.physicsBody = floorBody
        //AR空間に球体を追加
        sceneView.scene.rootNode.addChildNode(floorNode)
       }
    
    func CreateBox(_ positionX: Float,_ positionY: Float,_ positionZ: Float,_ red: Int,_ green: Int,_ blue: Int,_ alpha: Int) {
        //箱を作成
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        //マテリアル
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.rgba(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
        box.materials = [material]
        //物理情報の設定
        let physicsShape = SCNPhysicsShape(geometry: box, options: nil)
        let boxBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        boxBody.restitution = 1.0
        boxBody.physicsShape = physicsShape
        //目の前1メートルの場所に置く
        let boxNode = SCNNode(geometry: box)
        boxNode.position = SCNVector3(positionX, positionY, positionZ)
        boxNode.name = "stand"
        //Body情報をノードにセット
        boxNode.physicsBody = boxBody
        //AR空間に球体を追加
        sceneView.scene.rootNode.addChildNode(boxNode)
        
    }
    
    @objc func ShotType(_ BulletSize: Float,_ BulletColor: Any,_ BulletRange: Float,_ BulletVelocity: Double) {
        //弾を生成 --rediusは半径
        let bullet = SCNSphere(radius: CGFloat(BulletSize))
        let bulletNode = SCNNode(geometry: bullet)
        bulletNode.name = "Tama"
        //物理情報の設定
        let physicsBullet = SCNPhysicsShape(geometry: bullet, options: nil)
        let BulletBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        BulletBody.restitution = 1
        BulletBody.physicsShape = physicsBullet
        bulletNode.physicsBody?.isAffectedByGravity = false
        //接触を検知する処理
        BulletBody.contactTestBitMask = 1
        BulletBody.collisionBitMask = 1
        //BulletBody.categoryBitMask = 1
        //マテリアル（表面）を生成する
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.black
        bullet.materials = [material]
        guard let camera = sceneView.pointOfView else {
           return
        }
        //発射時の弾の位置　--カメラの位置
        bulletNode.position = camera.position
        //着弾後の弾の位置
        let targetPosCamera = SCNVector3Make(0, 0, BulletRange)
        let target = camera.convertPosition(targetPosCamera, to: nil)
        //着弾まで?秒間かかるアニメーション
        let action = SCNAction.move(to: target, duration: TimeInterval(BulletVelocity))
        bulletNode.runAction(action)
        //Body情報をノードにセット
        bulletNode.physicsBody = BulletBody
        //AR空間に球体を追加
        sceneView.scene.rootNode.addChildNode(bulletNode)
        //発射から?秒後に弾を削除
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + BulletVelocity) {
          bulletNode.removeFromParentNode()
        }
    }
    
    // ボタンを押すと弾を発射 --ハンドガン
    @IBAction func shot(_ sender: Any) {
        ShotType(0.005, "black", -7.0, 1.8)
    }
    @objc func MachineGun () {
        ShotType(0.005, "red", -4.5, 1.8)
    }
    
    // ボタンを押すと弾を発射 --マシンガン
    var timer: Timer?
    @IBAction func TapDown(_ sender: Any) {
        self.timer = Timer.scheduledTimer( //TimerクラスのメソッドなのでTimerで宣言
          timeInterval: 0.1, //処理を行う間隔の秒
          target: self,  //指定した処理を記述するクラスのインスタンス
            selector: #selector(self.MachineGun), //実行されるメソッド名
          userInfo: nil, //selectorで指定したメソッドに渡す情報
          repeats: true //処理を繰り返すか否か
        )
    }
    @IBAction func TapUp(_ sender: Any) {
        self.timer?.invalidate()
    }
    
    //接触を検知したらテキストを表示
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        
        self.testlab.text = nodeB.name! + " が " + nodeA.name! + " に当たった！!！ "
        

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //セッションのコンフィグを作る
        let configuration = ARWorldTrackingConfiguration()
        //環境マッピングを有効にする
        configuration.environmentTexturing = .automatic
        //平面の検出を有効化 --今回は特に意味なし
        //configuration.planeDetection = .horizontal
        //セッションを開始
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //セッションを停止
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    
        
    /*
        // Override to create and configure nodes for anchors added to the view's session.
        func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
            let node = SCNNode()
         
            return node
        }
    */
        
        func session(_ session: ARSession, didFailWithError error: Error) {
            // Present an error message to the user
            
        }
        
        func sessionWasInterrupted(_ session: ARSession) {
            // Inform the user that the session has been interrupted, for example, by presenting an overlay
            
        }
        
        func sessionInterruptionEnded(_ session: ARSession) {
            // Reset tracking and/or remove existing anchors if consistent tracking is required
            
        }
    
}

