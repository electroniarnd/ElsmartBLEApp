//
//  ServiceHelper.swift
//  WorldFax
//
//  Created by Probir Chakraborty on 01/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import Foundation

let localUrl = "http://93.95.24.25/Emobile/service.svc"
//let stagingUrl = "http://ec2-52-74-93-103.ap-southeast-1.compute.amazonaws.com/PROJECTS/CarWarranty/trunk/api/Services/"
let baseURL = localUrl
let timeoutInterval:Double = 20

enum MethodType: Int {
    case get  = 0
    case post  = 1
    case put  = 2
    case delete  = 3
}

 class ServiceHelper {

    static let sharedInstance = ServiceHelper()

    //Create Post and send request
    func createPostRequest(_ params: [String : AnyObject]!,apiName : String, completion: @escaping (_ response: AnyObject?, _ error: NSError?) -> Void) {
        
        let parameterDict = NSMutableDictionary(dictionary: params)
        
        ServiceHelper.callAPIWithParameters(parameterDict, method: .post, apiName: apiName) { (responseObject :AnyObject?, error:NSError?,status : Int?) in
            
            DispatchQueue.main.async(execute: {
                completion(responseObject,error)
            })
        }
    }
    
    //Create Get and send request
    func createGetRequest(_ params: [String : AnyObject]!,apiName : String, completion: @escaping (_ response: AnyObject?, _ error: NSError?) -> Void) {
        
        let parameterDict = NSMutableDictionary(dictionary: params)
        
        ServiceHelper.callAPIWithParameters(parameterDict, method: .get, apiName: apiName) { (responseObject :AnyObject?, error:NSError?, status : Int?) in
            
            DispatchQueue.main.async(execute: {
                completion(responseObject,error)
            })
        }
    }

    //MARK:- Public Functions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    class func callAPIWithParameters(_ parameterDict:NSMutableDictionary, method:MethodType, apiName :String, completionBlock: @escaping (AnyObject?, NSError?,Int?) -> Void) ->Void {
        
        //hud_type = hudType
        if (APPDELEGATE.checkReachablility() == false) {
            
            let _ = AlertController.alert("Connection Error!", message: "Internet connection appears to be offline. Please check your internet connection.")
            RappleActivityIndicatorView.stopAnimation(completionIndicator: .none, completionLabel: "", completionTimeout: 1.0)
            return
        }
        
        //>>>>>>>>>>> create request
        let url = requestURL(method, apiName: apiName, parameterDict: parameterDict)
        var request = URLRequest(url: url)
        request.httpMethod = methodName(method)
        request.httpBody = body(method, parameterDict: parameterDict)
        request.timeoutInterval = timeoutInterval
        
//        if method == .post  || method == .put {
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.setValue("Mobiloitte1", forHTTPHeaderField: "CAR-KEY")
//            request.setValue("Mobiloitte1", forHTTPHeaderField: "admin")
//            request.setValue("Basic YWRtaW46TW9iaWxvaXR0ZTE=", forHTTPHeaderField: "Authorization")
//        }
     
        logInfo("\n\n Request URL  >>>>>>\(url)")
        logInfo("\n\n Request Header >>>>>> \n\(String(describing: request.allHTTPHeaderFields))")
        logInfo("\n\n Request Body  >>>>>>\(String(describing: request.httpBody))")
        logInfo("\n\n Request Parameters >>>>>>\n\(parameterDict.toJsonString())")
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
     
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                logInfo("\n\n error  >>>>>>\n\(String(describing: error))")
                
                completionBlock(nil,error as NSError?,nil)
            } else {
                
                let httpResponse = response as! HTTPURLResponse
                let responseCode = httpResponse.statusCode
                
                logInfo("Response Code : \(responseCode))")
                
                 let responseString = NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue)
                logInfo("Response String : \n \(responseString!)")
                
                
//                do {
//                    let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
//
//                    //>>>> Check if authentication error
//                    if let responseDict = result as? Dictionary<String, AnyObject> {
//                        if let responseCode = responseDict[kResponseCode] as? Int {
//                            if responseCode == 401 {
//                                //showErrorAlert(errorDict: responseDict)
//                                return
//                            }
//                        }
//                    }
                    completionBlock(responseString as AnyObject?,nil,responseCode)
                    
//                } catch {
//
//                    logInfo("\n\n error in JSONSerialization")
//                    logInfo("\n\n error  >>>>>>\n\(error)")
//                    completionBlock(nil,error as NSError?)
//                }
            }
            RappleActivityIndicatorView.stopAnimation(completionIndicator: .none, completionLabel: "", completionTimeout: 1.0)
        })
        
        task.resume()
    }
    
    
    class func showHud() {
        let attribute = RappleActivityIndicatorView.attribute(style: RappleStyleCircle, tintColor: .white, screenBG: nil, progressBG: .black, progressBarBG: .lightGray, progreeBarFill: .yellow)
        RappleActivityIndicatorView.startAnimating(attributes: attribute)
    }
    
    
    //MARK:- Private Functions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    
    class fileprivate func methodName(_ method:MethodType)-> String {
        
        switch method {
        case .get: return "GET"
        case .post: return "POST"
        case .delete: return "DELETE"
        case .put: return "PUT"
        }
    }
    
    class fileprivate func body(_ method:MethodType, parameterDict:NSMutableDictionary) -> Data {
        
        switch method {
        case .get: return Data()
        case .post: return parameterDict.toNSData()
        case .put: return parameterDict.toNSData()
            
        default: return Data()
        }
    }
    
    class fileprivate func requestURL(_ method:MethodType, apiName:String, parameterDict:NSMutableDictionary) -> URL {
        let urlString = apiName
        switch method {
        case .get:
            return getURL(apiName, parameterDict: parameterDict)
        case .post:
            return URL(string: urlString)!
        case .put:
            return URL(string: urlString)!
            
        default: return URL(string: urlString)!
        }
    }
    
    
    class fileprivate func getURL(_ apiName:String, parameterDict:NSMutableDictionary) -> URL {
        
        var urlString = apiName
        var isFirst = true
        for (key,value) in parameterDict {
            
            var appendedStr = "&"
            if (isFirst == true) {
                appendedStr = "?"
            }
            urlString.append(appendedStr)
            urlString.append(key as! String)
            urlString.append("=")
            urlString.append("\(value)")
            isFirst = false

        }
        let strUrl = urlString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        return URL(string:strUrl!)!
    }
}


