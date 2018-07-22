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
        let endpoint = GetVideosEndpoint()
        self.apiService.sendRequest(toEndpoint: endpoint) { (result) in
            switch result {
            case .success(let value):
                let items = value.map({ (videoItem) -> [String: Any] in
                    return videoItem.toDictionary()
                })
                NSLog("\(items)")
            case .failure(let error):
                NSLog("\(error)")
            }
        }
    }
}


