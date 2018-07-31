//
//  VideoItemsListViewModel.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

protocol VideoItemsListViewModelProtocol: class {
    var zeroCaseViewModel: VideoItemsListZeroCaseViewModelProtocol { get }
    
    var onUpdate: VoidClosure? { get set }
    func sectionViewModel(inSection section: Int) -> VideoItemsListSectionViewModelProtocol?
    func itemViewModel(at indexPath: IndexPath) -> VideoItemViewModelProtocol?
    func reload()
    func reset()
    
    var numberOfSections: Int { get }
    func numberOfItems(inSection section: Int) -> Int
    func didSelectItem(at indexPath: IndexPath)
}

final class VideoItemsListViewModel: VideoItemsListViewModelProtocol {
    typealias Dependencies =
        VideoItemViewModel.Dependencies &
        CommandsDispatcherProvider &
        ExtensionMessagesReceiverProvider
    
    private let dependencies: Dependencies
    private var messagesObserver: ExtensionMessagesReceiverProtocol.OpaqueObserver?

    private var collections: [VideoItemsCollection] = [] {
        didSet {
            self.onUpdate?()
        }
    }
    
    init(dependencies: Dependencies = ServicesContainer.shared) {
        self.dependencies = dependencies
        self.messagesObserver = self.dependencies.extensionMessagesReceiver.subscribe(to: VideosListMessage.self, onMessageReceived: { [weak self] (message) in
            self?.handle(message: message)
        })
    }
    
    // MARK: - VideoItemsListViewModelProtocol

    var onUpdate: VoidClosure?
    
    private(set) lazy var zeroCaseViewModel: VideoItemsListZeroCaseViewModelProtocol = {
        return VideoItemsListZeroCaseViewModel(onButtonPressed: { [weak self] in
            self?.reload()
        })
    }()

    func sectionViewModel(inSection section: Int) -> VideoItemsListSectionViewModelProtocol? {
        guard section >= 0, section < self.collections.count else {
            return nil
        }
        return VideoItemsListSectionViewModel(collection: self.collections[section])
    }
    
    func itemViewModel(at indexPath: IndexPath) -> VideoItemViewModelProtocol? {
        guard indexPath.section >= 0, indexPath.section < self.collections.count else { return nil }
        guard indexPath.item >= 0, indexPath.item < self.collections[indexPath.section].videos.count else { return nil }
        let viewModel = VideoItemViewModel(videoItem: self.collections[indexPath.section].videos[indexPath.item])
        viewModel.isLastInSection = (indexPath.item == self.numberOfItems(inSection: indexPath.section) - 1)
        return viewModel
    }
    
    func reload() {
        self.dependencies.commandsDispatcher.send(command: .exportVideos)
    }
    
    func reset() {
        self.collections = []
        self.dependencies.commandsDispatcher.send(command: .removeHighlight)
    }
    
    var numberOfSections: Int {
        return self.collections.count
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        guard section >= 0, section < self.collections.count else { return 0 }
        return self.collections[section].videos.count
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        guard let viewModel = self.itemViewModel(at: indexPath) else { return }
        viewModel.didSelect()
    }
    
    // MARK: - Private
    
    private func handle(message: VideosListMessage) {
        let collection = message.collection
        
        var hasUpdates = true
        var collections = self.collections
        if let existingSectionIndex = collections.index(where: { $0.uid == collection.uid }) {
            collections.remove(at: existingSectionIndex)
            if !collection.videos.isEmpty {
                collections.insert(collection, at: existingSectionIndex)
            }
        } else if !collection.videos.isEmpty {
            collections.append(collection)
        } else {
            hasUpdates = false
        }
        
        if hasUpdates {
            self.collections = collections
        }
    }
}
