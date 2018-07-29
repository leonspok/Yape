//
//  DebugLog.swift
//  Yape
//
//  Created by Igor Savelev on 29/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

func debugLog(_ format: String, _ args: CVarArg...) {
    #if DEBUG
    NSLog(format, args)
    #endif
}
