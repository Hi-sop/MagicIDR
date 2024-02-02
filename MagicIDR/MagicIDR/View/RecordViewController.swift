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
        
        navigationItemInit()
    }
    
    private func configureView() {
        
    }
    
    private func navigationItemInit() {
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
        
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc private func touchUpInsideLeftButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func touchUpInsideRightButton() {
        print("자동/수동 Click")
    }
    
}
