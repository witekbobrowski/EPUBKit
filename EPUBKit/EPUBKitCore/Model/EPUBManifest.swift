//
//  EPUBManifest.swift
//  EPUBKit
//
//  Created by Witek on 10/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

public struct EPUBManifest {
    public struct Item {
        public var id: String
        public var path: String
        public var mediaType: EPUBMediaType
        public var property: String?
    }
    
    public var id: String?
    public var items: [String:Item]
    
    public func path(forItemWithId id: String) throws -> String {
        if let item = items[id] {
            return item.path
        } else {
            throw EPUBParserError.noPathForItem(id)
        }
    }
}

public enum EPUBMediaType: String {
    case gif = "image/gif"
    case jpeg = "image/jpeg"
    case png = "image/png"
    case svg = "image/svg+xml"
    case xHTML = "application/xhtml+xml"
    case rfc4329 = "application/javascript"
    case opf2 = "application/x-dtbncx+xml"
    case openType = "application/font-sfnt"
    case woff = "application/font-woff"
    case mediaOverlays = "application/smil+xml"
    case pls = "application/pls+xml"
    case mp3 = "audio/mpeg"
    case mp4 = "audio/mp4"
    case css = "text/css"
    case woff2 = "font/woff2"
    case unknown
}
