//
//  ServicesProvider.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

typealias AllServicesProvider =
    ExtensionContextObserverProvider &
    ExtensionMessagesProcessorProvider &
    ExtensionMessagesReceiverProvider &
    CommandsDispatcherProvider

protocol ExtensionContextObserverProvider {
    var extensionContextObserver: ExtensionContextObserverProtocol { get }
}

protocol ExtensionMessagesProcessorProvider {
    var extensionMessagesProcessor: ExtensionMessagesProcessorProtocol { get }
}

protocol ExtensionMessagesReceiverProvider {
    var extensionMessagesReceiver: ExtensionMessagesReceiverProtocol { get }
}

protocol CommandsDispatcherProvider {
    var commandsDispatcher: CommandsDispatcherProtocol { get }
}
