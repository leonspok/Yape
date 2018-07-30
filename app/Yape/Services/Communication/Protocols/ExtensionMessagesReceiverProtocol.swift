//
//  ExtensionMessagingProtocol.swift
//  Yape
//
//  Created by Igor Savelev on 28/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

protocol ExtensionMessagesReceiverProtocol {
    typealias OpaqueObserver = Any
    func subscribe<MessageType>(to messageType: MessageType.Type,
                                onMessageReceived: @escaping (MessageType) -> Void) -> OpaqueObserver where MessageType: ExtensionMessageProtocol
}
