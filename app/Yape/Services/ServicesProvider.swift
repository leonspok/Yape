//
//  ServicesProvider.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

typealias AllServicesProvider =
    CommunicationServiceProvider &
    ExtensionCommunicatorProvider &
    APIServiceProvider

protocol CommunicationServiceProvider {
    var communicationService: CommunicationServiceProtocol { get }
}

protocol ExtensionCommunicatorProvider {
    var extensionCommunicator: ExtensionCommunicatorProtocol { get }
}

protocol APIServiceProvider {
    var apiService: APIServiceProtocol { get }
}
