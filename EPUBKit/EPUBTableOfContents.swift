//
//  EPUBTableOfContents.swift
//  Reader
//
//  Created by Witek on 09/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

public class EPUBTableOfContents {

    var label: String
    var id: String
    var item: EPUBItem
    var subTable: [EPUBTableOfContents]?
    
    init(label: String, id: String, item: EPUBItem, subTable: [EPUBTableOfContents]?) {
        self.label = label
        self.id = id
        self.item = item
        self.subTable = subTable
    }
    
    convenience init(label: String, id: String, item: EPUBItem) {
        self.init(label: label, id: id, item: item, subTable: nil)
    }
    
}
