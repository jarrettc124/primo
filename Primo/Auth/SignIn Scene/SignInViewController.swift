//
//  SignInViewController.swift
//  Primo
//
//  Created by Jarrett Chen on 1/2/20.
//  Copyright (c) 2020 Jarrett Chen. All rights reserved.

import UIKit
import Anchorage

protocol SignInDisplayLogic: class {
//    func displaySomething(viewModel: SignIn.Something.ViewModel)
}

class SignInViewController: BaseCleanViewController {
    
    var interactor: SignInBusinessLogic?
    var router: (NSObjectProtocol & SignInRoutingLogic & SignInDataPassing)?
  
    var vc = LoginViewController()
    
    // MARK: Setup
    override func setup() {
        let viewController = self
        let interactor = SignInInteractor()
        let presenter = SignInPresenter()
        let router = SignInRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        
        super.setup(interactor: interactor, presenter: presenter)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
        vc.view.edgeAnchors == self.view.edgeAnchors
//        vc.delegate = self
    }
    
}

//MARK: Display logic
extension SignInViewController: SignInDisplayLogic {
//    func displaySomething(viewModel: SignIn.Something.ViewModel) {
//    }
}
