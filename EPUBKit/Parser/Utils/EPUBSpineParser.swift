//
//  EPUBSpineParser.swift
//  EPUBKit
//
//  Created by Witek Bobrowski on 30/06/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation
import AEXML

protocol EPUBSpineParser {
    func parse(_ xmlElement: AEXMLElement) -> EPUBSpine
}

class EPUBSpineParserImplementation: EPUBSpineParser {

    func parse(_ xmlElement: AEXMLElement) -> EPUBSpine {
        var items: [EPUBSpineItem] = []
        for item in xmlElement["itemref"].all! {
            let id = item.attributes["id"]
            let idref = item.attributes["idref"]!
            let linear = (item.attributes["linear"] ?? "yes") == "yes" ? true : false
            items.append(EPUBSpineItem(id: id, idref: idref, linear: linear))
        }
        let pageProgressionDirection = xmlElement["page-progression-direction"].value ?? "ltr"
        return EPUBSpine(id: xmlElement.attributes["id"],
                         toc: xmlElement.attributes["toc"],
                         pageProgressionDirection: EPUBPageProgressionDirection(
                            rawValue: pageProgressionDirection),
                         items: items)
    }

}
