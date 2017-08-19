//
//  EPUBSpine.swift
//  EPUBKit
//
//  Created by Witek on 11/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

class EPUBSpine {
    var id: String?
    var toc: String?
    var pageProgressionDirection: EKPageProgressionDirection
    var children: [EPUBSpineItem]
    
    init(id: String?, toc: String?, pageProgressionDirection: EKPageProgressionDirection, children: [EPUBSpineItem]) {
        self.id = id
        self.toc = toc
        self.pageProgressionDirection = pageProgressionDirection
        self.children = children
    }
    
    convenience init(id: String?, toc: String?, children: [EPUBSpineItem]) {
        self.init(id: id, toc: toc, pageProgressionDirection: .leftToRight, children: children)
    }
    
    public func getTableOfContentsId() throws -> String {
        if let tableOfContents = toc {
            return tableOfContents
        } else {
            throw EPUBParserError.noIdForTableOfContents
        }
    }
}

struct EPUBSpineItem {
    var id: String?
    var idref: String
    var linear: Bool
    
    init(id: String?, idref: String, linear: Bool) {
        self.id = id
        self.idref = idref
        self.linear = linear
    }
    
    init(id: String?, idref: String) {
        self.init(id: id, idref: idref, linear: true)
    }
}

enum EKPageProgressionDirection {
    case leftToRight
    case rightToLeft
}
