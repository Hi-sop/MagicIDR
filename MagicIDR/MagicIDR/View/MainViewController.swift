//
//  MainViewController.swift
//  MagicIDR
//
//  Created by Hisop on 2024/02/03.
//

import UIKit
import AVFoundation

final class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureNavigationColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func configureNavigationColor() {
        navigationController?.navigationBar.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    private func configureView() {
        let cameraButton = makeCameraButton()
        let titleLabel = makeTitleLabel()
        
        view.addSubview(cameraButton)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate ([
            cameraButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            cameraButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            cameraButton.widthAnchor.constraint(equalToConstant: 100),
            cameraButton.heightAnchor.constraint(equalToConstant: 100),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: cameraButton.topAnchor, constant: -10)
        ])
    }
}

extension MainViewController {
    private func makeCameraButton() -> UIButton {
        let cameraButton = UIButton()
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        
        cameraButton.addTarget(self, action: #selector(touchUpInsideCameraButton), for: .touchUpInside)
        cameraButton.setBackgroundImage(UIImage(systemName: "camera.circle.fill"), for: .normal)
        cameraButton.tintColor = UIColor.black.withAlphaComponent(0.5)
        
        return cameraButton
    }
    
    @objc private func touchUpInsideCameraButton() {
        //Camera버튼 클릭시 권한 확인 후 push
        AVCaptureDevice.requestAccess(for: .video) { [weak self] authorized in
            guard authorized else {
                self?.authorizedAlert()
                return
            }
        }
        
        let recordViewController = RecordViewController()
        
        self.navigationController?.pushViewController(recordViewController, animated: true)
    }
    
    private func authorizedAlert() {
        let alert = UIAlertController(
            title: "MagicIDR을 사용하기 위해 카메라 접근 권한이 필요합니다",
            message: "설정 화면으로 이동하시겠습니까?", preferredStyle: .alert
        )
        
        let settingAlertAction = UIAlertAction(
            title: "설정으로 이동",
            style: .default
        ) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.open(url)
        }
        
        let cancelAlertAction = UIAlertAction(
            title: "취소",
            style: .cancel
        ) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(settingAlertAction)
        alert.addAction(cancelAlertAction)
        
        present(alert, animated: true)
    }
    
    private func makeTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "MagicIDR"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        return titleLabel
    }
    
}

