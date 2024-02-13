//
//  RepointViewController.swift
//  MagicIDR
//
//  Created by Hisop on 2024/02/03.
//

import UIKit

class RepointViewController: UIViewController {
    private var photoData: PhotoData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        configureToolBar()
        configureView()
    }
    
    private func configureView() {
        imageViewInit()
        detectorViewInit()
    }
    
    func configurePhotoData(_ data: PhotoData) {
        photoData = data
    }
    
    private func configureToolBar() {
        let leftItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(touchUpInsideLeftButton)
        )
        leftItem.tintColor = UIColor.white
        
        let rightItem = UIBarButtonItem(
            image: UIImage(systemName: "checkmark"),
            style: .plain,
            target: self,
            action: #selector(touchUpInsideRightButton)
        )
        rightItem.tintColor = UIColor.white
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let items = [leftItem, flexibleSpace, rightItem]
        self.toolbarItems = items
    }
    
    @objc private func touchUpInsideLeftButton() {
        print("touch Left")
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func touchUpInsideRightButton() {
        print("touch Right")
        navigationController?.popViewController(animated: true)
    }
    
    private func imageViewInit() {
        let imageView = UIImageView()
        
        imageView.image = makeImage()
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate ([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
    }
    
    private func makeImage() -> UIImage {
        guard let image = photoData?.image else {
            return UIImage()
        }
        
        let flippedImage = UIImage(ciImage: image, scale: UIScreen.main.scale, orientation: .upMirrored)

        guard let ciImage = flippedImage.ciImage else {
            return UIImage()
        }
        
        return UIImage(ciImage: ciImage, scale: UIScreen.main.scale, orientation: .downMirrored)
    }
    
    private func detectorViewInit() {
        let detectorView = DetectorView()
    
        guard let data = photoData else {
            return
        }
        
        view.addSubview(detectorView)
        detectorView.backgroundColor = UIColor.clear
        detectorView.translatesAutoresizingMaskIntoConstraints = false

        detectorView.setData(data: data)
        view.setNeedsDisplay()
        
        NSLayoutConstraint.activate ([
            detectorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            detectorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detectorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detectorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
    }
}
