//
//  LocalizeNIB.swift
//  LocalizeNIB
//
//  Created by Jindra Dolezy on 11/10/16.
//  Copyright © 2016 STRV. All rights reserved.
//

import UIKit


/// Used for providing localized strings. Basically maps one string to another.
public typealias LocalizedStringProvider = (String) -> String

/// Catch-all block that can localize object via provided LocalizedStringProvider and returns true if there is no need to continue with localization, false otherwise
public typealias LocalizerBlock = (AnyObject, LocalizedStringProvider) -> Bool

/// Implement this protocol to provide localization capability. Use passed in LocalizedStringProvider to get localized strings.
public protocol Localizable {
    func localize(provider: LocalizedStringProvider) throws
}


// ------------------------------------
// MARK: - LocalizeNIB class


/// Implements localization logic. Use shared instance for customizing behaviour of this class.
open class LocalizeNIB {
    open static var instance = LocalizeNIB()
    
    /// String provider used for localization. Set to nil to provide default implementation that simply calls NSLocalizedString.
    open var stringProvider: LocalizedStringProvider?
    
    /// If set this block is called before localizing each object. If it returns true the localization will not be performed on this object. Default value is nil.
    open var localizeAll: LocalizerBlock?
    
    /// If true, each object that is not implementing Localizable protocol will be reported. Default is false
    open var debugMode: Bool
    
    /// This block is called for each debug message. The default implementation simply calls print.
    open var debugBlock: ((String) -> Void) = { print($0) }
    
    fileprivate lazy var defaultStringProvider: LocalizedStringProvider = {
        return { [weak self] string in
            let result = NSLocalizedString(string, value: "!!!", comment: "") // will return !!! if string is not found in string table
            if result == "!!!" {
                if self?.debugMode == true {
                    self?.debugBlock("Missing key '\(string)'")
                }
                return string
            } else {
                return result
            }
        }
    }()
    
    
    public init(debugMode: Bool = false, stringProvider: LocalizedStringProvider? = nil) {
        self.debugMode = debugMode
        self.stringProvider = stringProvider
    }
    
    /// Localizes all provided objects. Objects not implementing Localizable protocol are logged if debugMode is enabled. Provided context will be included in debug message.
    open func localize(_ objects: [AnyObject], context: String? = nil) throws {
        let stringProvider = self.stringProvider ?? defaultStringProvider
        
        for obj in objects {
            if localizeAll?(obj, stringProvider) == true {
                continue
            }
            
            if let localizable = obj as? Localizable {
                try localizable.localize(provider: stringProvider)
            } else if debugMode {
                if let context = context {
                    debugBlock("\(context): Passed non-localizable object - \(obj)")
                } else {
                    debugBlock("Passed non-localizable object - \(obj)")
                }
            }
        }
    }
    
    /// Localizes input string with LocalizedStringProvider
    open func localize(_ string: String) -> String {
        return (stringProvider ?? defaultStringProvider)(string)
    }
}

/// Shortuct for LocalizeNIB.instance
public var localizeNIB = LocalizeNIB.instance


// ------------------------------------
// MARK: - UIKit extensions

func localizeInternal(_ items: [AnyObject], context: AnyObject) {
    do {
        try LocalizeNIB.instance.localize(items, context: "\(context)")
    } catch {
        assertionFailure("\(context): Failed to localize values \(items) with error \(error)")
    }
}


extension UIViewController {
    @IBOutlet open var localizables: [AnyObject] {
        get {
            return []
        }
        set {
            localizeInternal(newValue, context: self)
        }
    }
}

extension UITableViewCell {
    @IBOutlet open var localizables: [AnyObject] {
        get {
            return []
        }
        set {
            localizeInternal(newValue, context: self)
        }
    }
}

extension UICollectionViewCell {
    @IBOutlet open var localizables: [AnyObject] {
        get {
            return []
        }
        set {
            localizeInternal(newValue, context: self)
        }
    }
}


// ------------------------------------
// MARK: - Localizable implementations


extension UILabel: Localizable {
    open func localize(provider: LocalizedStringProvider) throws {
        text = text.flatMap { provider($0) }
    }
}

extension UITextField: Localizable {
    open func localize(provider: LocalizedStringProvider) throws {
        text = text.flatMap { provider($0) }
        placeholder = placeholder.flatMap { provider($0) }
    }
}

extension UIButton: Localizable {
    open func localize(provider: LocalizedStringProvider, state: UIControlState, normalTitle: String?) {
        if let title = title(for: state), normalTitle == nil || title != normalTitle {
            setTitle(provider(title), for: state)
        }
    }
    
    open func localize(provider: LocalizedStringProvider) throws {
        localize(provider: provider, state: .normal, normalTitle: nil)
        
        let normalTitle = title(for: .normal)
        
        localize(provider: provider, state: .disabled, normalTitle: normalTitle)
        localize(provider: provider, state: .highlighted, normalTitle: normalTitle)
        localize(provider: provider, state: .selected, normalTitle: normalTitle)
        if #available(iOS 9.0, *) {
            localize(provider: provider, state: .focused, normalTitle: normalTitle)
        }
    }
}

extension UISegmentedControl: Localizable {
    open func localize(provider: LocalizedStringProvider) throws {
        for segment in 0..<numberOfSegments {
            if let title = titleForSegment(at: segment) {
                setTitle(provider(title), forSegmentAt: segment)
            }
        }
    }
}

extension UITextView: Localizable {
    open func localize(provider: LocalizedStringProvider) throws {
        if let text = self.text {
            self.text = provider(text)
        }
    }
}

extension UIBarItem: Localizable {
    open func localize(provider: LocalizedStringProvider) throws {
        if let title = self.title {
            self.title = provider(title)
        }
    }
}

extension UINavigationItem: Localizable {
    open func localize(provider: LocalizedStringProvider) throws {
        if let title = self.title {
            self.title = provider(title)
        }
        if let prompt = self.prompt {
            self.prompt = provider(prompt)
        }
        if let backButton = self.backBarButtonItem {
            try backButton.localize(provider: provider)
        }
    }
}

extension UISearchBar: Localizable {
    open func localize(provider: LocalizedStringProvider) throws {
        if let text = self.text {
            self.text = provider(text)
        }
        if let placeholder = self.placeholder {
            self.placeholder = provider(placeholder)
        }
        if let prompt = self.prompt {
            self.prompt = provider(prompt)
        }
        if let scopeButtonTitles = self.scopeButtonTitles {
            self.scopeButtonTitles = scopeButtonTitles.map { provider($0) }
        }
    }
}

extension UIViewController: Localizable {
    open func localize(provider: LocalizedStringProvider) throws {
        if let title = self.title {
            self.title = provider(title)
        }
    }
}


// ------------------------------------
// MARK: - String extension

extension String {
    
    public var localized: String {
        return LocalizeNIB.instance.localize(self)
    }
    
}
