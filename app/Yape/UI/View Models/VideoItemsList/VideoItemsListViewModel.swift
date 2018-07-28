//
//  VideoItemsListViewModel.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

protocol VideoItemsListViewModelProtocol {
    var sections: Observable<[VideoItemsListSectionProtocol]> { get }
    func itemViewModel(at indexPath: IndexPath) -> VideoItemViewModelProtocol?
    func reload()
    
    var numberOfSections: Int { get }
    func numberOfItems(inSection section: Int) -> Int
    func didSelectItem(at indexPath: IndexPath)
}

final class VideoItemsListViewModel: VideoItemsListViewModelProtocol {
    typealias Dependencies =
        VideoItemViewModel.Dependencies &
        APIServiceProvider
    
    private let dependencies: Dependencies
    
    let sections: Observable<[VideoItemsListSectionProtocol]> = Observable<[VideoItemsListSectionProtocol]>([])
    
    init(dependencies: Dependencies = ServicesContainer.shared) {
        self.dependencies = dependencies
    }
    
    func itemViewModel(at indexPath: IndexPath) -> VideoItemViewModelProtocol? {
        guard indexPath.section >= 0, indexPath.section < self.sections.value.count else { return nil }
        guard indexPath.item >= 0, indexPath.item < self.sections.value[indexPath.section].items.count else { return nil }
        return self.sections.value[indexPath.section].items[indexPath.item]
    }
    
    func reload() {
        let endpoint = GetVideosEndpoint()
        self.dependencies.apiService.sendRequest(toEndpoint: endpoint) { [weak self] (result) in
            guard let sSelf = self else { return }
            switch result {
            case .success(let items):
                sSelf.sections.value = sSelf.makeSections(from: items)
            case .failure(let error):
                NSLog("\(error)")
            }
        }
    }
    
    private func makeSections(from items: [VideoItem]) -> [VideoItemsListSectionProtocol] {
        var sections: [VideoItemsListSectionProtocol] = []
        let nowPlayingItems = items.filter({ $0.isPlaying })
        if !nowPlayingItems.isEmpty {
            let section = VideoItemsListSection(title: NSLocalizedString("video.items.list.section.nowplaying.title", comment: "Now playing"),
                                                items: nowPlayingItems.map({
                                                    VideoItemViewModel(videoItem: $0, dependencies: self.dependencies)
                                                }))
            sections.append(section)
        }
        
        let section = VideoItemsListSection(title: NSLocalizedString("video.items.list.section.all.title", comment: "All"),
                                            items: items.map({
                                                VideoItemViewModel(videoItem: $0, dependencies: self.dependencies)
                                            }))
        sections.append(section)
        return sections
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
