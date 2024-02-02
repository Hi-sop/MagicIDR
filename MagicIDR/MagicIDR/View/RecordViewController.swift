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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden = true
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
        leftItem.tintColor = UIColor.white
        
        let rightItem = UIBarButtonItem(
            title: "자동/수동",
            style: .plain,
            target: self,
            action: #selector(touchUpInsideRightButton)
        )
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
        let preview = PreviewViewController()
        self.navigationController?.pushViewController(preview, animated: true) //temp
    }
    
}
