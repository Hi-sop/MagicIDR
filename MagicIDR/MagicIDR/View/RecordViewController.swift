//
//  RecordViewController.swift
//  MagicIDR
//
//  Created by Hisop on 2024/02/03.
//

import UIKit

final class RecordViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configureStatusBar()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden = true
    }
    
    private func configureNavigationBar() {
        let leftItem = makeBarButtonItem(title: "취소")
        let rightItem = makeBarButtonItem(title: "자동/수동")
        
        leftItem.action = #selector(touchUpInsideLeftButton)
        rightItem.action = #selector(touchUpInsideRightButton)
        
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
        
        navigationController?.isNavigationBarHidden = false
    }
    
    private func configureView() {
        
    }
    
    private func configureStatusBar() {
        //무슨얘긴지 모르겠음 - 최상단 바?
    }
}

extension RecordViewController {
    private func makeBarButtonItem(title: String) -> UIBarButtonItem {
        let BarButtonItem = UIBarButtonItem(
            title: title,
            style: .plain,
            target: self,
            action: nil
        )
        
        BarButtonItem.tintColor = UIColor.white
        
        return BarButtonItem
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
