//
//  ExtensionMessagesHandlerProtocol.swift
//  Yape
//
//  Created by Igor Savelev on 28/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

protocol ExtensionMessagesProcessorProtocol {
    func processMessage(withName name: String, userInfo: [String: Any]?)
}
