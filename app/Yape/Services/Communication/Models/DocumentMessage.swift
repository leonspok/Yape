//
//  ExtensionMessage.swift
//  Yape
//
//  Created by Igor Savelev on 28/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

struct DocumentMessage<MessageInfo>: ExtensionMessageProtocol where MessageInfo: ExtensionMessageInfoProtocol {
    static var messageType: ExtensionMessageType {
        return MessageInfo.containingMessageType
    }
    let documentInfo: DocumentInfo
    let messageInfo: MessageInfo
    
    init?(dictionary: [String: Any]) {
        guard let rawDocumentInfo = dictionary[.document] as? [String: Any],
            let documentInfo = DocumentInfo(dictionary: rawDocumentInfo),
            let rawMessageInfo = dictionary[.message] as? [String: Any],
            let messageInfo = MessageInfo(dictionary: rawMessageInfo) else {
            return nil
        }
        self.documentInfo = documentInfo
        self.messageInfo = messageInfo
    }
    
    func asDictionary() -> [String : Any] {
        return [.document: self.documentInfo.asDictionary(),
                .message: self.messageInfo.asDictionary()]
    }
}

fileprivate extension String {
    static let document = "document"
    static let message = "message"
}
