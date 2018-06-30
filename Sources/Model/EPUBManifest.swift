//
//  EPUBManifest.swift
//  EPUBKit
//
//  Created by Witek on 10/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

public struct EPUBManifest {
    public var id: String?
    public var items: [String: EPUBManifestItem]

    public func path(forItemWithId id: String) throws -> String {
        if let item = items[id] {
            return item.path
        } else {
            throw EPUBParserError.noPathForItem(id)
        }
    }

}
