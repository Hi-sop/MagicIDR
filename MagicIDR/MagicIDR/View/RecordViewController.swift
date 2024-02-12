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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden = true

        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.captureSession.stopRunning()
    }
    
    private func configureNavigationBar() {
        let leftItem = makeBarButtonItem(title: "취소")
        let rightItem = makeBarButtonItem(title: "자동/수동")
        
        leftItem.action = #selector(touchUpInsideLeftButton)
        rightItem.action = #selector(touchUpInsideRightButton)
        
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
        
        navigationController?.isNavigationBarHidden = false
    }
    
    private func configureView() {
        cameraViewInit()
        detectorViewInit()
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
        //videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : Int(kCVPixelFormatType_32BGRA)]
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        self.captureSession.addOutput(videoOutput)
        
        detectorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detectorView)
        detectorView.backgroundColor = UIColor.systemCyan.withAlphaComponent(0.5)
        //detectorView.layer.addSublayer(detectorLayer)
        //detectorLayer.frame = detectorView.frame
        //detectorLayer.bounds = detectorView.bounds
        
        //요거 나름 성공적인데 상 하로 박스가 뛰쳐나옴
        //detectorLayer.bounds = CGRect(x: 0, y: 80, width: detectorView.frame.width, height: detectorView.frame.height)
        
        NSLayoutConstraint.activate ([
            //detectorView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.8),
            detectorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            detectorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detectorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detectorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
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
        print("자동/수동 Click")
        let sample = SampleViewController()
        self.navigationController?.pushViewController(sample, animated: true) //temp
    }
}

extension RecordViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        //connection.videoOrientation = .portraitUpsideDown
        connection.videoOrientation = .portraitUpsideDown
        connection.isVideoMirrored = true
        
        let ciImage = CIImage(cvImageBuffer: buffer)
        
        let context = CIContext()
        
        let detector = CIDetector(
            ofType: CIDetectorTypeRectangle,
            context: context,
            options: [
                //CIDetectorImageOrientation: CGImagePropertyOrientation.right,
                CIDetectorAccuracy: CIDetectorAccuracyHigh
            ]
        )
        
        guard let feature = detector?.features(in: ciImage).first as? CIRectangleFeature else {
            print("clear")
            detectorView.isHidden = true
            return
        }
        
        detectorView.isHidden = false
//        print(ciImage.extent.width)
//        print(ciImage.extent.height)
//    
//        print(detectorView.frame.width)
//        print(detectorView.frame.height)
//        
//        print("height: \(detectorView.frame.height)")
//        print("layerHeight: \(detectorLayer.frame.height)")
                
        let widthRatio = view.frame.width / ciImage.extent.width
        let heightRatio = view.frame.height / ciImage.extent.height
//        print(widthRatio)
//        print(heightRatio)
        
        let imageSize = ciImage.extent.size
        
        let transform = CGAffineTransform(
            scaleX: widthRatio,
            y: heightRatio
        )
     
        
        let path = UIBezierPath()
        
        let transformRect = feature.bounds.applying(transform)
        let pathtemp = UIBezierPath(rect: transformRect)
        
//        detectorLayer.path = pathtemp.cgPath
//        detectorLayer.fillColor = UIColor.clear.cgColor
//        detectorLayer.strokeColor = UIColor.red.cgColor
        //detectorView.setNeedsDisplay()
        
        //이런식으로 처리 가능은 하지만...! 무한하게 덮어씌운다! 그러니 미리 addsublayer를 한 후에!
        //path값만 갱신한다면 되겠네..?
        
        detectorView.rectangleFeature = feature
        detectorView.tempRect = transformRect
        detectorView.widthRatio = widthRatio
        detectorView.heightRatio = heightRatio
        
        //detectorView.drawLayer()
        //detectorView.layoutIfNeeded()
        detectorView.setNeedsDisplay()
        
//        detectorView.setNeedsDisplay()
    }
}
