//
//  SafariExtensionCommunicationService.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import SafariServices

final class SafariExtensionCommunicationService: CommunicationServiceProtocol, ExtensionCommunicatorProtocol {
    
    private struct Constants {
        static let defaultTimeout: TimeInterval = 10
    }
    
    private let processingContext: ExecutionContextProtocol
    private let requestTimeoutContext: ExecutionContextProtocol
    private let responseContext: ExecutionContextProtocol
    
    init(processingContext: ExecutionContextProtocol,
         requestTimeoutContext: ExecutionContextProtocol,
         responseContext: ExecutionContextProtocol) {
        self.processingContext = processingContext
        self.requestTimeoutContext = requestTimeoutContext
        self.responseContext = responseContext
    }
    
    convenience init(executionContextFactory: ExecutionContextFactoryProtocol = ExecutionContextFactory()) {
        let processingContext = executionContextFactory.makeContext(withExecutionMode: .async(threadType: .background(qos: .userInitiated, name: "Communication Service Processing Queue", serial: true)))
        let requestTimeoutContext = executionContextFactory.makeContext(withExecutionMode: .delayed(threadType: .background(qos: .utility, name: "Communication Service Request Timeout Handler Queue", serial: false), delay: Constants.defaultTimeout))
        let responseContext = executionContextFactory.makeContext(withExecutionMode: .async(threadType: .main))
        self.init(processingContext: processingContext,
                  requestTimeoutContext: requestTimeoutContext,
                  responseContext: responseContext)
    }
    
    private var queue: [CommunicationRequestProtocol.Identifier] = [] {
        didSet {
            NSLog("QUEUE: \(self.queue)")
        }
    }
    private var requests: [CommunicationRequestProtocol.Identifier: CommunicationRequestProtocol] = [:]
    private var tokens: [CommunicationRequestProtocol.Identifier: Cancellable] = [:]
    private var completionHandlers: [CommunicationRequestProtocol.Identifier: Completion] = [:]
    
    private var currentPage: SFSafariPage?
    
    // MARK: - CommunicationServiceProtocol
    
    func send(request: CommunicationRequestProtocol, completion: @escaping CommunicationServiceProtocol.Completion) -> Cancellable {
        let token = RequestToken { [weak self] in
            self?.removeRequest(withUID: request.uid)
        }
        
        NSLog("Going to send request with uid: \(request.uid.rawValue)")
        token.processingToken = self.processingContext.execute { [weak self] in
            guard let sSelf = self else { return }
            sSelf.queue.append(request.uid)
            sSelf.requests[request.uid] = request
            sSelf.tokens[request.uid] = token
            sSelf.completionHandlers[request.uid] = completion
            
            NSLog("Processed \(request.uid.rawValue)")
            sSelf.requestTimeoutContext.execute {
                NSLog("Timeout! \(request.uid.rawValue)")
                self?.finish(withError: CommunicationRequestError.requestTimeout, requestWithUID: request.uid)
            }
            
            sSelf.processQueue()
        }
        
        return token
    }
    
    // MARK: - ExtensionCommunicatorProtocol
    
    func pageChanged(to newPage: SFSafariPage) {
        self.processingContext.execute { [weak self] in
            self?.currentPage = newPage
            self?.processQueue()
        }
    }
    
    func windowChanged(to newWindow: SFSafariWindow) {
        self.processingContext.execute { [weak self] in
            self?.currentPage = nil
            newWindow.getActivePage({ (page) in
                guard let page = page else { return }
                self?.pageChanged(to: page)
            })
        }
    }
    
    func receivedMessage(name: String, userInfo: [String : Any]?) {
        NSLog("Received message \(name)")
        let requestUID = CommunicationRequestProtocol.Identifier(rawValue: name)
        self.processingContext.execute { [weak self] in
            guard let sSelf = self,
                let completionHandler = sSelf.completionHandlers[requestUID] else { return }
            sSelf.removeRequest(withUID: requestUID)
            sSelf.responseContext.execute {
                completionHandler(.success(value: userInfo))
            }
        }
    }
    
    // MARK: - Private
    
    private func processQueue() {
        self.processingContext.execute { [weak self] in
            guard let sSelf = self,
                let page = sSelf.currentPage,
                let nextId = sSelf.queue.first,
                let request = sSelf.requests[nextId] else { return }
            NSLog("Processing \(nextId.rawValue)")
            sSelf.queue.removeFirst()
            var userInfo: [String: Any] = [.requestName: request.requestName]
            if let params = request.params {
                userInfo[.params] = params
            }
            sSelf.responseContext.execute {
                page.dispatchMessageToScript(withName: request.uid.rawValue, userInfo: userInfo)
                NSLog("Message sent \(nextId.rawValue)")
            }
            sSelf.processQueue()
        }
    }
    
    private func removeRequest(withUID uid: CommunicationRequestProtocol.Identifier) {
        self.processingContext.execute { [weak self] in
            guard let sSelf = self else { return }
            NSLog("Remove request \(uid)")
            sSelf.queue = sSelf.queue.filter({ $0 != uid })
            sSelf.requests.removeValue(forKey: uid)
            sSelf.tokens.removeValue(forKey: uid)
            sSelf.completionHandlers.removeValue(forKey: uid)
        }
    }
    
    private func finish(withError error: Error, requestWithUID requestUID: CommunicationRequestProtocol.Identifier) {
        self.processingContext.execute { [weak self] in
            guard let sSelf = self,
                let completionHandler = sSelf.completionHandlers[requestUID] else { return }
            sSelf.removeRequest(withUID: requestUID)
            sSelf.responseContext.execute {
                completionHandler(.failure(error: error))
            }
        }
    }
    
    private final class RequestToken: Cancellable {
        var processingToken: Cancellable?
        let onCancel: VoidClosure
        
        init(onCancel: @escaping VoidClosure) {
            self.onCancel = onCancel
        }
        
        func cancel() {
            self.processingToken?.cancel()
            self.onCancel()
        }
    }
}

fileprivate extension String {
    static let requestName = "request_name"
    static let params = "params"
}
