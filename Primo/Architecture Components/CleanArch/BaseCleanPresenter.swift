//
//  BaseCleanPresenter.swift
//  UNUM
//
//  Created by Jarrett Chen on 8/9/19.
//  Copyright © 2019 UNUM Inc. All rights reserved.
//

import Foundation

protocol BaseCleanPresentationLogic {
    func presentLoading(isLoading: Bool)
    func presentError(viewModel: BaseClean.Error.ViewModel)
}

class BaseCleanPresenter: BaseCleanPresentationLogic {
    
    weak var baseViewController: BaseCleanDisplayLogic?

    func presentLoading(isLoading: Bool) {
        baseViewController?.displayLoading(isLoading: isLoading)
    }
    
    func presentError(viewModel: BaseClean.Error.ViewModel) {
        baseViewController?.displayError(viewModel: viewModel)
    }
    
}
