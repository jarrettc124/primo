//
//  BaseCleanModel.swift
//  UNUM
//
//  Created by Jarrett Chen on 8/9/19.
//  Copyright © 2019 UNUM Inc. All rights reserved.
//

import Foundation


struct FailedMessage{
    
    enum ErrorType {
        case popup
        case banner
    }
    
    var title: String? = nil
    var message:String
    var code: Int
    var errorType:ErrorType
    
    init(title:String,message:String,code:Int,type:ErrorType) {
        self.title = title
        self.message = message
        self.code = code
        self.errorType = type
    }
    
    init(message:String,code:Int){
        self.message = message
        self.code = code
        self.errorType = .banner
    }

}

enum BaseClean {
    enum Error {
        struct Response {
            var failedMessage: FailedMessage
        }
        struct ViewModel {
            var title: String?
            var message: String?
            var type: FailedMessage.ErrorType
        }
    }
}
