//
//  ProfileSetupInteractor.swift
//  Primo
//
//  Created by Jarrett Chen on 1/2/20.
//  Copyright (c) 2020 Jarrett Chen. All rights reserved.
//
//  This file was generated by the UNUM Clean Architecture
//

import UIKit

protocol ProfileSetupBusinessLogic: BaseCleanBusinessLogic {
//  func doSomething(request: ProfileSetup.Something.Request)
}

protocol ProfileSetupDataStore {
  //var name: String { get set }
}

class ProfileSetupInteractor: BaseCleanInteractor, ProfileSetupDataStore {
    
    var presenter: ProfileSetupPresentationLogic?

}

extension ProfileSetupInteractor: ProfileSetupBusinessLogic {
    // MARK: Do something
    //    func doSomething(request: ProfileSetup.Something.Request) {
    //    }
}
