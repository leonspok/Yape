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
        static let hoverViewCornerRadius: CGFloat = 0
        static let hoverViewInsets: NSEdgeInsets = NSEdgeInsetsZero
        static let stackViewInsets: NSEdgeInsets = NSEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        static let stackViewSpacing: CGFloat = 5
        static let separatorHeight: CGFloat = 1
        static let separatorInset: NSEdgeInsets = NSEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    var viewModel: VideoItemViewModelProtocol? {
        didSet {
            self.applyViewModel()
        }
    }
    
    // MARK: Subviews
    
    private lazy var stackView: NSStackView = {
        let stackView = NSStackView(frame: .zero)
        stackView.alignment = .centerY
        stackView.distribution = .fill
        stackView.orientation = .horizontal
        stackView.spacing = Constants.stackViewSpacing
        stackView.edgeInsets = Constants.stackViewInsets
        return stackView
    }()
    
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
    
    private lazy var iconImageView: NSImageView = {
        let view = NSImageView()
        view.imageFrameStyle = .none
        return view
    }()
    
    private lazy var titleView: NSTextField =  {
        let textField = NSTextField(frame: .zero)
        textField.isEditable = false
        textField.isSelectable = false
        textField.font = NSFont.labelFont(ofSize: 14.0)
        textField.textColor = .labelColor
        textField.backgroundColor = .clear
        textField.isBordered = false
        textField.maximumNumberOfLines = 1
        textField.lineBreakMode = .byTruncatingTail
        return textField
    }()
    
    private lazy var durationLabel: NSTextField = {
        let textField = NSTextField(frame: .zero)
        textField.isEditable = false
        textField.isSelectable = false
        textField.font = NSFont.labelFont(ofSize: 12.0)
        textField.textColor = .secondaryLabelColor
        textField.backgroundColor = .clear
        textField.isBordered = false
        textField.maximumNumberOfLines = 1
        textField.lineBreakMode = .byTruncatingTail
        return textField
    }()
    
    private lazy var copyURLButton: NSButton = {
        let button = NSButton(image: NSImage(systemSymbolName: "link.circle.fill", accessibilityDescription: nil)!, target: self, action: #selector(copyURLButtonPressed(_:)))
        button.isBordered = false
        return button
    }()
    
    private lazy var fullscreenButton: NSButton = {
        let button = NSButton(image: NSImage(systemSymbolName: "arrow.up.left.and.arrow.down.right.circle.fill", accessibilityDescription: nil)!, target: self, action: #selector(fullscreenButtonPressed(_:)))
        button.isBordered = false
        return button
    }()
    
    private lazy var revealButton: NSButton = {
        let button = NSButton(image: NSImage(systemSymbolName: "magnifyingglass.circle.fill", accessibilityDescription: nil)!, target: self, action: #selector(revealButtonPressed(_:)))
        button.isBordered = false
        return button
    }()
    
    private lazy var separatorView: NSView = {
        let view = NSView(frame: .zero)
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
        return view
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
            self.hoverView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.hoverViewInsets.left),
            self.hoverView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: Constants.hoverViewInsets.top),
            self.hoverView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constants.hoverViewInsets.right),
            self.hoverView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -Constants.hoverViewInsets.bottom)
        ])
        
        self.view.addSubview(self.stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.iconImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.stackView.addArrangedSubview(self.iconImageView)
        
        self.titleView.translatesAutoresizingMaskIntoConstraints = false
        self.titleView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.stackView.addArrangedSubview(self.titleView)
        
        self.durationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.durationLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.stackView.addArrangedSubview(self.durationLabel)
        
        self.copyURLButton.translatesAutoresizingMaskIntoConstraints = false
        self.copyURLButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.stackView.addArrangedSubview(self.copyURLButton)
        
        self.fullscreenButton.translatesAutoresizingMaskIntoConstraints = false
        self.fullscreenButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.stackView.addArrangedSubview(self.fullscreenButton)
        
        self.revealButton.translatesAutoresizingMaskIntoConstraints = false
        self.revealButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.stackView.addArrangedSubview(self.revealButton)
        
        self.view.addSubview(self.separatorView)
        self.separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.separatorView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.separatorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.separatorInset.left),
            self.separatorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constants.separatorInset.right),
            self.separatorView.heightAnchor.constraint(equalToConstant: Constants.separatorHeight)
        ])
    }
    
    // MARK: Setup data
    
    private func applyViewModel() {
        guard let viewModel = self.viewModel else {
            self.iconImageView.image = nil
            self.titleView.stringValue = ""
            self.durationLabel.stringValue = ""
            return
        }
        
        if viewModel.isPlaying {
            self.iconImageView.setSymbolImage(NSImage(systemSymbolName: "pause.rectangle.fill", accessibilityDescription: nil)!, contentTransition: .automatic)
            self.iconImageView.addSymbolEffect(.pulse, options: .repeating)
        } else {
            self.iconImageView.setSymbolImage(NSImage(systemSymbolName: "play.rectangle.fill", accessibilityDescription: nil)!, contentTransition: .automatic)
            self.iconImageView.removeAllSymbolEffects()
        }
        
        self.titleView.stringValue = viewModel.title
        self.separatorView.isHidden = viewModel.isLastInSection
        
        if let duration = viewModel.duration {
            self.durationLabel.stringValue = duration
            self.durationLabel.isHidden = false
        } else {
            self.durationLabel.stringValue = ""
            self.durationLabel.isHidden = true
        }
        
        self.copyURLButton.isHidden = !(self.viewModel?.hasURL == true)
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
    
    // MARK: Actions
    
    @objc
    private func revealButtonPressed(_ sender: NSButton) {
        self.viewModel?.didPressReveal()
    }
    
    @objc
    private func fullscreenButtonPressed(_ sender: NSButton) {
        self.viewModel?.didPressFullscreen()
    }
    
    @objc
    private func copyURLButtonPressed(_ sender: NSButton) {
        self.viewModel?.didPressCopyURL()
    }
}

fileprivate extension NSColor.Name {
    static let hoverColor = "video.items.list.hover.color"
}
