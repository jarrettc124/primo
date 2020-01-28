//
//  SignUpRouter.swift
//  Primo
//
//  Created by Jarrett Chen on 12/31/19.
//  Copyright (c) 2019 Jarrett Chen. All rights reserved.
//

import UIKit

@objc protocol SignUpRoutingLogic {
    func routeToProfileSetup()
}

protocol SignUpDataPassing {
//  var dataStore: SignUpDataStore? { get }
}

class SignUpRouter: NSObject, SignUpDataPassing {
    
  weak var viewController: SignUpViewController?
  var dataStore: SignUpDataStore?
  

}

extension SignUpRouter: SignUpRoutingLogic {
    // MARK: Routing
    func routeToProfileSetup() {
        let vc = ProfileSetupViewController()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    //func routeToSomewhere(segue: UIStoryboardSegue?)
    //{
    //  if let segue = segue {
    //    let destinationVC = segue.destination as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //  } else {
    //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //    navigateToSomewhere(source: viewController!, destination: destinationVC)
    //  }
    //}

    // MARK: Navigation
    
    //func navigateToSomewhere(source: SignUpViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: SignUpDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
}
