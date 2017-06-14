//
//  EPUBItem.swift
//  EPUBKit
//
//  Created by Witek on 10/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

public class EPUBManifest {
    
    var id: String?
    var children: [String:EPUBManifestItem]
    
    init(id: String?, children: [String:EPUBManifestItem]) {
        self.id = id
        self.children = children
    }
    
    convenience init(children: [String:EPUBManifestItem]) {
        self.init(id: nil, children: children)
    }
    
    func getTOCPath(id: String) throws -> String {
        if let toc = children[id] {
            return toc.path
        } else {
            throw EPUBParserError.noPathForTableOfContents
        }
    }
    
}

public class EPUBManifestItem: Hashable {
    
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
    
    static public func == (left: EPUBManifestItem, right: EPUBManifestItem) -> Bool {
        return left.id == right.id
    }
    
    public var hashValue: Int { return self.id.hashValue }

}

public enum EPUBMediaTypes: String {
    
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
