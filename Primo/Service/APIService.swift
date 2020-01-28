//
//  APIService.swift
//  UNUM
//
//  Created by Jarrett Chen on 4/15/19.
//  Copyright © 2019 UNUM Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias APISuccessCompletionHander = ([String:AnyObject]) -> Void
typealias APISuccessArrayCompletionHander = ([[String:AnyObject]]) -> Void
typealias APIErrorCompletionHander = (Endpoint.Error) -> Void

class APIService {
    
    enum APIParseErrors: Error {
        case resourceNotFound(message: String)
    }

    init(){}
    
    func successSingleResourceHandler(data: AnyObject?, success: @escaping APISuccessCompletionHander, error: @escaping APIErrorCompletionHander) {
        do{
            let apiResponse = try self.teamAPISuccessResponse(data: data)
            success(apiResponse)
        }catch APIParseErrors.resourceNotFound(let message){
            let endpointError = Endpoint.Error.resourceNotFound(message)
            error(endpointError)
        }catch let err {
            error(Endpoint.Error.internalServerError(err.localizedDescription))
        }
    }
    
    func teamAPISuccessResponse(data: AnyObject?) throws -> [String:AnyObject]{
        
        guard let data = data else{
            throw APIParseErrors.resourceNotFound(message: "Data is empty")
        }
        
        let jsonObject = JSON(data)
        if let accountsObject = jsonObject["data"].dictionaryObject as [String:AnyObject]?{
            return accountsObject
        }else{
            throw APIParseErrors.resourceNotFound(message: "Does not conform to Data")
        }
    }
    
    func APISuccessResponseArray(data: AnyObject?) throws -> [[String:AnyObject]]{
        
        guard let data = data else{
            throw APIParseErrors.resourceNotFound(message: "Data is empty")
        }
        
        let jsonObject = JSON(data)
        if let accountsObject = jsonObject["data"].arrayObject as? [[String:AnyObject]]{
            return accountsObject
        }else{
            throw APIParseErrors.resourceNotFound(message: "Does not conform to Data")
        }
    }
    
}
