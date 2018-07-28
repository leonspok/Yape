//
//  SafariExtensionViewController.swift
//  Yape
//
//  Created by Igor Savelev on 21/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import AppKit
import SafariServices

final class SafariExtensionViewController: SFSafariExtensionViewController, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout {
    private struct Constants {
        static let listWidth: CGFloat = 250
        static let maxListHeight: CGFloat = 500
        static let cellHeight: CGFloat = 50
    }
    
    
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var collectionView: NSCollectionView!
    
    var viewModel: VideoItemsListViewModelProtocol? {
        didSet {
            self.applyViewModel()
        }
    }
    private var viewModelObserver: ObserveToken<[VideoItemsListSectionProtocol]>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.clear.cgColor
        
        self.scrollView.backgroundColor = .clear
        self.collectionView.backgroundColors = [.clear]
        
        VideoItemView.registerCell(in: self.collectionView)
        self.preferredContentSize = NSSize(width: Constants.listWidth,
                                           height: Constants.cellHeight)
    }
    
    private func applyViewModel() {
        guard let viewModel = self.viewModel else {
            self.preferredContentSize = NSSize(width: Constants.listWidth,
                                               height: Constants.cellHeight)
            return
        }
        self.viewModelObserver = viewModel.sections.observeNew({ [weak self] _ in
            self?.updateData()
        })
        self.updateData()
    }
    
    private func updateData() {
        let totalHeight: CGFloat = self.viewModel?.sections.value.reduce(0, { (sum, section) -> CGFloat in
            return sum + CGFloat(section.items.count) * Constants.cellHeight
        }) ?? 0
        let height = max(Constants.cellHeight, min(totalHeight, Constants.maxListHeight))
        self.preferredContentSize = NSSize(width: Constants.listWidth,
                                           height: height)
        self.collectionView.reloadData()
    }
    
    // MARK: - NSCollectionViewDataSource
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        guard let viewModel = self.viewModel else {
            return 0
        }
        return viewModel.sections.value.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel, section >= 0, section < viewModel.sections.value.count else {
            return 0
        }
        return viewModel.sections.value[section].items.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let cell = VideoItemView.dequeueCell(in: collectionView, at: indexPath) else {
            return NSCollectionViewItem()
        }
        cell.viewModel = self.viewModel?.itemViewModel(at: indexPath)
        return cell
    }
    
    // MARK: - NSCollectionViewDelegate
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        indexPaths.forEach({ self.viewModel?.didSelectItem(at: $0) })
        collectionView.deselectItems(at: indexPaths)
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        let size = NSSize(width: collectionView.bounds.size.width, height: Constants.cellHeight)
        return size
    }
}

extension SafariExtensionViewController {
    static let shared = SafariExtensionViewController(nibName: NSNib.Name(rawValue: "SafariExtensionViewController"), bundle: nil)
}
