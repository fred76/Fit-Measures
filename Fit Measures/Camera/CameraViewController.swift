//
//  CameraViewController.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 29/11/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

import UIKit
import AVFoundation
import SceneKit
import ARKit



class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    private enum UserPictureMode {
        case undefined
        case selfie
        case aReality
    }
    private var userPictureMode = UserPictureMode.undefined
    var multipiler : CGFloat!
    @IBOutlet var shootButton: UIButton!
    @IBOutlet weak var captureImageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var buttonAR: UIBarButtonItem!
    @IBOutlet var buttonSelfie: UIBarButtonItem!
    
    var planes = [UUID: VirtualPlane]() {
        didSet {
            if planes.count > 0 {
                currentCaffeineStatus = .ready
            } else {
                if currentCaffeineStatus == .ready { currentCaffeineStatus = .initialized }
            }
        }
    }
    
    @IBOutlet var intitalView: UIView!
    var currentCaffeineStatus = ARCoffeeSessionState.initialized {
        didSet {
            DispatchQueue.main.async {
                self.statusLabel.text = self.currentCaffeineStatus.description
                
            }
            if currentCaffeineStatus == .failed {
                cleanupARSession()
            }
        }
    }
    var selectedPlane: VirtualPlane?
    var mugNode: SCNNode!
    var captureSession : AVCaptureSession!
    var stillImageOutput : AVCapturePhotoOutput!
    var videoPreviewLayer : AVCaptureVideoPreviewLayer!
    var countdownTimer: Timer!
    var totalTime = 7
    override func viewDidLoad() {
        super.viewDidLoad()
        if (ARConfiguration.isSupported) {
            self.navigationController?.toolbar.isTranslucent = false
            self.navigationController?.toolbar.barTintColor = UIColor.clear
            if UserDefaultsSettings.serchForKey(kUsernameKey: "height") {
                multipiler = CGFloat(UserDefaultsSettings.heightSet/100)
                print(UserDefaultsSettings.heightSet)
            } else {
                multipiler = 1.7
            }
            shootButton.isHidden = true
            self.navigationController?.isToolbarHidden = false
            
        } else {
            intitalView.removeFromSuperview()
            shootButton.isHidden = false
            self.navigationController?.isToolbarHidden = true
            
            userPictureMode = .selfie
            setUpForSelfie(device: .builtInWideAngleCamera, position: .front)
        }
        
    } 
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isToolbarHidden = false
        image.image = randomFactImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated) 
        sceneView.session.pause()
        self.currentCaffeineStatus = .temporarilyUnavailable
        if let cap = self.captureSession { 
            cap.stopRunning()
        }
        if userPictureMode == .selfie {
            closeLivePreview()
        }
        if userPictureMode == .aReality {
            willDisappearAReality()
        }
        intitalView.alpha = 1
        userPictureMode = .undefined
        buttonAR.isEnabled = true
        buttonSelfie.isEnabled = true
    }
    
    let factsImagesArray = [
        "AAA1",
        "AAA2",
        "AAA3",
        "AAA4",
        "AAA5",
        "AAA6",
        "AAA7",
        "AAA8"
    ]
    func randomFactImage() -> UIImage {
        let unsignedArrayCount = UInt32(factsImagesArray.count)
        let unsignedRandomNumber = arc4random_uniform(unsignedArrayCount)
        let randomNumber = Int(unsignedRandomNumber)
        return UIImage(named: factsImagesArray[randomNumber])!
    }
    
    @IBAction func picturesWithDummy(_ sender: Any) {
        if  DataManager.shared.purchasedGirthsAndSkinfilds() {
        intitalView.alpha = 0
        if userPictureMode == .selfie {
            closeLivePreview()
        }
        statusLabel.isHidden = false
        userPictureMode = .aReality
        didWillAReality()
        didLoadAReality()
        let imageLayer = CALayer()
        imageLayer.backgroundColor = UIColor.clear.cgColor
        imageLayer.frame = sceneView.layer.bounds
        imageLayer.contents = UIImage(named:"CameraOverlay")?.cgImage
        sceneView.layer.addSublayer(imageLayer)
        buttonAR.isEnabled = false
        buttonSelfie.isEnabled = true
        } else {
            DataManager.shared.allertWithParameter(title: loc("LOCARTITLE"), message: loc("LOCARBODY"), viecontroller: self)
        }
    }
    @IBAction func picturesSelfie(_ sender: Any) {
        intitalView.alpha = 0
        if userPictureMode == .aReality {
            willDisappearAReality()
        }
        statusLabel.isHidden = true
        userPictureMode = .selfie
        setUpForSelfie(device: .builtInWideAngleCamera, position: .front)
        shootButton.isHidden = false
        buttonAR.isEnabled = true
        buttonSelfie.isEnabled = false

    }
    
    @IBAction func didTakePhoto(_ sender: Any) {
        
        startTimer()
    }
    
    func setUpForSelfie (device: AVCaptureDevice.DeviceType,position : AVCaptureDevice.Position){
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        guard let backCamera = AVCaptureDevice.default(device, for: AVMediaType.video, position: position )
            else {
                print("Unable to access back camera!")
                return
        }
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        sceneView.layer.addSublayer(videoPreviewLayer)
        let imageLayer = CALayer()
        imageLayer.backgroundColor = UIColor.clear.cgColor
        imageLayer.frame = sceneView.layer.bounds
        imageLayer.contents = UIImage(named:"CameraOverlay")?.cgImage
        sceneView.layer.addSublayer(imageLayer)
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                switch self.userPictureMode {
                case .aReality : self.videoPreviewLayer.frame = CGRect(x: 0, y: 0, width: 90, height: 120)
                case .selfie : self.videoPreviewLayer.frame =  self.sceneView.bounds
                default : break
                }
                
                
            }
        }
    }
    
    func closeLivePreview() {
        videoPreviewLayer.removeFromSuperlayer()
        self.captureSession.startRunning()
    }
    
    func endTimer() {
        switch userPictureMode {
        case .selfie :
            countdownTimer.invalidate()
            totalTime = 7
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            stillImageOutput.capturePhoto(with: settings, delegate: self)
            FirebaseManager.shared.trackLogEvent(type: "Pictures taken as", id: ".selfie")
            let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            
            switch authorizationStatus {
            case .notDetermined:
                // permission dialog not yet presented, request authorization
                AVCaptureDevice.requestAccess(for: AVMediaType.video,
                                              completionHandler: { (granted:Bool) -> Void in
                                                if granted { print("eeeeee") }
                                                else {
                                                    // user denied, nothing much to do
                                                    
                                                }
                })
            case .authorized: return
            case .denied :return
            case .restricted:return
            default: break
            }
            
        case .aReality :
            countdownTimer.invalidate()
            totalTime = 7
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            stillImageOutput.capturePhoto(with: settings, delegate: self)
            FirebaseManager.shared.trackLogEvent(type: "Pictures taken as", id: ".aReality")
            let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            switch authorizationStatus {
            case .notDetermined:
                // permission dialog not yet presented, request authorization
                AVCaptureDevice.requestAccess(for: AVMediaType.video,
                                              completionHandler: { (granted:Bool) -> Void in
                                                if granted { print("granteg") }
                                                else {
                                                    print("no granteg")
                                                    
                                                }
                })
            case .authorized: print("D"); return
            case .denied : print("D"); return
            case .restricted: print("D"); return
            default: print("D"); return
            }
        default : break
        }
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        let image = UIImage(data: imageData)
        captureImageView.image = image
        DataManager.shared.prepareImageForSaving(image: image!) {
            switch self.userPictureMode {
            case .aReality:
                self.closeLivePreview()
                self.didWillAReality()
            default : break
            }
        }
        
    }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        shootButton.isEnabled = false
        switch userPictureMode {
        case .aReality:
            willDisappearAReality()
            setUpForSelfie(device: .builtInDualCamera, position: .back)
        default:
            break
        }
        
    }
    
    @objc func updateTime() {
        timerLabel.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
            shootButton.isEnabled = true
        } 
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%01d", seconds)
    }
}
extension CameraViewController: ARSCNViewDelegate {
    
