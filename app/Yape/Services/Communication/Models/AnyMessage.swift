//
//  RawMessage.swift
//  Yape
//
//  Created by Igor Savelev on 29/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

struct AnyMessage: ExtensionMessageProtocol {
    static let messageType: ExtensionMessageType = .any
    private let dictionaryInfo: [String: Any]
    
    init?(dictionary: [String : Any]) {
        self.dictionaryInfo = dictionary
    }
    
    func asDictionary() -> [String : Any] {
        return self.dictionaryInfo
    }
}
