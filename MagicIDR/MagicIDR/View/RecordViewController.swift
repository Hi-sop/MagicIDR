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
        //무슨얘긴지 모르겠음 - 최상단 바?
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
        //BarButtonItem중복되는 느낌. 프로토콜 혹은 클래스로 만들어볼수도
        
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
        
        navigationController?.isNavigationBarHidden = false
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
