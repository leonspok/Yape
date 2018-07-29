//
//  VideoItemsListSection.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

protocol VideoItemsListSectionViewModelProtocol {
    var title: String { get }
}

struct VideoItemsListSectionViewModel: VideoItemsListSectionViewModelProtocol {
    let title: String
    
    init(collection: VideoItemsCollection) {
        self.title = collection.title
    }
}
