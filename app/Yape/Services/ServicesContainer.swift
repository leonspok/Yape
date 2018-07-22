//
//  ServicesContainer.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

final class ServicesContainer: AllServicesProvider {
    
    static let shared = ServicesContainer()
    
    let communicationService: CommunicationServiceProtocol
    let extensionCommunicationService: ExtensionCommunicationProtocol
    let apiService: APIServiceProtocol
    
    init() {
        let safariCommunication = SafariExtensionCommunicationService()
        let apiService = APIService(communicationService: safariCommunication)
        self.communicationService = safariCommunication
        self.extensionCommunicationService = safariCommunication
        self.apiService = apiService
    }
}
