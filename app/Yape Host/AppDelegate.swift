//
//  AppDelegate.swift
//  Yape Host
//
//  Created by Igor Savelev on 21/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Cocoa
import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let notification = NSUserNotification()
            notification.title = NSLocalizedString("notification.extension.installed.text", comment: "Extension installed")
            notification.informativeText = NSLocalizedString("notification.extension.installed.informative.text", comment: "Please, enable it in Safari")
            notification.hasActionButton = false
            NSUserNotificationCenter.default.deliver(notification)
        }
        
        #if DEBUG
        #else
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            NSApplication.shared.terminate(nil)
        }
        #endif
    }
}

