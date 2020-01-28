//
//  BaseCleanViewController.swift
//  UNUM
//
//  Created by Jarrett Chen on 8/9/19.
//  Copyright © 2019 UNUM Inc. All rights reserved.
//

import UIKit
import PopupDialog

protocol BaseCleanDisplayLogic: class {
    func displayLoading(isLoading: Bool)
    func displayError(viewModel: BaseClean.Error.ViewModel)
}

class BaseCleanViewController: UIViewController {
    
    
    //MARK: Lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        fatalError("Must override")
    }
    
    func setup(interactor: BaseCleanInteractor, presenter:BaseCleanPresenter) {
        presenter.baseViewController = self
    }
    
}

extension BaseCleanViewController: BaseCleanDisplayLogic {
    func displayLoading(isLoading: Bool) {
//        isLoading ? SimpleLoadingView.shared.show(at: self.view) : SimpleLoadingView.shared.hide()
    }
    
    func displayError(viewModel: BaseClean.Error.ViewModel) {
        
        switch viewModel.type {
        case .banner:
            break
//            let banner = Banner(title: viewModel.title, subtitle: viewModel.message, image: nil, verticalPadding: nil, backgroundColor: UIColor.red, didTapBlock: nil)
//            banner.show(nil, duration: 3, vibrate: true)
        case .popup:
            let popup = PopupDialog(title: viewModel.title, message: viewModel.message)
            popup.transitionStyle = .fadeIn
            self.present(popup, animated: true, completion: nil)
        }

    }
}
