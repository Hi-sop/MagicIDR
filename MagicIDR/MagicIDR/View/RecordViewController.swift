//
//  RecordViewController.swift
//  MagicIDR
//
//  Created by Hisop on 2024/02/03.
//

import UIKit

class RecordViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureStatusBar()
        configureNavigationBar()
    }
    
    private func configureView() {
        
    }
    
    private func configureStatusBar() {
        //무슨얘긴지 모르겠음 - 최상단 바를 이야기하는걸까?
    }
    
    private func configureNavigationBar() {
        let leftItem = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: #selector(touchUpInsideLeftButton)
        )
        let rightItem = UIBarButtonItem(
            title: "자동/수동",
            style: .plain,
            target: self,
            action: #selector(touchUpInsideRightButton)
        )
        
        leftItem.tintColor = UIColor.white
        rightItem.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
        
        navigationController?.isNavigationBarHidden = false
    }
    
    @objc private func touchUpInsideLeftButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func touchUpInsideRightButton() {
        print("자동/수동 Click")
    }
    
}
