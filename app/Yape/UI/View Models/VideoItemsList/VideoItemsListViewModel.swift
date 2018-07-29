//
//  VideoItemsListViewModel.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

protocol VideoItemsListViewModelProtocol {
    var zeroCaseViewModel: VideoItemsListZeroCaseViewModelProtocol { get }
    
    var sections: Observable<[VideoItemsListSectionProtocol]> { get }
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

    private(set) lazy var zeroCaseViewModel: VideoItemsListZeroCaseViewModelProtocol = {
        return VideoItemsListZeroCaseViewModel(onButtonPressed: { [weak self] in
            self?.reload()
        })
    }()
    let sections: Observable<[VideoItemsListSectionProtocol]> = Observable<[VideoItemsListSectionProtocol]>([])
    
    init(dependencies: Dependencies = ServicesContainer.shared) {
        self.dependencies = dependencies
        self.messagesObserver = self.dependencies.extensionMessagesReceiver.subscribe(to: VideosListMessage.self, onMessageReceived: { [weak self] (message) in
            self?.handle(message: message)
        })
    }
    
    func itemViewModel(at indexPath: IndexPath) -> VideoItemViewModelProtocol? {
        guard indexPath.section >= 0, indexPath.section < self.sections.value.count else { return nil }
        guard indexPath.item >= 0, indexPath.item < self.sections.value[indexPath.section].items.count else { return nil }
        return self.sections.value[indexPath.section].items[indexPath.item]
    }
    
    func reload() {
        let command: ExtensionCommand = .exportVideos
        self.dependencies.commandsDispatcher.send(command: command)
    }
    
    func reset() {
        for section in self.sections.value {
            for item in section.items {
                item.didFinishHover()
            }
        }
    }
    
    private func handle(message: VideosListMessage) {
        let sectionTitle: String = {
            if let host = URL(string: message.documentInfo.location)?.host {
                if let title = message.documentInfo.title, title.count > 0 {
                    return "[\(host)] " + title
                }
                return "[\(host)]"
            } else {
                let location = message.documentInfo.location
                let truncated = location.prefix(min(location.count, 30))
                return "[\(truncated)]"
            }
        }()
        
        var sections = self.sections.value
        let section = VideoItemsListSection(title: sectionTitle,
                                            items: message.messageInfo.items.map({
                                                VideoItemViewModel(videoItem: $0, dependencies: self.dependencies)
                                            }))
        guard !section.items.isEmpty else { return }
        
        if let existingSectionIndex = sections.index(where: { $0.title == sectionTitle }) {
            sections.remove(at: existingSectionIndex)
            sections.insert(section, at: existingSectionIndex)
        } else {
            sections.append(section)
        }
        self.sections.value = sections
    }
    
    var numberOfSections: Int {
        return self.sections.value.count
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        guard section >= 0, section < self.sections.value.count else { return 0 }
        return self.sections.value[section].items.count
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        guard let viewModel = self.itemViewModel(at: indexPath) else { return }
        viewModel.didSelect()
    }
}
