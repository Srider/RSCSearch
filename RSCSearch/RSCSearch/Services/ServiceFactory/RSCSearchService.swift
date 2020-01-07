//
//  CountriesService.swift
//  Countries
//
//  Created by Honeywell on 10/11/17.
//  Copyright © 2017 Honeywell. All rights reserved.
//

import UIKit

class RSCSearchService: Operation, URLSessionDataDelegate {
    @objc var dictData:NSMutableDictionary!       /* NSMutableDictionary for storing parsed response data */
       var mServiceURL: String!                      /* String for storing request URL */
       var mRequest:NSMutableURLRequest!             /* NSMutableURLRequest for storing request */
       var json:AnyObject!                           /* Object for storing json response data */
       var dataTask: URLSessionDataTask?             /* URLSessionDataTask for sending requests */

       //MARK: init(_ serviceURL:String)
       init(_ serviceURL:String) {
           self.mServiceURL = serviceURL
           self.dictData = NSMutableDictionary.init()
       }
       
       //MARK: prepareRequest()->(NSMutableURLRequest)
       func prepareRequest()->(NSMutableURLRequest) {
           let tempRequest:NSMutableURLRequest! = NSMutableURLRequest.init()
           tempRequest.timeoutInterval = Constants.Timeout.kNetworkTimeout
           tempRequest.cachePolicy = .useProtocolCachePolicy
           tempRequest.httpMethod = Constants.RequestParam.kURLRequestType
           tempRequest.setValue(Constants.RequestParam.kURLRequestContentValue, forHTTPHeaderField: Constants.RequestParam.kURLRequestContentType)
           
           return tempRequest
       }
       
       //MARK: Response Caching
       @objc(URLSession:dataTask:willCacheResponse:completionHandler:) func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
           
           var newCachedResponse:CachedURLResponse? = proposedResponse
           let newUserInfo:NSDictionary! = NSDictionary.init(object: Date.init(), forKey: Constants.Caching.kURLCachedDate as NSCopying)
           
           if (proposedResponse.response.url?.scheme == Constants.Caching.kCachedURLType) {
               
               /* Cahcing if Request is ONLY of type "https:" */
               newCachedResponse = CachedURLResponse.init(response: proposedResponse.response, data: proposedResponse.data, userInfo: newUserInfo as? [AnyHashable : Any], storagePolicy: URLCache.StoragePolicy.allowedInMemoryOnly)
               
           } else {
               newCachedResponse = CachedURLResponse.init(response: proposedResponse.response, data: proposedResponse.data, userInfo: newUserInfo as? [AnyHashable : Any], storagePolicy: proposedResponse.storagePolicy)
           }
           completionHandler(newCachedResponse);
       }
    
    //MARK: main()
    override func main() {
        
        self.dataTask?.cancel()
        
        /* Call Preparerequest on BaseService */
        self.mRequest = self.prepareRequest()
        
        /* If Service is cancelled by any chance return */
        if self.isCancelled {
            return
        }
        
        /* Get request from URL String */
        self.mRequest.url = URL(string: self.mServiceURL)

        /* Fire Request using URLSession's dataTask API call */
        self.dataTask = URLSession.shared.dataTask(with: mRequest as URLRequest) {(data, response, error) -> Void in
            if let data = data {
                
                /* Call parseResponse for parsing response data */
                self.parseResponse(data as NSData)
                
                /* Send Success Notification */
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name:Notification.Name(rawValue:Constants.Notifications.kNetworkOperationSuccess), object: self.dictData, userInfo: nil)
                }
            } else {
                /* Send Failure Notification */
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name:Notification.Name(rawValue:Constants.Notifications.kNetworkOperationFailure), object: self.dictData, userInfo: nil)
                }
            }
        }
        
        /*Resume Task */
        self.dataTask?.resume()
    }
 
    //MARK: parseResponse(_ response:NSData)
    func parseResponse(_ response:NSData) {
        
        /* Call parseResponse */
        self.json = try? JSONSerialization.jsonObject(with: response as Data, options: []) as AnyObject

        if self.json != nil {    /* If Response is not nil, Parse Countries Data */
            
        } else {    /* If Response is Nil, Store Failed Result  */
            
        }
    }
    
}
