//
//  IntroInteractor.swift
//  Primo
//
//  Created by Jarrett Chen on 12/31/19.
//  Copyright (c) 2019 Jarrett Chen. All rights reserved.
//
//  This file was generated by the UNUM Clean Architecture
//

import UIKit

protocol IntroBusinessLogic: BaseCleanBusinessLogic {
//  func doSomething(request: Intro.Something.Request)
}

protocol IntroDataStore {
  //var name: String { get set }
}

class IntroInteractor: BaseCleanInteractor, IntroDataStore {
    
    var presenter: IntroPresentationLogic?

}

extension IntroInteractor: IntroBusinessLogic {
    // MARK: Do something
    //    func doSomething(request: Intro.Something.Request) {
    //    }
}
