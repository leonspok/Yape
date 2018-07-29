//
//  ExtensionContextObserverProtocol.swift
//  Yape
//
//  Created by Igor Savelev on 28/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation
import SafariServices

protocol ExtensionContextObserverProtocol {
    func windowChanged(to newWindow: SFSafariWindow)
    func pageChanged(to newPage: SFSafariPage)
}
