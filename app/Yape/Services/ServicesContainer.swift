//
//  ServicesContainer.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

final class ServicesContainer: AllServicesProvider {
    
    static let shared = ServicesContainer()
    
    let extensionContextObserver: ExtensionContextObserverProtocol
    let extensionMessagesProcessor: ExtensionMessagesProcessorProtocol
    let extensionMessagesReceiver: ExtensionMessagesReceiverProtocol
    let commandsDispatcher: CommandsDispatcherProtocol
    
    #if DEBUG
    let anyMessageObserver: ExtensionMessagesReceiverProtocol.OpaqueObserver
    #endif
    
    init() {
        let commandsDispatcher = SafariExtensionCommandsDispatcher()
        let messagingService = SafariExtensionMessagingService()
        #if DEBUG
        self.anyMessageObserver = messagingService.subscribe(to: AnyMessage.self, onMessageReceived: { (message) in
            debugLog("Received message with info: \(String(describing: message.asDictionary()))")
        })
        #endif
        self.extensionContextObserver = commandsDispatcher
        self.commandsDispatcher = commandsDispatcher
        self.extensionMessagesProcessor = messagingService
        self.extensionMessagesReceiver = messagingService
    }
}
