//
//  ILNetworkManager.swift
//  InspeeroLibDemo
//
//  Created by Bhavesh Sarwar on 14/01/19.
//  Copyright © 2019 Bhavesh Sarwar. All rights reserved.
//

import UIKit
import Alamofire
class ILNetworkManager: NSObject {

    /// Singleton
    static let shared = ILNetworkManager()
    private override init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 4 // seconds
        configuration.timeoutIntervalForResource = 4
        self.alamoFireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    /// Response model closure
    public typealias responseModel = (_ response: NSDictionary? , _ error:Error?) -> Void
    
    /// URL
    let serverURL = ""
    let alamoFireManager:SessionManager?
    
//    let alamofireSessionManager

    
    
    /// Sending normal request
    
    func sendRequest(baseUrl:String = ILNetworkManager.shared.serverURL,
                     methodType:HTTPMethod,
                     apiName:String,
                     parameters:NSDictionary?,
                     headers:NSDictionary?,
                     encoding:ParameterEncoding = JSONEncoding.default  ,
                     completionHandler:@escaping responseModel){
        
        
        // Check network rechability
        if NetworkReachabilityManager()?.isReachable == true{
            
            let urlString = baseUrl + apiName
            
            // Sending alamofire request
            
//            alamoFireManager.req
            
            alamoFireManager!.request(urlString,
                              method: methodType,
                              parameters: parameters as? [String:String],
                              encoding: encoding,
                              headers: headers as? [String:String]  ).responseJSON
            { (response:DataResponse<Any>) in
                
                completionHandler(response.result.value as? NSDictionary, response.error)
            
            }

        }else{
            print("Internet connection not available")
        }
    }
    
    
    
    func sendImagesRequest(baseUrl:String = ILNetworkManager.shared.serverURL,
                           methodType:HTTPMethod,
                           apiName:String,
                           parameters:NSDictionary?,
                           headers:NSDictionary?,
                           images:[UIImage]?,
                           encoding:ParameterEncoding = JSONEncoding.default  ,
                           completionHandler:@escaping responseModel){
        
        
        
        // Check network rechability
        if NetworkReachabilityManager()?.isReachable == true{
            // Create multipart image
            var multipartImagesData = [Data]()
        
            if let imagesArray = images{
                DispatchQueue.main.async {
                    multipartImagesData =  imagesArray.compactMap{$0.jpegData(compressionQuality: 0.3)}
                }
                
            }
            
            DispatchQueue.main.async {
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    // Convert parameters in to the Strings
                    for (key, value) in parameters! {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as! String)
                    }
                    // Convert images in to the multipart data
                    multipartImagesData.forEach({ (imageData) in
                        multipartFormData.append(imageData, withName: "media" ,
                                                 fileName: "image.jpeg",
                                                 mimeType:(imageData.mimeType))
                    })
                }, to: baseUrl,
                   method: methodType,
                   headers : headers as? [String:String]
                ) { (result) in
                    switch result{
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            print("Succesfully uploaded")
                            if let err = response.error{
                                print(err)
                                completionHandler(response.result.value as? NSDictionary, response.error)
                            }
                            completionHandler(response.result.value as? NSDictionary, response.error)
                        }
                    case .failure(let error):
                        print("Error in upload: \(error.localizedDescription)")
                    }
                }
                
            }
        }else{
            print("Internet connection not available")
        }
        
    }

}


extension Data {
    private static let mimeTypeSignatures: [UInt8 : String] = [
        0xFF : "image/jpeg",
        0x89 : "image/png",
        0x47 : "image/gif",
        0x49 : "image/tiff",
        0x4D : "image/tiff",
        0x25 : "application/pdf",
        0xD0 : "application/vnd",
        0x46 : "text/plain",
        ]
    
    var mimeType: String {
        var c: UInt8 = 0
        copyBytes(to: &c, count: 1)
        return Data.mimeTypeSignatures[c] ?? "application/octet-stream"
    }
}
