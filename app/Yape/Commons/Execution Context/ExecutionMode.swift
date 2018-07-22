//
//  ExecutionMode.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

enum ThreadType {
    case main
    case background(qos: DispatchQoS.QoSClass, name: String, serial: Bool)
}

enum ExecutionMode {
    case async(threadType: ThreadType)
    case delayed(threadType: ThreadType, delay: TimeInterval)
}
