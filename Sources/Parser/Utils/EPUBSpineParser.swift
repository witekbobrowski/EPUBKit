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
        let items: [EPUBSpineItem] = xmlElement["itemref"].all?
            .compactMap { item in
                if let idref = item.attributes["idref"] {
                    let id = item.attributes["id"]
                    let linear = (item.attributes["linear"] ?? "yes") == "yes"
                    return EPUBSpineItem(id: id, idref: idref, linear: linear)
                } else {
                    return nil
                }
            } ?? []
        let direction = xmlElement["page-progression-direction"].value ?? "ltr"
        return EPUBSpine(
            id: xmlElement.attributes["id"],
            toc: xmlElement.attributes["toc"],
            pageProgressionDirection: EPUBPageProgressionDirection(
                rawValue: direction
            ),
            items: items
        )
    }

}
