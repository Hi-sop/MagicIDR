//
//  RecordViewController.swift
//  MagicIDR
//
//  Created by Hisop on 2024/02/03.
//

import UIKit
import AVFoundation

// MARK: - Configure / Init
final class RecordViewController: UIViewController {
    private let captureSession = AVCaptureSession()
    private let detectorView = DetectorView()
    
    private var photoDataManager: PhotoDataManager? = nil
    private var tempPhotoData: PhotoData? = nil
    
    private var timer: Timer? = nil
    private var elapsedTime: TimeInterval = 0
    private var autofind: Bool = true
    
    private var detectState: Bool = false {
        didSet {
            if detectState {
                startTimer()
            } else {
                stopTimer()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureToolBar()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden = false

        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.captureSession.stopRunning()
    }

    private func configureView() {
        cameraViewInit()
        detectorViewInit()
    }
    
    private func pushSampleViewContoller() {
        let pageViewContoller = PageViewController()
        guard let photoDataManager = self.photoDataManager else {
            return
        }
        
        pageViewContoller.configurePhotoManager(photoDataManager)
        self.navigationController?.pushViewController(pageViewContoller, animated: true) //temp
    }
    
    func configurePhotoManager(_ manager: PhotoDataManager) {
        photoDataManager = manager
    }
}

// MARK: - Timer
extension RecordViewController {
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            self?.elapsedTime += 0.1
            
            if let elapsedTime = self?.elapsedTime,
               let autofind = self?.autofind,
               elapsedTime >= 1.5 && autofind {
                
                guard let photoData = self?.tempPhotoData else {
                    return
                }
                
                self?.photoDataManager?.addPhotoData(data: photoData)
                self?.pushSampleViewContoller()
                self?.stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
        elapsedTime = 0
    }
}

// MARK: - Navigation
extension RecordViewController {
    private func configureNavigationBar() {
        let leftItem = makeBarButtonItem(title: "취소")
        let rightItem = makeBarButtonItem(title: "자동/수동")
        
        leftItem.action = #selector(touchUpInsideLeftButton)
        rightItem.action = #selector(touchUpInsideRightButton)
        
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
        
        navigationController?.isNavigationBarHidden = false
    }
    
    private func makeBarButtonItem(title: String) -> UIBarButtonItem {
        let BarButtonItem = UIBarButtonItem(
            title: title,
            style: .plain,
            target: self,
            action: nil
        )
        
        BarButtonItem.tintColor = UIColor.white
        
        return BarButtonItem
    }
    
    @objc private func touchUpInsideLeftButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func touchUpInsideRightButton() {
        self.autofind.toggle()
    }
}

// MARK: - ToolBar
extension RecordViewController {
    private func configureToolBar() {
        let leftItem = UIBarButtonItem(
            image: UIImage(systemName: "photo"),
            style: .plain,
            target: nil,
            action: nil
        )
        leftItem.tintColor = UIColor.white
        
        let centerItem = UIBarButtonItem(
            image: UIImage(systemName: "camera.aperture"),
            style: .plain,
            target: nil,
            action: nil
        )
        centerItem.tintColor = UIColor.white
        
        let rightItem = UIBarButtonItem(
            title: "저장",
            style: .plain,
            target: nil,
            action: nil
        )
        rightItem.tintColor = UIColor.white
        
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 25
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let items = [space, leftItem, flexibleSpace, centerItem, flexibleSpace, rightItem, space]
        self.toolbarItems = items
        
        navigationController?.toolbar.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        navigationController?.isToolbarHidden = false
    }
    
}

// MARK: - CameraView
extension RecordViewController {
    private func cameraViewInit() {
        let cameraView = UIView()
        
        configureCameraSession(cameraView: cameraView)
        
        view.addSubview(cameraView)
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate ([
            cameraView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            cameraView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            cameraView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
    }
    
    private func configureCameraSession(cameraView: UIView) {
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        
        DispatchQueue.global().async {
            guard let backCamera = AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: .back
            ) else {
                return
            }
            
            do {
                let input = try AVCaptureDeviceInput(device: backCamera)
                self.captureSession.addInput(input)
            } catch {
                print(error.localizedDescription)
                return
            }
        }
        
        DispatchQueue.main.async {
            videoPreviewLayer.videoGravity = .resizeAspectFill
            videoPreviewLayer.frame = cameraView.layer.bounds
            cameraView.layer.addSublayer(videoPreviewLayer)
        }
    }
}

// MARK: - DetectorView
extension RecordViewController {
    private func detectorViewInit() {
        let videoOutput = AVCaptureVideoDataOutput()
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        self.captureSession.addOutput(videoOutput)
           
        view.addSubview(detectorView)
        detectorView.backgroundColor = UIColor.clear
        detectorView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate ([
            detectorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            detectorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detectorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detectorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
    }
}

extension RecordViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        connection.videoOrientation = .portraitUpsideDown
        connection.isVideoMirrored = true
                
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let ciImage = CIImage(cvImageBuffer: buffer)
        
        let detector = CIDetector(
            ofType: CIDetectorTypeRectangle,
            context: CIContext(),
            options: [
                CIDetectorAccuracy: CIDetectorAccuracyHigh
            ]
        )
        
        guard let feature = detector?.features(in: ciImage).first as? CIRectangleFeature else {
            detectorView.isHidden = true
            detectState = false
            return
        }
        
        let cutPoint = CutPoint(
            topLeft: feature.topLeft,
            topRight: feature.topRight,
            bottomLeft: feature.bottomLeft,
            bottomRight: feature.bottomRight
        )
        
        let widthRatio = view.frame.width / ciImage.extent.width
        let heightRatio = view.frame.height / ciImage.extent.height
        
        self.tempPhotoData = PhotoData(image: ciImage, cutPoint: cutPoint, widthRatio: widthRatio, heightRatio: heightRatio)
        
        detectorView.isHidden = false
        if detectState == false {
            detectState = true
        }
        

        
        detectorView.setRectangle(rectangleFeature: feature, widthRatio: widthRatio, heightRatio: heightRatio)
        detectorView.setNeedsDisplay()
    }
}
