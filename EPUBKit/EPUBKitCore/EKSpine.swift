//
//  EKSpine.swift
//  EPUBKit
//
//  Created by Witek on 11/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

public class EKSpine {
    
    var id: String?
    var toc: String?
    var pageProgressionDirection: EKPageProgressionDirection
    var children: [EKSpineItem]
    
    init(id: String?, toc: String?, pageProgressionDirection: EKPageProgressionDirection, children: [EKSpineItem]) {
        self.id = id
        self.toc = toc
        self.pageProgressionDirection = pageProgressionDirection
        self.children = children
    }
    
    convenience init(id: String?, toc: String?, children: [EKSpineItem]) {
        self.init(id: id, toc: toc, pageProgressionDirection: .leftToRight, children: children)
    }
    
    public func getTOCid() throws -> String {
        if toc != nil {
            return toc!
        } else {
            throw EKParserError.noIdForTableOfContents
        }
    }
}

class EKSpineItem {
    
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

enum EKPageProgressionDirection {
    case leftToRight
    case rightToLeft
}
