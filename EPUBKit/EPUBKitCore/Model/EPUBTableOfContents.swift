//
//  EPUBTableOfContents.swift
//  EPUBKit
//
//  Created by Witek on 09/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

public struct EPUBTableOfContents {
    public var label: String
    public var id: String
    public var item: String?
    public var subTable: [EPUBTableOfContents]?
}
