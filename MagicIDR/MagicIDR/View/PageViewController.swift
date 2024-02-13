//
//  PageViewController.swift
//  MagicIDR
//
//  Created by Hisop on 2024/02/13.
//

import UIKit


// MARK: - Configure / Init
final class PageViewController: UIPageViewController {
    private var photoDataManager: PhotoDataManager?
    private var pageViewContollers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureToolBar()
        configureView()
    }
    
    func configurePhotoManager(_ manager: PhotoDataManager) {
        photoDataManager = manager
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func configureView() {
        subViewContollerInit()
    }
}
 
// MARK: - Navigation
extension PageViewController {
    private func configureNavigationBar() {
        let leftItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left"),
            style: .plain,
            target: self,
            action: #selector(touchUpInsideLeftButton)
        )
        leftItem.tintColor = UIColor.white
        
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.titleView = makeCenterItem(index: 1)
    }
    
    @objc private func touchUpInsideLeftButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func makeCenterItem(index: Int) -> UILabel {
        guard let data = photoDataManager?.loadPhotoData() else {
            return UILabel()
        }
        
        let centerItem = UILabel()
        
        centerItem.font = UIFont.boldSystemFont(ofSize: 16)
        centerItem.text = "\(index)/\(data.count)"
        centerItem.textColor = UIColor.white
        
        return centerItem
    }
}

// MARK: - ToolBar
extension PageViewController {
    private func configureToolBar() {
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

// MARK: PageDelegate
extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pageViewContollers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = index - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        navigationItem.titleView = makeCenterItem(index: previousIndex + 1)
        
        return pageViewContollers[previousIndex]
    }
        
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageViewContollers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = index + 1
        
        guard nextIndex < pageViewContollers.count else {
            return nil
        }
        
        navigationItem.titleView = makeCenterItem(index: nextIndex + 1)
        
        return pageViewContollers[nextIndex]
    }
}

extension PageViewController {
    private func subViewContollerInit() {
        guard let data = photoDataManager?.loadPhotoData() else {
            return
        }
        
        for _ in 1...data.count {
            let viewController = UIViewController()
            let imageView = UIView()
            
            viewController.view.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate ([
                imageView.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor, constant: 40),
                imageView.leadingAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
            ])
            
            pageViewContollers.append(viewController)
        }
        
        setViewControllers([pageViewContollers.first!], direction: .forward, animated: true, completion: nil)
        
        dataSource = self
        delegate = self
    }

}

