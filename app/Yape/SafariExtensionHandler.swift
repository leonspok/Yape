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
    
    private let popoverViewModel = VideoItemsListViewModel()
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        self.contextObserver.pageChanged(to: page)
        self.messagesProcessor.processMessage(withName: messageName, userInfo: userInfo)
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        self.contextObserver.windowChanged(to: window)
        self.popoverViewModel.reset()
        validationHandler(true, "")
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        let popoverViewController = SafariExtensionViewController(nibName: NSNib.Name(rawValue: "SafariExtensionViewController"), bundle: nil)
        popoverViewController.viewModel = self.popoverViewModel
        return popoverViewController
    }

    override func popoverWillShow(in window: SFSafariWindow) {
        self.contextObserver.windowChanged(to: window)
        self.popoverViewModel.reload()
    }
}

