//
//  SafariExtensionHandler.swift
//  Yape
//
//  Created by Igor Savelev on 21/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    private let extensionCommunicator: ExtensionCommunicatorProtocol = ServicesContainer.shared.extensionCommunicator
    private let apiService: APIServiceProtocol = ServicesContainer.shared.apiService
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        NSLog("Message received \(messageName)")
        self.extensionCommunicator.pageChanged(to: page)
        self.extensionCommunicator.receivedMessage(name: messageName, userInfo: userInfo)
    }
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        self.extensionCommunicator.windowChanged(to: window)
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        self.extensionCommunicator.windowChanged(to: window)
        validationHandler(true, "")
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }

    override func popoverWillShow(in window: SFSafariWindow) {
        self.extensionCommunicator.windowChanged(to: window)
        let viewModel = VideoItemsListViewModel()
        viewModel.reload()
        SafariExtensionViewController.shared.viewModel = viewModel
    }
}


