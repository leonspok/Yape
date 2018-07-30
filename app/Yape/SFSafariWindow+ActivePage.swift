//
//  SFSafariWindow+ActivePage.swift
//  Yape
//
//  Created by Igor Savelev on 28/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation
import SafariServices

extension SFSafariWindow {
    func getActivePage(_ completion: @escaping (SFSafariPage?) -> Void) {
        self.getActiveTab { (tab) in
            guard let tab = tab else {
                completion(nil)
                return
            }
            tab.getActivePage(completionHandler: completion)
        }
    }
}
