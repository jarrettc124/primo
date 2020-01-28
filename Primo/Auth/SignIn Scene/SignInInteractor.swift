//
//  SignInInteractor.swift
//  Primo
//
//  Created by Jarrett Chen on 1/2/20.
//  Copyright (c) 2020 Jarrett Chen. All rights reserved.
//
//  This file was generated by the UNUM Clean Architecture
//

import UIKit

protocol SignInBusinessLogic: BaseCleanBusinessLogic {
//  func doSomething(request: SignIn.Something.Request)
}

protocol SignInDataStore {
  //var name: String { get set }
}

class SignInInteractor: BaseCleanInteractor, SignInDataStore {
    
    var presenter: SignInPresentationLogic?

}

extension SignInInteractor: SignInBusinessLogic {
    // MARK: Do something
    //    func doSomething(request: SignIn.Something.Request) {
    //    }
}
