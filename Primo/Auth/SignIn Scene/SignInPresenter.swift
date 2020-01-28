//
//  SignInPresenter.swift
//  Primo
//
//  Created by Jarrett Chen on 1/2/20.
//  Copyright (c) 2020 Jarrett Chen. All rights reserved.


import UIKit

protocol SignInPresentationLogic: BaseCleanPresentationLogic {
//    func presentSomething(response: SignIn.Something.Response)
}

class SignInPresenter: BaseCleanPresenter {
    
    weak var viewController: SignInDisplayLogic?

}

extension SignInPresenter: SignInPresentationLogic {
      
        // MARK: Do something
    //    func presentSomething(response: SignIn.Something.Response) {
    //    }
    
}
