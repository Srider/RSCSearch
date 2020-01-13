//
//  NetworkManager.swift
//  Countries
//
//  Created by Honeywell on 11/11/17.
//  Copyright © 2017 Honeywell. All rights reserved.
//

import UIKit

public class NetworkManager: NSObject {
    public static let sharedServiceManager = NetworkManager()                      /* NetworkManager - shared instance for adding requests */
    var currentOperation:RSCSearchService?                                       /* BaseService - for tracking current service operation */
    var downloadInProgres:Bool! = false                                     /* Bool - For tracking whether service operation is already in progress */
    var arrRequestList:NSMutableArray = NSMutableArray.init()               /* NSMutableArray - For aggregating requests */
    var requestQueue:GlobalServiceQueue? = GlobalServiceQueue.sharedQueue   /* GlobalServiceQueue - For adding service requests */
    var timer:Timer!                                                        /* Timer - For scheduling periodic service requests */
    var successHandler:(NSMutableDictionary?)->Void={NSMutableDictionary in }                 /* (NSMutableDictionary?)->Void - Success Completion Handler */
    var failureHandler:()->Void={}                                          /* ()->Void - Failure Completion Handler */

    //Configure Request Queue and Start Timer
    public func configureManager() -> Void {
        
        /* Register for notifications */
        registerNotifications()
        
        /* Make serial. */
        requestQueue?.maxConcurrentOperationCount = 1
        
        /* Start Timer */
        startTimer()
    }
    
    //MARK: Register Notifications
    internal func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateResultsWithData), name: NSNotification.Name(rawValue: Constants.Notifications.kNetworkOperationSuccess), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEndRequestWithFailure), name: NSNotification.Name(rawValue: Constants.Notifications.kNetworkOperationFailure), object: nil)
    }
    
    //MARK: Unregister Notificatons
    internal func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    //Start Timer
    internal func startTimer() {
        if timer == nil {
            /*start timer for periodic scheduling of requests */
            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (Timer)->() in
                self.sendRequest()
            })
        }
    }
    
    //Stop Timer
    internal func stopTimer() {
        if timer != nil {
            timer.invalidate()
        }
    }

    public func addRequestToQueue( _ string:String!, fromURL url: String, onSuccess successBlock: @escaping (_ demoData:NSMutableDictionary?) -> (), onFailure failureBlock: @escaping () -> ()) {
        
        /* Add request operation to Queue. */
        arrRequestList.add(RSCSearchService.init(url))
                
        /* Assign success and failure callbacks. */
        successHandler = successBlock
        failureHandler = failureBlock

    }
    
    // MARK: - Periodic Send Request
    fileprivate func sendRequest() {
        
        /* If request operation Queue is not Empty && Request Operation is not in progress */
        if (arrRequestList.count > 0) && (downloadInProgres == false) {
            downloadInProgres = true
            currentOperation = arrRequestList.firstObject as? RSCSearchService
            requestQueue?.addOperation {
                self.currentOperation?.main()
            }
        } 
    }

    //MARK: didUpdateSearchResults()
     @objc func didUpdateResultsWithData(_ notification:Notification)->Void {
        
        /* Remove old request operation from Queue */
        removeCompletedOperation()
        
        /* call success handler */
        let dictData = notification.object! as! NSMutableDictionary
        successHandler(dictData)
    }
    
    //MARK: didFailToSendRequest()
    @objc func didEndRequestWithFailure()->Void {
        
        /* Remove old request operation from Queue */
        removeCompletedOperation()
        
        /* call success handler */
        failureHandler()
    }

    //MARK: removeCompletedOperation()
    internal func removeCompletedOperation() {
        
        /* Remove old request operation from list */
        if arrRequestList.count > 0 {
            arrRequestList.removeObject(at: 0)
        }
        
        /* Reset request download availabiity slot */
        if downloadInProgres == true {
            downloadInProgres = false
        }
    }
    
    deinit {
        stopTimer()
        unregisterNotifications()
        downloadInProgres = false
    }
}
