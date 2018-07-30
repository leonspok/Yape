//
//  GenericIdentifier.swift
//  Yape
//
//  Created by Igor Savelev on 21/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

struct GenericIdentifier<Owner>: RawRepresentable, Equatable, Hashable {
    typealias RawValue = String
    let rawValue: String
    
    init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
}
