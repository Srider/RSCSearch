//
//  ServicesFactory.swift
//  Countries
//
//  Created by Honeywell on 11/11/17.
//  Copyright © 2017 Honeywell. All rights reserved.
//

import UIKit

class GlobalServiceQueue: OperationQueue {

    static let sharedQueue = GlobalServiceQueue() /* Shared OperationQueue for adding request operations */

}
