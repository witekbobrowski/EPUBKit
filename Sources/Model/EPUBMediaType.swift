//
//  EPUBMediaType.swift
//  EPUBKit
//
//  Created by Witek Bobrowski on 26/05/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation

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
