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
        static let maxListHeight: CGFloat = 400
        static let sectionHeaderHeight: CGFloat = 20
        static let cellHeight: CGFloat = 30

        static let zeroCaseViewVerticalMargin: CGFloat = 20
    }
    
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var zeroCaseView: NSView!
    @IBOutlet weak var zeroCaseLabel: NSTextField!
    @IBOutlet weak var reloadButton: NSButton!
    
    var viewModel: VideoItemsListViewModelProtocol? {
        didSet {
            self.applyViewModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.clear.cgColor
        
        self.scrollView.backgroundColor = .clear
        self.collectionView.backgroundColors = [.clear]
        
        VideoItemView.registerCell(in: self.collectionView)
        VideoItemsListSectionHeaderView.registerSupplementaryView(in: self.collectionView)
        self.updateData()
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        self.viewModel?.reset()
    }
    
    private func applyViewModel() {
        guard let viewModel = self.viewModel else {
            self.updateData()
            return
        }
        self.zeroCaseLabel.stringValue = viewModel.zeroCaseViewModel.text
        self.reloadButton.title = viewModel.zeroCaseViewModel.buttonTitle
        self.reloadButton.image = viewModel.zeroCaseViewModel.buttonImage
        self.reloadButton.imagePosition = .imageLeading
        
        viewModel.onUpdate = { [weak self] in
            self?.updateData()
        }
        self.updateData()
    }
    
    private func updateData() {
        if let viewModel = self.viewModel, viewModel.numberOfSections != 0 {
            let totalHeight: CGFloat = {
                var sum: CGFloat = 0
                for i in 0..<viewModel.numberOfSections {
                    sum += Constants.sectionHeaderHeight
                    sum += Constants.cellHeight * CGFloat(viewModel.numberOfItems(inSection: i))
                }
                return sum
            }()
            let height = max(Constants.cellHeight, min(totalHeight, Constants.maxListHeight))
            let size = NSSize(width: Constants.listWidth,
                              height: height)
            if size != self.preferredContentSize, self.isViewLoaded {
                self.preferredContentSize = size
            }
            self.zeroCaseView.isHidden = true
            self.collectionView.isHidden = false
        } else {
            let height = self.zeroCaseView.bounds.size.height + Constants.zeroCaseViewVerticalMargin * 2
            let size = NSSize(width: Constants.listWidth,
                              height: height)
            if size != self.preferredContentSize, self.isViewLoaded {
                self.preferredContentSize = size
            }
            self.zeroCaseView.isHidden = false
            self.collectionView.isHidden = true
        }
        self.collectionView.reloadData()
    }
    
    // MARK: - NSCollectionViewDataSource
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        guard let viewModel = self.viewModel else {
            return 0
        }
        return viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = self.viewModel else {
            return 0
        }
        return viewModel.numberOfItems(inSection: section)
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let cell = VideoItemView.dequeueCell(in: collectionView, at: indexPath) else {
            return NSCollectionViewItem()
        }
        cell.viewModel = self.viewModel?.itemViewModel(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        guard kind == .sectionHeader,
            let view = VideoItemsListSectionHeaderView.dequeueSupplementaryView(in: collectionView, at: indexPath) else {
            return NSView()
        }
        view.viewModel = self.viewModel?.sectionViewModel(inSection: indexPath.section)
        return view
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
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        let size = NSSize(width: collectionView.bounds.size.width, height: Constants.sectionHeaderHeight)
        return size
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, insetForSectionAt section: Int) -> NSEdgeInsets {
        return NSEdgeInsetsZero
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - Actions
    
    @IBAction func reloadButtonPressed(_ sender: Any) {
        self.viewModel?.zeroCaseViewModel.buttonPressed()
    }
}

extension SafariExtensionViewController {
    static let shared = SafariExtensionViewController(nibName: NSNib.Name(rawValue: "SafariExtensionViewController"), bundle: nil)
}
