//
//  Endpoint.swift
//  Kernl
//
//  Created by Samuel Philip on 9/16/15.
//  Copyright © 2015 CTRL LA, Inc. All rights reserved.
//

import Foundation
import Alamofire

class Endpoint {
    
    fileprivate static var persistentHeaders: [String: String] = [:]
    fileprivate static var persistentParams: [String: AnyObject] = [:]
    fileprivate static var defaultSettings: Settings = Settings()

    struct Settings {
        var method: Method?
        var fullUrl: String?
        var baseUrl: String?
        var path: String?
        var params: [String: AnyObject]?
        var headers: [String: String]?
        var addPersistentParams: Bool?
        var addPersistentHeaders: Bool?
        var expectedResponse: ExpectedResponse?
        
        init() {
            method = Method.get
            fullUrl = nil
            baseUrl = nil
            path = nil
            params = [:]
            headers = [:]
            addPersistentParams = true
            addPersistentHeaders = true
            expectedResponse = ExpectedResponse.json
        }
        
        func copy() -> Settings {
            var copy = Settings()
            
            copy.method = self.method
            copy.fullUrl = self.fullUrl
            copy.baseUrl = self.baseUrl
            copy.path = self.path
            copy.params = self.params
            copy.headers = self.headers
            copy.addPersistentParams = self.addPersistentParams
            copy.addPersistentHeaders = self.addPersistentHeaders
            copy.expectedResponse = self.expectedResponse
            
            return copy
        }
        
        mutating func config(_ settings: Settings) {
            if let method = settings.method {
                self.method = method
            }
            
            if let fullUrl = settings.fullUrl {
                self.fullUrl = fullUrl
            }
            
            if let baseUrl = settings.baseUrl {
                self.baseUrl = baseUrl
            }
            
            if let path = settings.path {
                self.path = path
            }
            
            if let params = settings.params {
                var newParams = [String:AnyObject]()
                
                // add old parameters
                if let storedParams = self.params {
                    for (key, value) in storedParams {
                        newParams[key] = value
                    }
                }
                
                // add new params
                for (key, value) in params {
                    newParams[key] = value
                }
                
                self.params = newParams
            }
            
            if let headers = settings.headers {
                var newHeaders = [String:String]()
                
                // add old parameters
                if let storedHeaders = self.headers {
                    for (key, value) in storedHeaders {
                        newHeaders[key] = value
                    }
                }
                
                // add new params
                for (key, value) in headers {
                    newHeaders[key] = value
                }
                
                self.headers = newHeaders
            }
            
            if let addPersistentParams = settings.addPersistentParams {
                self.addPersistentParams = addPersistentParams
            }
            
            if let addPersistentHeaders = settings.addPersistentHeaders {
                self.addPersistentHeaders = addPersistentHeaders
            }
            
            if let expectedResponse = settings.expectedResponse {
                self.expectedResponse = expectedResponse
            }
        }
    }
    
    enum Method {
        case get
        case put
        case post
        case patch
        case delete
    
        func toAFMethod() -> Alamofire.HTTPMethod {
            switch self {
            case .get:
                return Alamofire.HTTPMethod.get
            case .put:
                return Alamofire.HTTPMethod.put
            case .post:
                return Alamofire.HTTPMethod.post
            case .patch:
                return Alamofire.HTTPMethod.patch
            case .delete:
                return Alamofire.HTTPMethod.delete
            }
        }
    }
    
    enum ExpectedResponse {
        case string
        case json
        case array
        case xml
        case unknown
    }
    
    enum Error: CustomStringConvertible {
        case serverError
        case unauthorized(String)
        case clientError
        case badRequest(String)
        case resourceNotModified(String)
        case resourceNotFound(String)
        case conflictError(String)
        case resourceLocked(String)
        case forbidden(String)
        case tooManyRequests(String)
        case internalServerError(String)
        case notConnectedToInternet(String)
        case timeout
        case other(String)
        case unknown
        
        var description: String {
            switch self {
            case .serverError:
                return "Oops, looks like something went wrong. \n Please try again!"
            case .unauthorized:
                return "Unauthorized"
            case .clientError:
                return "Client Error"
            case .badRequest(let message):
                return "Bad Request: \(message)"
            case .resourceNotModified:
                return "Resource Not Modified"
            case .resourceNotFound:
                return "Resource Not Found"
            case .resourceLocked:
                return "Resource Locked"
            case .forbidden:
                return "Forbidden"
            case .conflictError:
                return "Conflict Error"
            case .tooManyRequests:
                return "Too Many Requests"
            case .internalServerError:
                return "Internal Server Error"
            case .notConnectedToInternet:
                return "Not Connected to Internet"
            case .timeout:
                return "Request was timed out"
            case .other(let string):
                return "Other: \(string)"
            default:
                return "Unknown"
            }
        }

