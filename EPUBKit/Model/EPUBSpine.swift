//
//  EPUBSpine.swift
//  EPUBKit
//
//  Created by Witek on 11/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

public struct EPUBSpine {
    public var id: String?
    public var toc: String?
    public var pageProgressionDirection: EPUBPageProgressionDirection?
    public var items: [EPUBSpineItem]
}

public enum EPUBPageProgressionDirection: String {
    case leftToRight = "ltr"
    case rightToLeft = "rtl"
}
