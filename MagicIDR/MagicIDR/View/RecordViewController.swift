//
//  RecordViewController.swift
//  MagicIDR
//
//  Created by Hisop on 2024/02/03.
//

import UIKit
import AVFoundation

final class RecordViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configureStatusBar()
        configureNavigationBar()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden = true
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
        makeCameraView()
    }
    
    private func configureStatusBar() {
        //무슨얘긴지 모르겠음 - 최상단 바?
    }
}

extension RecordViewController {
    private func makeCameraView() {
        let cameraView = UIView()
        
        view.addSubview(cameraView)
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate ([
            cameraView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.8),
            cameraView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            cameraView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        DispatchQueue.global(qos: .background).async {
            let captureSession = AVCaptureSession()
            guard let backCamera = AVCaptureDevice.default(for: .video) else {
                return
            }
            
            do {
                let input = try AVCaptureDeviceInput(device: backCamera)
                captureSession.addInput(input)
            } catch {
                print(error.localizedDescription) //error별로 구분, 리턴
                return
            }
            
            DispatchQueue.main.async {
                let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer.videoGravity = .resizeAspectFill
                videoPreviewLayer.frame = cameraView.layer.bounds
                cameraView.layer.addSublayer(videoPreviewLayer)

            }
            
            captureSession.startRunning()

        }
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
