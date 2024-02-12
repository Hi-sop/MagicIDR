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

    private func configureView() {
        cameraViewInit()
        detectorViewInit()
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
        print("자동/수동 Click")
        let sample = SampleViewController()
        self.navigationController?.pushViewController(sample, animated: true) //temp
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
            return
        }
        detectorView.isHidden = false
                
        let widthRatio = view.frame.width / ciImage.extent.width
        let heightRatio = view.frame.height / ciImage.extent.height
        
        detectorView.setRectangle(rectangleFeature: feature, widthRatio: widthRatio, heightRatio: heightRatio)
        detectorView.setNeedsDisplay()
    }
}
