//
//  VideoItemCell.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import AppKit

final class VideoItemView: NSCollectionViewItem, ReusableView {
    private struct Constants {
        static let hoverViewCornerRadius: CGFloat = 10
        static let hoverViewInset: NSEdgeInsets = NSEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
        static let titleViewSidePadding: CGFloat = 15
    }
    
    var viewModel: VideoItemViewModelProtocol? {
        didSet {
            self.applyViewModel()
        }
    }
    
    // MARK: Subviews
    
    private lazy var hoverView: NSView = {
        let view = NSView()
        view.wantsLayer = true
        if #available(OSX 10.13, *) {
            view.layer?.backgroundColor = NSColor(named: .hoverColor)?.cgColor
        } else {
            view.layer?.backgroundColor = NSColor(calibratedWhite: 0, alpha: 0.2).cgColor
        }
        view.layer?.cornerRadius = Constants.hoverViewCornerRadius
        return view
    }()
    
    private lazy var titleView: NSTextField =  {
        let textField = NSTextField(frame: .zero)
        textField.isEditable = false
        textField.isSelectable = false
        textField.font = NSFont.labelFont(ofSize: 14.0)
        textField.backgroundColor = .clear
        textField.isBordered = false
        textField.maximumNumberOfLines = 1
        return textField
    }()
    
    private lazy var trackingArea: NSTrackingArea = {
        return NSTrackingArea(rect: self.view.bounds,
                              options: [.activeInKeyWindow, .mouseEnteredAndExited, .inVisibleRect],
                              owner: self,
                              userInfo: nil)
    }()
    
    // MARK: Setup view
    
    override func loadView() {
        self.view = NSView(frame: .zero)
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.clear.cgColor
        view.addTrackingArea(self.trackingArea)
        
        self.view.addSubview(self.hoverView)
        self.hoverView.translatesAutoresizingMaskIntoConstraints = false
        self.hoverView.isHidden = true
        NSLayoutConstraint.activate([
            self.hoverView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.hoverViewInset.left),
            self.hoverView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: Constants.hoverViewInset.top),
            self.hoverView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constants.hoverViewInset.right),
            self.hoverView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -Constants.hoverViewInset.bottom)
        ])
        
        self.view.addSubview(self.titleView)
        self.titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.titleView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.titleViewSidePadding),
            self.titleView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constants.titleViewSidePadding)
        ])
    }
    
    // MARK: Setup data
    
    private func applyViewModel() {
        guard let viewModel = self.viewModel else {
            self.titleView.stringValue = ""
            return
        }
        self.titleView.stringValue = viewModel.title
    }
    
    // MARK: Mouse events
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        self.hoverView.isHidden = false
        self.viewModel?.didStartHover()
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        self.hoverView.isHidden = true
        self.viewModel?.didFinishHover()
    }
}

fileprivate extension NSColor.Name {
    static let hoverColor = NSColor.Name(rawValue: "video.items.list.hover.color")
}
