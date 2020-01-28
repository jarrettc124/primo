
//
//  AuthService.swift
//  Primo
//
//  Created by Jarrett Chen on 1/27/20.
//  Copyright © 2020 Jarrett Chen. All rights reserved.
//

import Foundation

class AuthService: APIService {
    
    static var baseUrl:String = ""

    var adminToken:String?

    var request:Endpoint.Request = Endpoint.Request(URL: baseUrl)
    
    override init(){
        super.init()
        
        self.load()
    }
    
    //Loads the current saved user
    func load() {
        
        if let token = UserDefaults.standard.string(forKey: "admin-token") {
            setToken(token)
        } else {
            setToken(nil)
        }
    }
    
    func setToken(_ token: String?) {
        
        adminToken = token
        
        if let token = adminToken{
            Endpoint.addPersistentHeader("Authorization", value: token)
        }

        self.request.setCustomHeader(header: authHeader())
        
        cache()
    }
    
    func authHeader() -> Dictionary<String,String> {
        
        if let token = adminToken{
            let header = ["Authorization":token]
            return header
        } else {
            return [:]
        }
        
    }
    
    func cache() {
        if let token = adminToken {
            UserDefaults.standard.set(token, forKey: "admin-token")
        } else {
            UserDefaults.standard.removeObject(forKey: "admin-token")
        }
    }
    
    /*
     login exisiting user
     */
    func login(email: String, password: String, success: @escaping APISuccessCompletionHander, error: @escaping APIErrorCompletionHander) {
        
        let params: [String: AnyObject] = [
            "type": "ios" as AnyObject,
            "email": email as AnyObject,
            "password": password as AnyObject
        ]
        
        request.post("/v1/login", params: params,  success: { (data) in
            
            do{
                let apiResponse = try self.teamAPISuccessResponse(data: data)
                success(apiResponse)
            }catch APIParseErrors.resourceNotFound(let message){
                let endpointError = Endpoint.Error.resourceNotFound(message)
                error(endpointError)
            }catch {

            }
            
        }, error: error)
    }
    
    /*
     Get user with id
     */
    func getUserWithId(id: String, success: @escaping APISuccessCompletionHander, error: @escaping APIErrorCompletionHander) {
        request.get("/v1/emails/\(id)", success: { (data) in
            do{
                let apiResponse = try self.teamAPISuccessResponse(data: data)
                success(apiResponse)
            }catch APIParseErrors.resourceNotFound(let message){
                let endpointError = Endpoint.Error.resourceNotFound(message)
                error(endpointError)
            }catch let err {
                error(Endpoint.Error.internalServerError(err.localizedDescription))
            }
        }, error: error)
    }
    
}
