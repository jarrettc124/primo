//
//  SignInRouter.swift
//  Primo
//
//  Created by Jarrett Chen on 1/2/20.
//  Copyright (c) 2020 Jarrett Chen. All rights reserved.
//

import UIKit

@objc protocol SignInRoutingLogic {
}

protocol SignInDataPassing {
//  var dataStore: SignInDataStore? { get }
}

class SignInRouter: NSObject, SignInDataPassing {
    
  weak var viewController: SignInViewController?
  var dataStore: SignInDataStore?
  

}

extension SignInRouter: SignInRoutingLogic {
    // MARK: Routing
    
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
    
    //func navigateToSomewhere(source: SignInViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: SignInDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
}