    func didLoadAReality(){ // EX ViewDIDLOAD
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        // configure settings and debug options for scene
        self.sceneView.debugOptions = [SCNDebugOptions.showFeaturePoints,SCNDebugOptions.showConstraints, SCNDebugOptions.showLightExtents, SCNDebugOptions.showWorldOrigin]
        //,SCNDebugOptions.showConstraints, SCNDebugOptions.showLightExtents, SCNDebugOptions.showWorldOrigin
        self.sceneView.automaticallyUpdatesLighting = true
        // Create a new scene
        let scene = SCNScene()
        // Set the scene to the view
        sceneView.scene = scene
        // round corners of status label
        statusLabel.layer.cornerRadius = 15
        statusLabel.layer.masksToBounds = true
        // initialize coffee node
        self.initializeMugNode()}
    
    func didWillAReality() { // EX viewWillAppear
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        // Run the view's session
        
        sceneView.session.run(configuration)
        self.currentCaffeineStatus = .initialized
        if planes.count > 0 { self.currentCaffeineStatus = .ready }
    }
    
    func willDisappearAReality() { // EX viewWillDisappear
        // Pause the view's session
        sceneView.session.pause()
        self.currentCaffeineStatus = .temporarilyUnavailable
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func initializeMugNode() {
        // Obtain the scene the coffee mug is contained inside, and extract it.
        let mugScene = SCNScene(named: "my.scnassets/Mio.dae")!
        self.mugNode = mugScene.rootNode.childNode(withName: "Male", recursively: true)!
        sceneView.scene.rootNode.addChildNode(mugNode)
        let action = SCNAction.scale(by: multipiler, duration: 0.5)
        mugNode.runAction(action)
    }
    // MARK: - Adding, updating and removing planes in the scene in response to ARKit plane detection.
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // create a 3d plane from the anchor
        if let arPlaneAnchor = anchor as? ARPlaneAnchor {
            let plane = VirtualPlane(anchor: arPlaneAnchor)
            self.planes[arPlaneAnchor.identifier] = plane
            node.addChildNode(plane)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let arPlaneAnchor = anchor as? ARPlaneAnchor, let plane = planes[arPlaneAnchor.identifier] {
            plane.updateWithNewAnchor(arPlaneAnchor)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if let arPlaneAnchor = anchor as? ARPlaneAnchor, let index = planes.index(forKey: arPlaneAnchor.identifier) {
            planes.remove(at: index)
        }
    }
    
    // MARK: - Cleaning up the session
    
    func cleanupARSession() {
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) -> Void in
            node.removeFromParentNode()
        }
    }
    
