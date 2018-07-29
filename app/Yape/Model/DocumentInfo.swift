//
//  DocumentInfo.swift
//  Yape
//
//  Created by Igor Savelev on 28/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

struct DocumentInfo {
    typealias Identifier = GenericIdentifier<DocumentInfo>
    let uid: Identifier
    let location: String
    let title: String?
}

extension DocumentInfo: DictionaryRepresentable {
    init?(dictionary: [String: Any]) {
        guard let rawUID = dictionary[.uid] as? String,
            let location = dictionary[.location] as? String else {
            return nil
        }
        self.uid = Identifier(rawValue: rawUID)
        self.location = location
        self.title = dictionary[.title] as? String
    }
    
    func asDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [.uid: self.uid.rawValue,
                                         .location: self.location]
        if let title = self.title {
            dictionary[.title] = title
        }
        return dictionary
    }
}

fileprivate extension String {
    static let uid = "uid"
    static let location = "location"
    static let title = "title"
}
