//
//  UNUMNavigationController.swift
//  UNUM
//
//  Created by Jarrett Chen on 7/24/19.
//  Copyright © 2019 UNUM Inc. All rights reserved.
//

import UIKit

class PrimoNavigationController: UINavigationController {

    var isHideFirstPage = false
    var isCustomBarButtons = false
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.navigationBar.isTranslucent = true
        self.navigationBar.shadowImage = UIImage()
    }
    
//    func setupBackButton(viewController: UIViewController) {
//        let button = UIButton(type: .custom)
//        button.tintColor = UNUMColor.Content.primary(scheme: .current)
//        button.backgroundColor = UNUMColor.Background.primary(scheme: .current)
//        button.setImage(UIImage(named: "navbar-back"), for: .normal)
//        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
//
//        if let leftItems = self.visibleViewController?.navigationItem.leftBarButtonItems {
//            if let firstItem = leftItems.first {
//                self.visibleViewController?.navigationItem.leftBarButtonItems = [UIBarButtonItem.init(customView: button),firstItem]
//            } else {
//                self.visibleViewController?.navigationItem.leftBarButtonItems = [UIBarButtonItem.init(customView: button)]
//            }
//        } else {
//            self.visibleViewController?.navigationItem.leftBarButtonItems = [UIBarButtonItem.init(customView: button)]
//        }
//    }
    
//    func setTitle(title:String) {
//        var scheme = UDCLabelScheme(scheme: .custom)
//        let fontSize = Theme.FontSize.lg
//        scheme.font = Theme.Font.bold(fontSize)
//        scheme.color = UNUMColor.Content.primary(scheme: .current)
//        let label = UDCLabel(scheme: scheme)
//        label.text = title
//        if var leftItems = self.visibleViewController?.navigationItem.leftBarButtonItems {
//            leftItems.append(UIBarButtonItem.init(customView: label))
//            self.visibleViewController?.navigationItem.leftBarButtonItems = leftItems
//        } else {
//            self.visibleViewController?.navigationItem.leftBarButtonItems = [UIBarButtonItem.init(customView: label)]
//        }
//    }
//
    func setDismissButton(viewController: UIViewController) {

        let closeBarButton = UIBarButtonItem(customView: dismissButton)
        viewController.navigationItem.rightBarButtonItem = closeBarButton
    }

    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
//    @objc func handleBack() {
//
//        let isFirstViewController = self.visibleViewController == self.viewControllers.first
//        if (isFirstViewController) {
//            self.dismiss(animated: true, completion: nil)
//        } else {
//            self.popViewController(animated: true)
//        }
//    }

//    func setColors(scheme: UNUMScheme) {
//        navigationBar.barTintColor = UNUMColor.Container.strongInverted(scheme: scheme)
//        navigationBar.tintColor = UNUMColor.Content.primary(scheme: scheme)
//        navigationBar.isTranslucent = false
//    }
}

extension PrimoNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

//        let theme = Theme.currentTheme()
//        viewController.navigationController?.navigationBar.barTintColor = theme.navigationBarColor
//        viewController.navigationController?.navigationBar.tintColor = theme.navigationButtonColor
//        viewController.navigationController?.navigationBar.backgroundColor = theme.navigationBarColor
        viewController.navigationController?.navigationBar.isTranslucent = true
        viewController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        viewController.navigationController?.navigationBar.backgroundColor = .clear

//        setColors(scheme: .current)
        
        setNeedsStatusBarAppearanceUpdate()
        let isFirstViewController = viewController == self.viewControllers.first

        if (isFirstViewController) {
            
            //Hides first page
            if (isHideFirstPage) {
                self.setNavigationBarHidden(true, animated: animated)
            } else {
                if (!isCustomBarButtons) {
                    self.setDismissButton(viewController: viewController)
                }
            }
            
        } else {
//            setupBackButton(viewController: viewController)
            self.setNavigationBarHidden(false, animated: animated)
        }
        
    }
}
