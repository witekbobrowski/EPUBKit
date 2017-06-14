//
//  EPUBTableOfContents.swift
//  Reader
//
//  Created by Witek on 09/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

public class EPUBTableOfContents {

    var label: String   // <text>
    var id: String  //  <navPoint id=>
    var item: String?   //  <content src=>
    var subTable: [EPUBTableOfContents]?
    
    init(label: String, id: String, item: String?, subTable: [EPUBTableOfContents]?) {
        self.label = label
        self.id = id
        self.item = item
        self.subTable = subTable
    }
    
    convenience init(label: String, id: String, item: String?) {
        self.init(label: label, id: id, item: item, subTable: nil)
    }
    
}
