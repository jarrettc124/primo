//
//  IntroViewController.swift
//  Primo
//
//  Created by Jarrett Chen on 12/31/19.
//  Copyright (c) 2019 Jarrett Chen. All rights reserved.

import UIKit

protocol IntroDisplayLogic: class {
//    func displaySomething(viewModel: Intro.Something.ViewModel)
}

class IntroViewController: BaseCleanViewController {
    
    var interactor: IntroBusinessLogic?
    var router: (NSObjectProtocol & IntroRoutingLogic & IntroDataPassing)?
  
    // MARK: Setup
    override func setup() {
        let viewController = self
        let interactor = IntroInteractor()
        let presenter = IntroPresenter()
        let router = IntroRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        
        super.setup(interactor: interactor, presenter: presenter)
    }
  
    @IBAction func loginButtonAction(_ sender: Any) {
        router?.routeToLogin()
    }
    
    @IBAction func signupButtonAction(_ sender: Any) {
        router?.routeToSignUp()
    }
}

//MARK: Display logic
extension IntroViewController: IntroDisplayLogic {

}
