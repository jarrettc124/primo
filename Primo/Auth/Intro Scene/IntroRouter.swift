//
//  IntroRouter.swift
//  Primo
//
//  Created by Jarrett Chen on 12/31/19.
//  Copyright (c) 2019 Jarrett Chen. All rights reserved.
//

import UIKit


@objc protocol IntroRoutingLogic {
    func routeToSignUp()
    func routeToLogin()
}

protocol IntroDataPassing {
}

class IntroRouter: NSObject, IntroDataPassing {
    
  weak var viewController: IntroViewController?
  var dataStore: IntroDataStore?
}

extension IntroRouter: IntroRoutingLogic {
    func routeToSignUp() {
        let vc = SignUpViewController()
        let nav = PrimoNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        viewController?.present(nav, animated: true, completion: nil)
    }
    
    func routeToLogin() {
        let vc = SignInViewController()
        let nav = PrimoNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        viewController?.present(nav, animated: true, completion: nil)
    }
}
