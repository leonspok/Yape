//
//  ExtensionAPIService.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

protocol APIServiceProtocol {
    @discardableResult
    func sendRequest<Endpoint>(toEndpoint endpoint: Endpoint, completion: @escaping (Result<Endpoint.ResponseType>) -> Void) -> Cancellable where Endpoint: APIEndpointProtocol
}

final class APIService: APIServiceProtocol {
    private let communicationService: CommunicationServiceProtocol

    init(communicationService: CommunicationServiceProtocol) {
        self.communicationService = communicationService
    }
    
    func sendRequest<Endpoint>(toEndpoint endpoint: Endpoint, completion: @escaping (Result<Endpoint.ResponseType>) -> Void) -> Cancellable where Endpoint : APIEndpointProtocol {
        let request = APIRequest(endpoint: endpoint)
        return self.communicationService.send(request: request) { (result) in
            switch result {
            case .success(let value):
                let processedResult = endpoint.process(response: value)
                completion(processedResult)
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
    
    // MARK: - Internal Types
    
    private final class APIRequest: CommunicationRequestProtocol {
        lazy var uid: Identifier = GenericIdentifier<CommunicationRequestProtocol>(rawValue: UUID().uuidString)
        let requestName: String
        let params: [String: Any]?
        
        init<Endpoint>(endpoint: Endpoint) where Endpoint: APIEndpointProtocol {
            self.requestName = endpoint.name.rawValue
            self.params = endpoint.params
        }
    }
}
