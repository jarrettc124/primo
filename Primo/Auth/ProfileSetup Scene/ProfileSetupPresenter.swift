//
//  ProfileSetupPresenter.swift
//  Primo
//
//  Created by Jarrett Chen on 1/2/20.
//  Copyright (c) 2020 Jarrett Chen. All rights reserved.


import UIKit

protocol ProfileSetupPresentationLogic: BaseCleanPresentationLogic {
//    func presentSomething(response: ProfileSetup.Something.Response)
}

class ProfileSetupPresenter: BaseCleanPresenter {
    
    weak var viewController: ProfileSetupDisplayLogic?

}

extension ProfileSetupPresenter: ProfileSetupPresentationLogic {
      
        // MARK: Do something
    //    func presentSomething(response: ProfileSetup.Something.Response) {
    //    }
    
}
