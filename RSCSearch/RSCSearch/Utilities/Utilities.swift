//
//  Utilities.swift
//  Countries
//
//  Created by Honeywell on 10/11/17.
//  Copyright © 2017 Honeywell. All rights reserved.
//

import UIKit

class Utilities: NSObject {
    
    var reachable:Reachability!              /* Reachability instance for listening network changes */
    static let sharedInstance = Utilities()     /* Utilities shared instance */
    var isStatusModified:Bool! = false
    
    //MARK: startHost()
    func startHost() {
        stopNotifier()
        setupReachability("www.google.com", useClosures: false)
        startNotifier()
    }
    
    //MARK: setupReachability(_ hostName: String?, useClosures: Bool)
    func setupReachability(_ hostName: String?, useClosures: Bool) {
        let reachability: Reachability?
        if let hostName = hostName {
            reachability = Reachability(hostname: hostName)
        } else {
            reachability = Reachability()
        }
        self.reachable = reachability
        self.isStatusModified = true
        
        if useClosures {
            reachability?.whenReachable = { reachability in
                self.updateReachable(reachability)
            }
            reachability?.whenUnreachable = { reachability in
                self.updateNotReachable(reachability)
            }
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: .reachabilityChanged, object: reachability)
        }
    }
    
    //MARK: startNotifier()
    func startNotifier() {
        print("--- start notifier")
        do {
            try reachable?.startNotifier()
        } catch {
            return
        }
    }
    
    //MARK: stopNotifier()
    func stopNotifier() {
        print("--- stop notifier")
        reachable?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
        reachable = nil
    }
    
    
    //MARK: reachabilityChanged(_ note: Notification)->Void
    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        
        if reachability.connection != .none {
            updateReachable(reachability)
        } else {
            updateNotReachable(reachability)
        }
    }
    
    func updateReachable(_ reachability: Reachability) {
        print("\(reachability.description) - \(reachability.connection)")
        if reachability.connection == .wifi {
            print("WiFi")
            DispatchQueue.main.async {
                NotificationCenter.default.post(name:Notification.Name(rawValue:"Reachable"),
                                                object: nil, userInfo: nil)
            }
        }
    }
    
    func updateNotReachable(_ reachability: Reachability) {
        print("Not Reachable")
        DispatchQueue.main.async {
            NotificationCenter.default.post(name:Notification.Name(rawValue:"NotReachable"),
                                            object: nil, userInfo: nil)
        }
    }

    //MARK: isNetworkAvailable()->Bool
    public func isNetworkAvailable()->Bool {
        var status:Bool! = false
        if self.reachable!.connection != .none {
            if self.reachable!.connection == .wifi {
                //WiFi Available
                status = true
            } else {
                status = false
            }
        } else {
            status = false
        }
        return status
    }
    
    //MARK: stopNotifier()
    deinit {
        stopNotifier()
    }
}
