//
//  SafariExtensionCommunicationService.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import SafariServices

final class SafariExtensionMessagingService: ExtensionMessagesProcessorProtocol, ExtensionMessagesReceiverProtocol {
    
    private let processingContext: ExecutionContextProtocol
    private let responseContext: ExecutionContextProtocol
    
    init(processingContext: ExecutionContextProtocol,
         responseContext: ExecutionContextProtocol) {
        self.processingContext = processingContext
        self.responseContext = responseContext
    }
    
    convenience init(executionContextFactory: ExecutionContextFactoryProtocol = ExecutionContextFactory()) {
        let processingContext = executionContextFactory.makeContext(withExecutionMode: .async(threadType: .background(qos: .userInitiated, name: "Messaging Service Processing Queue", serial: true)))
        let responseContext = executionContextFactory.makeContext(withExecutionMode: .async(threadType: .main))
        self.init(processingContext: processingContext,
                  responseContext: responseContext)
    }
    
    private var handlers: [ExtensionMessageType: [HandlerWeakHolder]] = [:]
    
    // MARK: - ExtensionMessagesProcessorProtocol
    
    func processMessage(withName name: String, userInfo: [String: Any]?) {
        self.processingContext.execute { [weak self] in
            guard let sSelf = self else { return }
            var handlers: [RawMessageHandlerProtocol] = (sSelf.handlers[.any] ?? []).compactMap({ $0.handler })
            if let extensionName = ExtensionConcreteMessageName(rawValue: name) {
                handlers += (sSelf.handlers[.concrete(name: extensionName)] ?? []).compactMap({ $0.handler })
            }
            handlers.forEach({ $0.handle(messageInfo: userInfo ?? [:]) })
            sSelf.clearReleasedObservers()
        }
    }
    
    // MARK: - ExtensionMessagesReceiverProtocol
    
    func subscribe<MessageType>(to messageType: MessageType.Type,
                                onMessageReceived: @escaping (MessageType) -> Void) -> OpaqueObserver where MessageType : ExtensionMessageProtocol {
        let messageHandler = MessageHandler<MessageType>(onMessageReceived: onMessageReceived,
                                                         handlingContext: self.responseContext)
        self.processingContext.execute { [weak self] in
            guard let sSelf = self else { return }
            let holder = HandlerWeakHolder(messageHandler)
            var handlers = sSelf.handlers[MessageType.messageType] ?? []
            handlers.append(holder)
            sSelf.handlers[MessageType.messageType] = handlers
        }
        return messageHandler
    }

    // MARK: - Private
    
    private func clearReleasedObservers() {
        self.processingContext.execute {
            let oldHandlers = self.handlers
            for (messageType, handlers) in oldHandlers {
                self.handlers[messageType] = handlers.filter({ $0.handler != nil })
            }
        }
    }
    
    // MARK: - Internal Type
    
    private final class HandlerWeakHolder {
        weak var handler: RawMessageHandlerProtocol?
        
        init(_ handler: RawMessageHandlerProtocol) {
            self.handler = handler
        }
    }
    
    private final class MessageHandler<MessageType>: RawMessageHandlerProtocol where MessageType: ExtensionMessageProtocol {
        private let onMessageReceived: (MessageType) -> Void
        private let handlingContext: ExecutionContextProtocol
        
        init(onMessageReceived: @escaping (MessageType) -> Void, handlingContext: ExecutionContextProtocol) {
            self.onMessageReceived = onMessageReceived
            self.handlingContext = handlingContext
        }
        
        func handle(messageInfo: [String: Any]) {
            guard let message = MessageType(dictionary: messageInfo) else {
                return
            }
            self.handlingContext.execute { [weak self] in
                self?.onMessageReceived(message)
            }
        }
    }
}

fileprivate protocol RawMessageHandlerProtocol: class {
    func handle(messageInfo: [String: Any])
}
