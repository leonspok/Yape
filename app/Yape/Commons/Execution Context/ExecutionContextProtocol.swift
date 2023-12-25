//
//  ExecutionContextProtocol.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation
import Combine

protocol ExecutionContextProtocol {
    @discardableResult
    func execute(_ closure: @escaping VoidClosure) -> Cancellable?
}
