//
//  AppConstants.swift
//  Symbio_Countries
//
//  Created by Honeywell on 18/11/17.
//  Copyright © 2017 Honeywell. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Alerts {
        static let kSearchTitle = "Search"
        static let NETWORK_ALERT = "Network alert"
        static let kNoNetworkMessage = "Network not available."
        static let kNetworkAvailableMessage = "Internet is available."
        
        static let kOkayButtontitle = "Okay"
        
        static let NO_COUNTRIES_ALERT = "No countries alert"
        static let kNoCountriesMessage = "No countries available for the given name."
        
        static let COUNTRIES_SEARCH_ALERT = "Search countries Alert."
        static let kCountrySearchOperationFailed = "Countries search operation failed !!!"
        
        static let COUNTRY_DETAILS_ALERT = "Country details alert."
        static let kCountryDetailOperationFailed = "Countries details fetch operation failed !!!"
        
        static let SEARCH_ALERT = "Search alert"
        static let kEmptySearchMessage = "Please enter a valid country name to search "
    }
    
    struct Timeout {
        static let kNetworkTimeout = 5.0
    }
    
    struct URLS {
        static let kReachabilityURL = "www.google.com"
    }
    
    struct RequestParam {
        static let kURLRequestType = "GET"
        static let kURLRequestContentValue = "application/json"
        static let kURLRequestContentType = "Content-Type"
    }
    
    struct Notifications {
        static let kNetworkReachable = "Reachable"
        static let kNetworkNotReachable = "NotReachable"
        static let kNetworkOperationSuccess = "SuccessNotification"
        static let kNetworkOperationFailure = "FailureNotification"
    }
    
    struct Caching {
        static let kURLCachedDate = "Cached Date"
        static let kCachedURLType = "https"
    }
    
    struct ResponseStatusKeys {
        static let kJSONResponseStatus = "status"
        static let kJSONResponseData = "data"
        static let kJSONResponseCode = "code"
        static let kJSONResponseSuccess = "Success"
        static let kJSONResponseResult = "result"
        static let kJSONResponseMessage = "message"
        static let kJSONResponseNotFound = "Not Found"
        static let kJSONRequestTimedout = "Request Timed Out"
        static let kJSONResponseSuccessStatus = 200
        static let kJSONResponseFailedStatus = 404
        static let kNoResponseText = "Not Available"
    }
}
