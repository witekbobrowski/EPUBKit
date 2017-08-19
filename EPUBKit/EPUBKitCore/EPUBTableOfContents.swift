//
//  EPUBTableOfContents.swift
//  EPUBKit
//
//  Created by Witek on 09/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

struct EPUBTableOfContents {
    var label: String
    var id: String
    var item: String?
    var page: Int?
    var subTable: [EPUBTableOfContents]?
    
    init(label: String, id: String, item: String?, subTable: [EPUBTableOfContents]?) {
        self.label = label
        self.id = id
        self.item = item
        self.subTable = subTable
        self.page = nil
    }
    
    init(label: String, id: String, item: String?) {
        self.init(label: label, id: id, item: item, subTable: nil)
    }
}