        var status: Int {
            switch self {
            case .unauthorized: return 401
            case .badRequest: return 400
            case .resourceNotModified: return 304
            case .resourceNotFound: return 404
            case .resourceLocked: return 423
            case .forbidden: return 403
            case .conflictError: return 409
            case .tooManyRequests: return 429
            case .internalServerError: return 500
            case .timeout: return 800
            case .notConnectedToInternet: return -1009
            default: return 500
            }
        }

        var message: String {
            switch self {
            case .unauthorized(let string): return string
            case .badRequest(let string): return string
            case .resourceNotModified(let string): return string
            case .resourceNotFound(let string): return string
            case .resourceLocked(let string): return string
            case .forbidden(let string): return string
            case .conflictError(let string): return string
            case .tooManyRequests(let string): return string
            case .internalServerError(let string): return string
            case .notConnectedToInternet(let string): return string
            case .other(let string): return "Other Error: \(string)"
            default: return "Error, please try again!"
            }
        }
    }

    class Request {
        fileprivate var settings: Settings
        var alamofireManager : Alamofire.SessionManager?
        
        init() {
            self.settings = Endpoint.defaultSettings.copy()
        }
        
        init(settings: Settings) {
            self.settings = Endpoint.defaultSettings.copy()
            self.settings.config(settings)
        }
        
        init(URL: String) {
            self.settings = Endpoint.defaultSettings.copy()
            self.settings.baseUrl = URL
        }
        
        func config(_ settings: Settings) {
            self.settings.config(settings)
        }
        
        func setCustomHeader(header:[String: String]){
            self.settings.addPersistentHeaders = false
            self.settings.headers = header
        }
        
        func get(_ path: String, success: @escaping (AnyObject?) -> (), error: @escaping (Endpoint.Error) -> ()) {
            settings.path = path
            settings.method = Endpoint.Method.get
            execute(success, error: error)
        }
        func getWithTimeout(_ timeout:Int,path: String, success: @escaping (AnyObject?) -> (), error: @escaping (Endpoint.Error) -> ()) {
            settings.path = path
            settings.method = Endpoint.Method.get
            executeWithTimeout(timeout, success: success, error: error)
//            execute(success, error: error)
        }
        
        func post(_ path: String, params: [String:AnyObject]?, success: @escaping (AnyObject?) -> (), error: @escaping (Endpoint.Error) -> ()) {
            settings.path = path
            settings.params = params
            settings.method = Endpoint.Method.post
            execute(success, error: error)
        }
        
        func put(_ path: String, params: [String:AnyObject]?, success: @escaping (AnyObject?) -> (), error: @escaping (Endpoint.Error) -> ()) {
            settings.path = path
            settings.params = params
            settings.method = Endpoint.Method.put
            execute(success, error: error)
        }
        
        func putWithTimeout(_ timeout:Int, path: String, params: [String:AnyObject]?, success: @escaping (AnyObject?) -> (), error: @escaping (Endpoint.Error) -> ()) {
            settings.path = path
            settings.params = params
            settings.method = Endpoint.Method.put
            executeWithTimeout(timeout, success: success, error: error)
//            execute(success, error: error)
        }
        
        func delete(_ path: String, params: [String:AnyObject]?, success: @escaping (AnyObject?) -> (), error: @escaping (Endpoint.Error) -> ()) {
            settings.path = path
            settings.params = params
            settings.method = Endpoint.Method.delete
            execute(success, error: error)
        }
        func patch(_ path: String, params: [String:AnyObject]?, success: @escaping (AnyObject?) -> (), error: @escaping (Endpoint.Error) -> ()) {
            settings.path = path
            settings.params = params
            settings.method = Endpoint.Method.patch
            execute(success, error: error)
        }
        func execute(_ path: String) {
            self.settings.path = path
            self.execute()
        }
        
        func execute() {
            self.execute({ (success: AnyObject?) -> () in
                // do nothing on success...
            }) { (error: Endpoint.Error) -> () in
                // do nothing on error...
            }
        }
        
        func execute(_ path: String, success: @escaping ((AnyObject?) -> ()), error: @escaping ((Endpoint.Error) -> ())) {
            self.settings.path = path;
            self.execute(success, error: error)
        }
        
