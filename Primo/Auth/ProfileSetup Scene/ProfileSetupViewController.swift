//
//  ProfileSetupViewController.swift
//  Primo
//
//  Created by Jarrett Chen on 1/2/20.
//  Copyright (c) 2020 Jarrett Chen. All rights reserved.

import UIKit
import Anchorage

protocol ProfileSetupDisplayLogic: class {
//    func displaySomething(viewModel: ProfileSetup.Something.ViewModel)
}

class ProfileSetupViewController: BaseCleanViewController {
    
    var interactor: ProfileSetupBusinessLogic?
    var router: (NSObjectProtocol & ProfileSetupRoutingLogic & ProfileSetupDataPassing)?
  
    lazy var vc = ClassRegViewController()

    // MARK: Setup
    override func setup() {
        let viewController = self
        let interactor = ProfileSetupInteractor()
        let presenter = ProfileSetupPresenter()
        let router = ProfileSetupRouter()
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
extension ProfileSetupViewController: ProfileSetupDisplayLogic {
//    func displaySomething(viewModel: ProfileSetup.Something.ViewModel) {
//    }
}
