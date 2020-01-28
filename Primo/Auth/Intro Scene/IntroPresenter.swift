//
//  IntroPresenter.swift
//  Primo
//
//  Created by Jarrett Chen on 12/31/19.
//  Copyright (c) 2019 Jarrett Chen. All rights reserved.


import UIKit

protocol IntroPresentationLogic: BaseCleanPresentationLogic {
//    func presentSomething(response: Intro.Something.Response)
}

class IntroPresenter: BaseCleanPresenter {
    
    weak var viewController: IntroDisplayLogic?

}

extension IntroPresenter: IntroPresentationLogic {
      
        // MARK: Do something
    //    func presentSomething(response: Intro.Something.Response) {
    //    }
    
}
