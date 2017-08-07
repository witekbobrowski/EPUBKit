//
//  EPUBSpine.swift
//  EPUBKit
//
//  Created by Witek on 11/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

public class EPUBSpine {
    
    var id: String?
    var toc: String?
    var pageProgressionDirection: EPUBPageProgressionDirection
    var children: [EPUBSpineItem]
    
    init(id: String?, toc: String?, pageProgressionDirection: EPUBPageProgressionDirection, children: [EPUBSpineItem]) {
        self.id = id
        self.toc = toc
        self.pageProgressionDirection = pageProgressionDirection
        self.children = children
    }
    
    convenience init(id: String?, toc: String?, children: [EPUBSpineItem]) {
        self.init(id: id, toc: toc, pageProgressionDirection: .leftToRight, children: children)
    }
    
    public func getTOCid() throws -> String {
        if toc != nil {
            return toc!
        } else {
            throw EPUBParserError.noIdForTableOfContents
        }
    }
}

class EPUBSpineItem {
    
    var id: String?
    var idref: String
    var linear: Bool
    
    init(id: String?, idref: String, linear: Bool) {
        self.id = id
        self.idref = idref
        self.linear = linear
    }
    
    convenience init(id: String?, idref: String) {
        self.init(id: id, idref: idref, linear: true)
    }
    
}

enum EPUBPageProgressionDirection {
    case leftToRight
    case rightToLeft
}
