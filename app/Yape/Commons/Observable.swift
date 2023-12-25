//
//  Observable.swift
//  Fadse
//
//  Created by Igor Savelev on 07/04/2018.
//  Copyright © 2018 Igor Savelev. All rights reserved.
//

import Foundation

final class ObserveToken<T> {
    typealias OldAndNewValueBlock = (T, T) -> Void
    typealias NewValueBlock = (T) -> Void
    
    fileprivate let observeOldAndNewBlock: OldAndNewValueBlock?
    fileprivate let observeNewBlock: NewValueBlock?
    
    init(oldAndNewValueBlock: OldAndNewValueBlock? = nil,
         newValueBlock: NewValueBlock? = nil) {
        self.observeOldAndNewBlock = oldAndNewValueBlock
        self.observeNewBlock = newValueBlock
    }
}

final class Observable<T> {
    private final class WeakHolder {
        fileprivate weak var observer: ObserveToken<T>? = nil
        
        init(_ observer: ObserveToken<T>) {
            self.observer = observer
        }
    }
    
    private var observers: [WeakHolder] = []
    
    var value: T {
        willSet {
            self.clearWeakObservers()
            self.observers.forEach { (holder) in
                guard let observer = holder.observer, let block = observer.observeOldAndNewBlock else { return }
                block(self.value, newValue)
            }
        }
        didSet {
            self.clearWeakObservers()
            self.observers.forEach { (holder) in
                guard let observer = holder.observer, let block = observer.observeNewBlock else { return }
                block(self.value)
            }
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func observeNew(_ block: @escaping ObserveToken<T>.NewValueBlock) -> ObserveToken<T> {
        let token = ObserveToken<T>(newValueBlock: block)
        self.observers.append(WeakHolder(token))
        return token
    }
    
    func observeNewAndOld(_ block: @escaping ObserveToken<T>.OldAndNewValueBlock) -> ObserveToken<T> {
        let token = ObserveToken<T>(oldAndNewValueBlock: block)
        self.observers.append(WeakHolder(token))
        return token
    }
    
    // MARK: Private
    
    private func clearWeakObservers() {
        self.observers = self.observers.filter({ (holder) -> Bool in
            return holder.observer != nil
        })
    }
}
