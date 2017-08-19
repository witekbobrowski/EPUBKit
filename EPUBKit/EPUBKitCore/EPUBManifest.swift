//
//  EPUBManifest.swift
//  EPUBKit
//
//  Created by Witek on 10/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

struct EPUBManifest {
    var id: String?
    var children: [String:EPUBManifestItem]
    
    init(id: String?, children: [String:EPUBManifestItem]) {
        self.id = id
        self.children = children
    }
    
    init(children: [String:EPUBManifestItem]) {
        self.init(id: nil, children: children)
    }
    
    func getItemPath(for id: String) throws -> String {
        if let item = children[id] {
            return item.path
        } else {
            throw EPUBParserError.noPathForItem(id)
        }
    }
}

public struct EPUBManifestItem {
    var id: String
    var path: String
    var mediaType: EPUBMediaTypes
    var property: String?
    
    init(id: String, path: String, mediaType: String, property: String?) {
        self.id = id
        self.path = path
        self.mediaType = EPUBMediaTypes(rawValue: mediaType) ?? EPUBMediaTypes.unknown
        self.property = property
    }
}

extension EPUBManifestItem: Hashable {
    public var hashValue: Int { return self.id.hashValue }
    
    static public func == (left: EPUBManifestItem, right: EPUBManifestItem) -> Bool {
        return left.id == right.id
    }
}

enum EPUBMediaTypes: String {
    case GIF = "image/gif"
    case JPEG = "image/jpeg"
    case PNG = "image/png"
    case SVG = "image/svg+xml"
    case XHTML = "application/xhtml+xml"
    case RFC4329 = "application/javascript"
    case OPF2 = "application/x-dtbncx+xml"
    case OpenType = "application/font-sfnt"
    case WOFF = "application/font-woff"
    case MediaOverlays = "application/smil+xml"
    case PLS = "application/pls+xml"
    case MP3 = "audio/mpeg"
    case MP4 = "audio/mp4"
    case CSS = "text/css"
    case WOFF2 = "font/woff2"
    case unknown
    
}
