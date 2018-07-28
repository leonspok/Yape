//
//  VideoItemsListSectionProtocol.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

protocol VideoItemsListSectionProtocol {
    var title: String { get }
    var items: [VideoItemViewModelProtocol] { get }
}

struct VideoItemsListSection: VideoItemsListSectionProtocol {
    let title: String
    let items: [VideoItemViewModelProtocol]
    
    init(title: String,
         items: [VideoItemViewModelProtocol]) {
        self.title = title
        self.items = items
    }
}
