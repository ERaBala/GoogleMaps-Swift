//
//  NetworkManager.swift
//  APICAllWithMVC
//
//  Created by CN354 on 18/05/17.
//  Copyright © 2017 SD. All rights reserved.
//

import UIKit
import Alamofire

//# MARK: Enum for Application Environment Set
enum ApplicationEnvironment {
    case Development
    case Production
    
    func baseURLString() -> String {
        switch self {
        case .Development:
            return "http://omniprotech.com/gps/"
        case .Production:
            return "http://omniprotech.com/gps/"
        }
    }
}

//# MARK: Enum for Application Request HTTPMethod Set
enum ApplicationRequestHTTPMethod {
    case DELETE
    case GET
    case POST
    case PUT
    
    func alamofireMethod() -> Alamofire.HTTPMethod {
        switch self {
        case .DELETE:
            return .delete
        case .GET:
            return .get
        case .POST:
            return .post
        case .PUT:
            return .put
        }
    }
}

//# MARK: Struct for Application Network Resource Set
struct ApplicationNetworkResource<AnyClass> {
    let accessKey = "xxxxxxx"
    let secretKey = "xxxxxxx"
    let environment: ApplicationEnvironment
    let method: ApplicationRequestHTTPMethod
    let path: String
    let params: [String : String]?
    let parse: ((Data) -> Any?)
    var endPoint: String {
        return "\(environment.baseURLString())\(path)"
    }
    
    init(method: ApplicationRequestHTTPMethod, path: String, params: [String: String]?, parse: @escaping ((Data) -> Any?),
         environment: ApplicationEnvironment = .Production) {
        self.method = method
        self.path = path
        self.params = params
        self.parse = parse
        self.environment = environment
    }
}


public typealias JSONDictionary = [String: AnyObject]
public typealias JSONArray = [String: AnyObject]

//# MARK: NetworkManager Class
class NetworkManager: NSObject {
    
    //# MARK: API Request Class Function Call
    class func apiRequest(resource:ApplicationNetworkResource<Any>, completion: @escaping (_ result : Any?, _ error: Error?) -> Void) -> Void {

        Alamofire.request(resource.endPoint, method: resource.method.alamofireMethod(), parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["text/html"])
            .responseJSON { response in
                
                let requestAPI = response.request
                print(requestAPI ?? "")
                var fetchData : Any? = nil
                
                switch response.result {
                case .success:
                    if let JSON = response.result.value {
                        /*let jsonResult : Dictionary = JSON as! Dictionary<String, AnyObject>
                        */
                        print(JSON);
                        fetchData = resource.parse(response.data!)
                        completion(fetchData, nil)
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    //# MARK: Private Class Function to create Request Signature
    private class func requestSignature(method: ApplicationRequestHTTPMethod, endPoint: String, params: [String: String]) -> Data {
        
        /* Create the Signature */
        var paramString = "\(method.alamofireMethod().rawValue)\(endPoint)"
        /* Sort the keys */
        for key in params.keys.sorted() {
            paramString = "\(paramString)\(key):\(params[key]!)"
        }
        let signature = paramString.data(using: .utf8)!
        return signature
    }

    
    //# MARK: Decode Data Value to JSON String Array
    class func decodeJSONArrayString(data: Data) -> [String]? {
        var stringArray : [String]? = nil
        do {
            stringArray = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String]
        } catch _ {
            stringArray = nil
        }
        
        return stringArray
    }
    
    //# MARK: Decode Data Value to JSON Dictionary Array
    class func decodeJSONArrayDictionary(data: Data) -> [JSONDictionary]? {
        
        var jSONDictionaryArray : [JSONDictionary]? = nil
        do {
            jSONDictionaryArray = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments) as? [JSONDictionary]
        } catch _ {
            jSONDictionaryArray = nil
        }
        
        return jSONDictionaryArray
    }
    
    //# MARK: Decode Data Value to JSON Dictionary
    class func decodeJSON(data: Data) -> JSONDictionary? {
        
        var jSONDictionary : JSONDictionary? = nil
        do {
            jSONDictionary = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments) as? JSONDictionary
        } catch _ {
            jSONDictionary = nil
        }
        
        return jSONDictionary
    }
    
    //# MARK: Encode JSON Dictionary Value to Data Value
    class func encodeJSON(dict: JSONDictionary) -> Data? {
        
        var nsData : Data? = nil
        do {
            nsData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) as Data?
        } catch _ {
            nsData = nil
        }
        
        return dict.count > 0 ?  nsData : nil
    }
    
}