    // MARK: - Session tracking methods
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        self.currentCaffeineStatus = .failed
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        self.currentCaffeineStatus = .temporarilyUnavailable
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        self.currentCaffeineStatus = .ready
    }
    
    // MARK: - Selecting planes and adding out coffee mug.
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            //print("Unable to identify touches on any plane. Ignoring interaction...")
            return
        }
        if currentCaffeineStatus != .ready {
            //print("Unable to place objects when the planes are not ready...")
            return
        }
        
        let touchPoint = touch.location(in: sceneView)
        if let plane = virtualPlaneProperlySet(touchPoint: touchPoint) {
            addCoffeeToPlane(plane: plane, atPoint: touchPoint)
        } else { 
        }
    }
    
    func virtualPlaneProperlySet(touchPoint: CGPoint) -> VirtualPlane? {
        let hits = sceneView.hitTest(touchPoint, types: .existingPlaneUsingExtent)
        
        if hits.count > 0, let firstHit = hits.first, let identifier = firstHit.anchor?.identifier, let plane = planes[identifier] {
            self.selectedPlane = plane
            return plane
        }
        return nil
    }
    
    func addCoffeeToPlane(plane: VirtualPlane, atPoint point: CGPoint) {
        let hits = sceneView.hitTest(point, types: .existingPlaneUsingExtent)
        
        if hits.count > 0, let firstHit = hits.first {
            shootButton.isHidden = false
            mugNode.position = SCNVector3Make(firstHit.worldTransform.columns.3.x, firstHit.worldTransform.columns.3.y, firstHit.worldTransform.columns.3.z)
        }
    }
    
}
