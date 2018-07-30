//
//  VideoItemsListZeroCaseViewModel.swift
//  Yape
//
//  Created by Igor Savelev on 29/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import AppKit

protocol VideoItemsListZeroCaseViewModelProtocol: class {
    var text: String { get }
    var buttonTitle: String { get }
    var buttonImage: NSImage? { get }
    func buttonPressed()
}

final class VideoItemsListZeroCaseViewModel: VideoItemsListZeroCaseViewModelProtocol {
    let text: String
    let buttonTitle: String
    let buttonImage: NSImage?
    private let onButtonPressed: VoidClosure?
    
    init(text: String = VideoItemsListZeroCaseViewModel.defaultText,
         buttonTitle: String = VideoItemsListZeroCaseViewModel.defaultButtonTitle,
         buttonImage: NSImage? = NSImage(named: .refreshTemplate),
         onButtonPressed: VoidClosure? = nil) {
        self.text = text
        self.buttonTitle = buttonTitle
        self.buttonImage = buttonImage
        self.onButtonPressed = onButtonPressed
    }
    
    func buttonPressed() {
        self.onButtonPressed?()
    }
}

fileprivate extension VideoItemsListZeroCaseViewModel {
    static let defaultText = NSLocalizedString("video.items.list.zero.case.label.text", comment: "No videos found")
    static let defaultButtonTitle = NSLocalizedString("video.items.list.zero.case.button.title", comment: "Reload")
}
