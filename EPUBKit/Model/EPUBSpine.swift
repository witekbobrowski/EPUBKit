//
//  EPUBSpine.swift
//  EPUBKit
//
//  Created by Witek on 11/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

public struct EPUBSpine {
    
    public struct Item {
        public var id: String?
        public var idref: String
        public var linear: Bool
    }
    
    public var id: String?
    public var toc: String?
    public var pageProgressionDirection: EPUBPageProgressionDirection?
    public var items: [Item]
    
}

public enum EPUBPageProgressionDirection: String {
    case leftToRight = "ltr"
    case rightToLeft = "rtl"
}
