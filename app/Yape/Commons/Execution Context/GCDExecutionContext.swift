//
//  GCDExecutionContext.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

final class GCDExecutionContext: ExecutionContextProtocol {
    enum Mode {
        case async(delay: TimeInterval)
        case sync
    }
    
    private let queue: DispatchQueue
    private let mode: Mode
    
    init(queue: DispatchQueue, mode: Mode = .async(delay: 0)) {
        self.queue = queue
        self.mode = mode
    }
    
    func execute(_ closure: @escaping VoidClosure) -> Cancellable? {
        let workItem = DispatchWorkItem(block: closure)
        let token = ExecutionToken(workItem: workItem)
        switch self.mode {
        case .async(let delay):
            if delay > 0 {
                self.queue.asyncAfter(deadline: .now() + delay, execute: workItem)
            } else {
                self.queue.async(execute: workItem)
            }
        case .sync:
            assert(!Thread.isMainThread, "Synchrounous execution on main thread is not allowed")
            self.queue.sync(execute: workItem)
        }
        self.queue.async(execute: workItem)
        return token
    }
    
    // MARK: Helpers
    
    private struct ExecutionToken: Cancellable {
        private let workItem: DispatchWorkItem
        
        init(workItem: DispatchWorkItem) {
            self.workItem = workItem
        }
        
        func cancel() {
            self.workItem.cancel()
        }
    }
}