        func executeWithTimeout(_ timeout:Int,success: @escaping ((AnyObject?) -> ()), error: @escaping ((Endpoint.Error) -> ())) {
            let url = getUrl()
            let method = getMethod()
            let parameters = getParameters()
            let encoding = getEncoding()
            let headers = getHeaders()
            resetParameters()

            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForResource = TimeInterval(timeout) // seconds
            
            self.alamofireManager = Alamofire.SessionManager(configuration: configuration)
            let request = self.alamofireManager?.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)

            if let request = request {
                if let expectedResponse = settings.expectedResponse {
                    switch expectedResponse {
                        
                    case .string:
                        
                        request.responseString { (responseString) in
                            
                            let response = responseString.response
                            let result = responseString.result
                            
                            switch (result){
                            case .success:
                                if let response = response{
                                    
                                    if response.statusCode >= 200 && response.statusCode < 300 {
                                        
                                        success(result.value as AnyObject)
                                    } else {
                                        
                                        let apiError = self.getError(response: response, result: result as AnyObject?,dataResponse: nil)
                                        
                                        error(apiError)
                                    }
                                }else{
                                    let apiError = self.getError(response: nil, result: result as AnyObject?)
                                    error(apiError)
                                }
                                
                                break
                            case .failure(let err):
                                if err._code == NSURLErrorTimedOut {
                                    //HANDLE TIMEOUT HERE
                                    let apiError = Endpoint.Error.timeout
                                    error(apiError)
                                    
                                }else if err._code == NSURLErrorCancelled{
                                    
                                }else{
                                    
                                    if let response = response{
                                        if response.statusCode >= 200 && response.statusCode < 300 && result.isSuccess {
                                            
                                            success(result.value as AnyObject)
                                        } else {
                                            
                                            request.responseData(completionHandler: { (responseData) in
                                                
                                                if let data = responseData.data{
                                                    let str = String(data: data, encoding: .utf8)
                                                    let apiError = self.getError(response: response, result: result as AnyObject?, dataResponse: nil, responseMessage: str)
                                                    error(apiError)
                                                    return
                                                }
                                                
                                                let apiError = self.getError(response: response, result: result as AnyObject?)
                                                error(apiError)
                                                
                                            })
                                            
                                        }
                                    }else{
                                        let apiError = self.getError(response: nil, result: result as AnyObject?)
                                        error(apiError)
                                    }
                                }
                                break
                                
                            }
                            
                        }
                        
                    case .json:
                        request.responseJSON { responseJSON -> Void in

                            let response = responseJSON.response
                            let result = responseJSON.result
                            
                            switch (result) {
                            case .success:
                                
                                //do json stuff
                                if let response = response{

                                    if response.statusCode >= 200 && response.statusCode < 300 && result.isSuccess {

                                        success(result.value as AnyObject)
                                    } else {
                                        
                                        let apiError = self.getError(response: response, result: result as AnyObject?)
                                        error(apiError)
                                    }
                                }else{
                                    let apiError = self.getError(response: nil, result: result as AnyObject?)
                                    error(apiError)
                                }
                                
                                break
                            case .failure(let err):

                                if err._code == NSURLErrorTimedOut {
                                    //HANDLE TIMEOUT HERE
                                    let apiError = Endpoint.Error.timeout
                                    error(apiError)

                                }else if err._code == NSURLErrorCancelled{
                                
                                }else{

                                    if let response = response{

                                        if response.statusCode >= 200 && response.statusCode < 300 && result.isSuccess {
                                            
                                            success(result.value as AnyObject)
                                        } else {

                                            let apiError = self.getError(response: response, result: result as AnyObject?)
                                            error(apiError)
                                        }
                                    }else{
                                        let apiError = self.getError(response: nil, result: result as AnyObject?)
                                        error(apiError)
                                    }
                                }
                                break
                            }
                        }
                    default:
                        request.response(completionHandler: { (dataResponse) in
                            
                            if let response = dataResponse.response{
                                
                                if response.statusCode >= 200 && response.statusCode < 300 && dataResponse.error == nil {
                                
                                    success(dataResponse.data as AnyObject?)
                                } else {

                                    let failure = dataResponse.error.map { Result<AnyObject>.failure($0) }
                                    let apiError = self.getError(response: response, result: failure as AnyObject?)
                                    error(apiError)
                                }
                            }else{

                                let err = Endpoint.Error.clientError
                                error(err)
                            }
                            
                        })
                        
                        break
                    }
                }
            } else {
            }
            /*
            .response { request, response, data, error in
            */
            
        }
        
