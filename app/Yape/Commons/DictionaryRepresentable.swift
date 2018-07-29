//
//  DictionaryRepresentable.swift
//  Yape
//
//  Created by Igor Savelev on 29/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

protocol DictionaryRepresentable {
    init?(dictionary: [String: Any])
    func asDictionary() -> [String: Any]
}
