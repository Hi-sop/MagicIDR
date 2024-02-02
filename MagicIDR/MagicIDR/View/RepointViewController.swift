//
//  RepointViewController.swift
//  MagicIDR
//
//  Created by Hisop on 2024/02/03.
//

import UIKit

class RepointViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        configureToolBar()
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
}