        func execute(_ success: @escaping ((AnyObject?) -> ()), error: @escaping ((Endpoint.Error) -> ())) {
            let url = getUrl()
            let method = getMethod()
            let parameters = getParameters()
            let encoding = getEncoding()
            let headers = getHeaders()
            resetParameters()
            
            let request = Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            
            if let expectedResponse = settings.expectedResponse {
                switch expectedResponse {
                    
                case .string:
                    
                    request.responseString { (responseString) in
                        
                        let response = responseString.response
                        let result = responseString.result
                        
                        switch (result){
                        case .success:
                            if let response = response{
                                
                                if response.statusCode >= 200 && response.statusCode < 300 {
                                    
                                    success(result.value as AnyObject)
                                } else {
                                    
                                    let apiError = self.getError(response: response, result: result as AnyObject?,dataResponse: nil)
                                    
                                    error(apiError)
                                }
                            }else{
                                let apiError = self.getError(response: nil, result: result as AnyObject?)
                                error(apiError)
                            }
                            
                            break
                        case .failure(let err):
                            if err._code == NSURLErrorTimedOut {
                                //HANDLE TIMEOUT HERE
                                let apiError = Endpoint.Error.timeout
                                error(apiError)
                                
                            }else if err._code == NSURLErrorCancelled{
                                
                            }else{
                                
                                if let response = response{
                                    if response.statusCode >= 200 && response.statusCode < 300 && result.isSuccess {
                                        
                                        success(result.value as AnyObject)
                                    } else {
                                        
                                        request.responseData(completionHandler: { (responseData) in
                                            
                                            if let data = responseData.data{
                                                let str = String(data: data, encoding: .utf8)
                                                let apiError = self.getError(response: response, result: result as AnyObject?, dataResponse: nil, responseMessage: str)
                                                error(apiError)
                                                return
                                            }
                                            
                                            let apiError = self.getError(response: response, result: result as AnyObject?)
                                            error(apiError)
                                            
                                        })
                                        
                                    }
                                }else{
                                    let apiError = self.getError(response: nil, result: result as AnyObject?)
                                    error(apiError)
                                }
                            }
                            break
                            
                        }
                        
                    }
                    
                case .json:
                    request.responseJSON { responseJSON in
                        
                        let response = responseJSON.response
                        let result = responseJSON.result
                        
                        switch (result) {
                        case .success:
                            
                            //do json stuff
                            if let response = response{
                                
                                if response.statusCode >= 200 && response.statusCode < 300 && result.isSuccess {
                                    
                                    success(result.value as AnyObject)
                                } else {
                                    
                                    let apiError = self.getError(response: response, result: result as AnyObject?,dataResponse: responseJSON)
                                    
                                    error(apiError)
                                }
                            }else{
                                let apiError = self.getError(response: nil, result: result as AnyObject?)
                                error(apiError)
                            }
                            
                            break
                        case .failure(let err):
                            
                            if err._code == NSURLErrorTimedOut {
                                //HANDLE TIMEOUT HERE
                                let apiError = Endpoint.Error.timeout
                                error(apiError)
                                
                            }else if err._code == NSURLErrorCancelled{
                                
                            }else{
                                
                                if let response = response{
                                    if response.statusCode >= 200 && response.statusCode < 300 && result.isSuccess {
                                        
                                        success(result.value as AnyObject)
                                    } else {
                                        
                                        request.responseData(completionHandler: { (responseData) in

                                            if let data = responseData.data{
                                                let str = String(data: data, encoding: .utf8)
                                                let apiError = self.getError(response: response, result: result as AnyObject?, dataResponse: nil, responseMessage: str)
                                                error(apiError)
                                                return
                                            }
                                            
                                            let apiError = self.getError(response: response, result: result as AnyObject?)
                                            error(apiError)
                                            
                                        })
                                        
                                    }
                                }else{
                                    let apiError = self.getError(response: nil, result: result as AnyObject?)
                                    error(apiError)
                                }
                            }
                            break
                        }
                    }
                default:
                    
                    request.response(completionHandler: { (dataResponse) in

                        if let response = dataResponse.response{
                            
                            if response.statusCode >= 200 && response.statusCode < 300 && dataResponse.error == nil {

                                success(dataResponse.data as AnyObject?)
                                
                            } else {
                                let failure = dataResponse.error.map { Result<Any>.failure($0) }
                                let apiError = self.getError(response: response, result: failure as AnyObject?)
                                error(apiError)
                            }
                        }
                    })
                }
            }
            
            /*
            .response { request, response, data, error in
            */
        }
        
