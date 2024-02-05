//
//  SampleViewController.swift
//  MagicIDR
//
//  Created by Hisop on 2024/02/03.
//

import UIKit

class SampleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureToolBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func configureNavigationBar() {
        let leftItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left"),
            style: .plain,
            target: self,
            action: #selector(touchUpInsideLeftButton)
        )
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
    
    //마찬가지로 BarButtonItem 재활용 가능해보이고
    private func configureToolBar() {
        //삭제시 바로 이전 이미지로 넘어가도록 변경해야하고,
        //삭제했는데 이미지가 0개다 -> pop
        let leftItem = UIBarButtonItem(
            image: UIImage(systemName: "trash.fill"),
            style: .plain,
            target: nil,
            action: nil
        )
        leftItem.tintColor = UIColor.white
        
        //회전기능 추가 필요
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
            target: self,
            action: #selector(touchUpInsideCropButton)
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
    
    @objc private func touchUpInsideCropButton() {
        let repoint = RepointViewController()
        self.navigationController?.pushViewController(repoint, animated: true)
    }
    
    
}
