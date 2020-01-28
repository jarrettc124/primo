//
//  SignUpPresenter.swift
//  Primo
//
//  Created by Jarrett Chen on 12/31/19.
//  Copyright (c) 2019 Jarrett Chen. All rights reserved.


import UIKit

protocol SignUpPresentationLogic: BaseCleanPresentationLogic {
//    func presentSomething(response: SignUp.Something.Response)
}

class SignUpPresenter: BaseCleanPresenter {
    
    weak var viewController: SignUpDisplayLogic?

}

extension SignUpPresenter: SignUpPresentationLogic {
      
        // MARK: Do something
    //    func presentSomething(response: SignUp.Something.Response) {
    //    }
    
}
