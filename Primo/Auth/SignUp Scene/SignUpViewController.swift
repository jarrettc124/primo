//
//  SignUpViewController.swift
//  Primo
//
//  Created by Jarrett Chen on 12/31/19.
//  Copyright (c) 2019 Jarrett Chen. All rights reserved.

import UIKit
import Anchorage

protocol SignUpDisplayLogic: class {
//    func displaySomething(viewModel: SignUp.Something.ViewModel)
}

class SignUpViewController: BaseCleanViewController {
    
    var interactor: SignUpBusinessLogic?
    var router: (NSObjectProtocol & SignUpRoutingLogic & SignUpDataPassing)?
    
    lazy var vc = RegisterViewController()
    
    // MARK: Setup
    override func setup() {
        let viewController = self
        let interactor = SignUpInteractor()
        let presenter = SignUpPresenter()
        let router = SignUpRouter()
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
        vc.delegate = self
    }
    
}

//MARK: Display logic
extension SignUpViewController: SignUpDisplayLogic {
//    func displaySomething(viewModel: SignUp.Something.ViewModel) {
//    }
}

extension SignUpViewController: RegisterViewDelegate {
    func didClick(onPrivacy viewController: RegisterViewController!) {
        print("privacy")
    }
    
    func didRegister(_ viewController: RegisterViewController!) {
        print("asdfsds")
        router?.routeToProfileSetup()
    }
}
