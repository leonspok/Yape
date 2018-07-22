//
//  ExtensionCommunicationContext.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import SafariServices

protocol ExtensionCommunicationProtocol {
    func windowChanged(to newWindow: SFSafariWindow)
    func pageChanged(to newPage: SFSafariPage)
    func receivedMessage(name: String, userInfo: [String: Any]?)
}
