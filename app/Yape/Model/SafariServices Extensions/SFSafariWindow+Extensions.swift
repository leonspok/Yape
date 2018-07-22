//
//  SFSafariWindow+Extensions.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import SafariServices

extension SFSafariWindow {
    func getActivePage(_ callback: @escaping (SFSafariPage?) -> Void) {
        self.getActiveTab { (tab) in
            guard let tab = tab else {
                callback(nil)
                return
            }
            tab.getActivePage(completionHandler: callback)
        }
    }
}
