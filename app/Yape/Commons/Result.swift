//
//  Result.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(value: T)
    case failure(error: Error)
}
