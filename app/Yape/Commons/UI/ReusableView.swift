//
//  ReusableCell.swift
//  Yape
//
//  Created by Igor Savelev on 22/07/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import AppKit

protocol ReusableView: AnyObject {
    static var reusableIdentifier: NSUserInterfaceItemIdentifier { get }
}

extension ReusableView {
    static var reusableIdentifier: NSUserInterfaceItemIdentifier {
        return NSUserInterfaceItemIdentifier(rawValue: String(describing: self))
    }

    static func registerCell(in collectionView: NSCollectionView) {
        collectionView.register(self, forItemWithIdentifier: self.reusableIdentifier)
    }
    
    static func dequeueCell(in collectionView: NSCollectionView, at indexPath: IndexPath) -> Self? {
        return collectionView.makeItem(withIdentifier: self.reusableIdentifier, for: indexPath) as? Self
    }
}

protocol ReusableNibView: ReusableView {
    static var reusableNib: NSNib? { get }
}

extension ReusableNibView {
    static var reusableNib: NSNib? {
        return NSNib(nibNamed: String(describing: self),
                     bundle: Bundle(for: self))
    }
    
    static func registerNibCell(in collectionView: NSCollectionView) {
        guard let nib = self.reusableNib else {
            assertionFailure("No reusable nib")
            return
        }
        collectionView.register(nib, forItemWithIdentifier: self.reusableIdentifier)
    }
}

protocol ReusableSupplementaryView: ReusableView {
    static var supplementaryElementKind: NSCollectionView.SupplementaryElementKind { get }
}

extension ReusableSupplementaryView {
    static var supplementaryElementKind: NSCollectionView.SupplementaryElementKind {
        return String(describing: self)
    }
    
    static func registerSupplementaryView(in collectionView: NSCollectionView) {
        collectionView.register(self, forSupplementaryViewOfKind: self.supplementaryElementKind, withIdentifier: self.reusableIdentifier)
    }
    
    static func dequeueSupplementaryView(in collectionView: NSCollectionView, at indexPath: IndexPath) -> Self? {
        return collectionView.makeSupplementaryView(ofKind: self.supplementaryElementKind, withIdentifier: self.reusableIdentifier, for: indexPath) as? Self
    }
}
