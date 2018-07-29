//
//  VideoItemsListZeroCaseViewModel.swift
//  Yape
//
//  Created by Igor Savelev on 29/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

protocol VideoItemsListZeroCaseViewModelProtocol {
    var text: String { get }
    var buttonTitle: String { get }
    func buttonPressed()
}

final class VideoItemsListZeroCaseViewModel: VideoItemsListZeroCaseViewModelProtocol {
    let text: String
    let buttonTitle: String
    private let onButtonPressed: VoidClosure?
    
    init(text: String = VideoItemsListZeroCaseViewModel.defaultText,
         buttonTitle: String = VideoItemsListZeroCaseViewModel.defaultButtonTitle,
         onButtonPressed: VoidClosure? = nil) {
        self.text = text
        self.buttonTitle = buttonTitle
        self.onButtonPressed = onButtonPressed
    }
    
    func buttonPressed() {
        self.onButtonPressed?()
    }
}

fileprivate extension VideoItemsListZeroCaseViewModel {
    static let defaultText = NSLocalizedString("video.items.list.zero.case.label.text", comment: "No videos found")
    static let defaultButtonTitle = "⟲ " + NSLocalizedString("video.items.list.zero.case.button.title", comment: "Reload")
}
