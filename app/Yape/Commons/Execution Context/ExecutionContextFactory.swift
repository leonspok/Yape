//
//  ExecutionContextFactory.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

protocol ExecutionContextFactoryProtocol {
    func makeContext(withExecutionMode executionMode: ExecutionMode) -> ExecutionContextProtocol
}

final class ExecutionContextFactory: ExecutionContextFactoryProtocol {
    func makeContext(withExecutionMode executionMode: ExecutionMode) -> ExecutionContextProtocol {
        switch executionMode {
        case .async(let threadType):
            return self.makeGCDContext(threadType: threadType)
        case .delayed(let threadType, let delay):
            return self.makeGCDContext(threadType: threadType, delay: delay)
        }
    }
    
    private func makeGCDContext(threadType: ThreadType, delay: TimeInterval = 0) -> GCDExecutionContext {
        var queue: DispatchQueue {
            switch threadType {
            case .main:
                return DispatchQueue.main
            case .background(let qos, let name, let serial):
                if serial {
                    return DispatchQueue(label: name, qos: DispatchQoS(qosClass: qos, relativePriority: 0))
                } else {
                    return DispatchQueue(label: name, qos: DispatchQoS(qosClass: qos, relativePriority: 0), attributes: .concurrent)
                }
            }
        }
        return GCDExecutionContext(queue: queue, mode: .async(delay: delay))
    }
}
