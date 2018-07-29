//
//  ExtensionMessageProtocol.swift
//  Yape
//
//  Created by Igor Savelev on 29/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

protocol ExtensionMessageProtocol: DictionaryRepresentable {
    static var messageType: ExtensionMessageType { get }
}
