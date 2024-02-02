//
//  MainViewController.swift
//  MagicIDR
//
//  Created by Hisop on 2024/02/03.
//

import UIKit

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //navigationController?.isNavigationBarHidden = true
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
    
    private func makeCameraButton() -> UIButton {
        let cameraButton = UIButton()
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        
        cameraButton.addTarget(self, action: #selector(touchUpInsideCameraButton), for: .touchUpInside)
        cameraButton.setBackgroundImage(UIImage(systemName: "camera.circle.fill"), for: .normal)
        
        return cameraButton
    }
    
    @objc private func touchUpInsideCameraButton() {
        let recordViewController = RecordViewController()
        
        self.navigationController?.pushViewController(recordViewController, animated: true)
    }
    
    private func makeTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "MagicIDR"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        return titleLabel
    }
    
}

