//
//  SafariExtensionCommandsDispatcher.swift
//  Yape
//
//  Created by Igor Savelev on 29/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation
import SafariServices

final class SafariExtensionCommandsDispatcher: CommandsDispatcherProtocol, ExtensionContextObserverProtocol {
    private let processingContext: ExecutionContextProtocol
    
    init(processingContext: ExecutionContextProtocol) {
        self.processingContext = processingContext
    }
    
    convenience init(executionContextFactory: ExecutionContextFactoryProtocol = ExecutionContextFactory()) {
        let processingContext = executionContextFactory.makeContext(withExecutionMode: .async(threadType: .background(qos: .userInitiated, name: "Commands Dispatcher Processing Queue", serial: true)))
        self.init(processingContext: processingContext)
    }
    
    private var currentPage: SFSafariPage?
    private var queue: [ExtensionCommand] = []
    
    // MARK: - ExtensionContextObserverProtocol
    
    func pageChanged(to newPage: SFSafariPage) {
        self.processingContext.execute { [weak self] in
            self?.currentPage = newPage
            self?.processQueue()
        }
    }
    
    func windowChanged(to newWindow: SFSafariWindow) {
        self.processingContext.execute { [weak self] in
            self?.currentPage = nil
            newWindow.getActivePage({ (page) in
                guard let page = page else { return }
                self?.pageChanged(to: page)
            })
        }
    }
    
    // MARK: - CommandsDispatcherProtocol
    
    func send(command: ExtensionCommand) {
        self.processingContext.execute { [weak self] in
            guard let sSelf = self else { return }
            sSelf.queue.append(command)
            sSelf.processQueue()
        }
    }
    
    // MARK: - Private
    
    private func processQueue() {
        self.processingContext.execute { [weak self] in
            guard let sSelf = self,
                let page = sSelf.currentPage,
                let command = sSelf.queue.first else { return }
            sSelf.queue.removeFirst()
            page.dispatchMessageToScript(withName: command.name,
                                         userInfo: command.userInfo)
            sSelf.processQueue()
        }
    }
}
