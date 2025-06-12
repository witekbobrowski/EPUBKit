//
//  EPUBSpineItem.swift
//  EPUBKit
//
//  Created by Witek Bobrowski on 26/05/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation

/// Represents a single itemref element within the EPUB spine.
///
/// Each spine item references a content document from the manifest
/// and defines whether it's part of the linear reading order.
///
/// Example itemref in OPF:
/// ```xml
/// <itemref idref="chapter1" linear="yes"/>
/// ```
///
/// Reference: EPUB 3.3 Package Document § 5.4.2 The itemref Element
/// (https://www.w3.org/TR/epub-33/#sec-itemref-elem)
public struct EPUBSpineItem {
    /// The optional ID attribute of the itemref element.
    /// Used for internal referencing within the package document.
    public var id: String?
    
    /// Reference to a manifest item ID.
    /// 
    /// This REQUIRED attribute identifies which content document
    /// from the manifest should be presented at this point in
    /// the reading order.
    public var idref: String
    
    /// Indicates if this item is part of the primary reading order.
    /// 
    /// - true: Part of the main reading flow (default)
    /// - false: Auxiliary content (e.g., notes, advertisements)
    /// 
    /// Non-linear items may be skipped by Reading Systems in
    /// simplified navigation modes.
    public var linear: Bool
}