        fileprivate func getError(response: HTTPURLResponse?, result: AnyObject?, dataResponse: (DataResponse<Any>)?=nil,responseMessage:String?=nil) -> Endpoint.Error {

            var message: String?

            if let result = dataResponse?.result.value as? [String: AnyObject] {
                
                if let data = result["data"] as? [String: AnyObject], let _message = data["message"] as? String {
                    
                    message = _message
                
                }else if let data = result["data"] as? [String: AnyObject], let _message = data["message"] as? [String:AnyObject] {
                    
                    message = _message["sub_message"] as? String
                
                }else{
                    message = "\(String(describing: dataResponse))"
                }
                
            }else if let responseMessage = message{
                message = responseMessage
            }
            if let unwrappedResponse = response {
                let statusCode = unwrappedResponse.statusCode
                switch statusCode {
                case 400:
                    let errorMessage = message ?? "Bad request made."
                    return Endpoint.Error.badRequest(errorMessage)
                case 401:
                    let errorMessage = message ?? "Unauthorized request made."
                    return Endpoint.Error.unauthorized(errorMessage)
                case 403:
                    let errorMessage = message ?? "Forbidden"
                    return Endpoint.Error.forbidden(errorMessage)
                case 423:
                    return Endpoint.Error.resourceLocked("Resource locked.")
                case 404:
                    let errorMessage = message ?? "Resource not found."
                    return Endpoint.Error.resourceNotFound(errorMessage)
                case 409:
                    let errorMessage = message ?? "Conflict Error"
                    return Endpoint.Error.conflictError(errorMessage)
                default:
                    return Endpoint.Error.serverError
                }
            } else if let result = result as? Result<Any>, let error = result.error as NSError? {
                
                switch error.code {
                case NSURLErrorNotConnectedToInternet:
                    return Endpoint.Error.notConnectedToInternet("Not connected to the Internet")
                case NSURLErrorCannotConnectToHost:
                    return Endpoint.Error.notConnectedToInternet("There's no internet available")
                default:
                    break
                }
                
            }else{
                
            }

            return Endpoint.Error.unknown
        }
        
        fileprivate func getEncoding() -> ParameterEncoding {
            if settings.method == Endpoint.Method.get {
                return URLEncoding(destination: .queryString)
            } else {
                return JSONEncoding.default
            }
        }
        
        fileprivate func getUrl() -> String {
            var url = ""
            
            if let fullUrl = settings.fullUrl {
                return fullUrl
            }
            
            if let baseUrl = settings.baseUrl {
                url += baseUrl
            }
            
            if let path = settings.path {
                url += path
            }
            
            return url
        }
        
        fileprivate func getMethod() -> Alamofire.HTTPMethod {
            if let method = self.settings.method {
                return method.toAFMethod()
            } else {
                return Alamofire.HTTPMethod.get
            }
        }
        
        fileprivate func getHeaders() -> [String:String] {
            var headers = [String:String]()
            
            if let storedHeaders = self.settings.headers {
                for (key, value) in storedHeaders {
                    headers[key] = value
                }
            }
            
            // unwrap `addPersistentParams` variable
            if let addPersistentHeaders = self.settings.addPersistentHeaders {
                // check stored value
                if addPersistentHeaders == true {
                    for (key, value) in Endpoint.persistentHeaders {
                        headers[key] = value
                    }
                }
            }
            
            
            return headers
        }
        
        fileprivate func getParameters() -> [String:AnyObject] {
            var params = [String:AnyObject]()
            
            if let storedParams = self.settings.params {
                for (key, value) in storedParams {
                    params[key] = value
                }
            }
            
            // unwrap `addPersistentParams` variable
            if let addPersistentParams = self.settings.addPersistentParams {
                // check stored value
                if addPersistentParams == true {
                    for (key, value) in Endpoint.persistentParams {
                        params[key] = value
                    }
                }
            }
            
            
            return params
        }
        
        func resetParameters() {
            settings.path = nil
            settings.params = nil
            settings.method = nil
        }
    }
    
    class func config(_ settings: Settings) {
        defaultSettings.config(settings)
    }
    
    class func addPersistentHeader(_ key: String, value: String) {
        persistentHeaders[key] = value
    }
    
    class func removePersistentHeader(_ key: String) {
        persistentHeaders.removeValue(forKey: key)
    }
    
    class func removeAllPersistentHeaders() {
        persistentHeaders.removeAll()
    }
    
    class func addPersistentParam(_ key: String, value: AnyObject) {
        persistentParams[key] = value
    }
    
    class func removePersistentParam(_ key: String) {
        persistentParams.removeValue(forKey: key)
    }
    
    class func removeAllPersistentParams() {
        persistentParams.removeAll()
    }
}
