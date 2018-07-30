//
//  SafariExtensionHandler.swift
//  Yape
//
//  Created by Igor Savelev on 21/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    private let contextObserver: ExtensionContextObserverProtocol = ServicesContainer.shared.extensionContextObserver
    private let messagesProcessor: ExtensionMessagesProcessorProtocol = ServicesContainer.shared.extensionMessagesProcessor
    private let commandsDispatcher: CommandsDispatcherProtocol = ServicesContainer.shared.commandsDispatcher
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        self.contextObserver.pageChanged(to: page)
        self.messagesProcessor.processMessage(withName: messageName, userInfo: userInfo)
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        self.contextObserver.windowChanged(to: window)
        self.commandsDispatcher.send(command: .exportVideos)
        validationHandler(true, "")
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }

    override func popoverWillShow(in window: SFSafariWindow) {
        self.contextObserver.windowChanged(to: window)
        let viewModel = VideoItemsListViewModel()
        viewModel.reload()
        SafariExtensionViewController.shared.viewModel = viewModel
    }
}


