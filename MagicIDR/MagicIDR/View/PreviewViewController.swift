//
//  PreviewViewController.swift
//  MagicIDR
//
//  Created by Hisop on 2024/02/03.
//

import UIKit

class PreviewViewController: UIViewController {
    override func viewDidLoad() {
        configureNavigationBar()
        configureToolBar()
        super.viewDidLoad()
    }
    
    private func configureNavigationBar() {
        let leftItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: #selector(touchUpInsideLeftButton)
        )
        
        leftItem.image = UIImage(systemName: "arrow.left")
        leftItem.tintColor = UIColor.white
        
        let centerItem = UILabel()
        
        centerItem.font = UIFont.boldSystemFont(ofSize: 16)
        centerItem.text = "5/6" //temp -> 갱신하는 VM필
        centerItem.textColor = UIColor.white
        
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.titleView = centerItem
    }
    
    @objc private func touchUpInsideLeftButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func configureToolBar() {
        let leftItem = UIBarButtonItem(
            image: UIImage(systemName: "trash.fill"),
            style: .plain,
            target: nil,
            action: nil
        )
        leftItem.tintColor = UIColor.white
        
        let centerItem = UIBarButtonItem(
            title: "반시계",
            style: .plain,
            target: nil,
            action: nil
        )
        centerItem.tintColor = UIColor.white
        
        let rightItem = UIBarButtonItem(
            image: UIImage(systemName: "crop"),
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
