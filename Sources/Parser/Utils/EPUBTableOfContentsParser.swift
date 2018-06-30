//
//  EPUBTableOfContentsParser.swift
//  EPUBKit
//
//  Created by Witek Bobrowski on 30/06/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation
import AEXML

protocol EPUBTableOfContentsParser {
    func parse(_ xmlElement: AEXMLElement) -> EPUBTableOfContents
}

class EPUBTableOfContentsParserImplementation: EPUBTableOfContentsParser {

    func parse(_ xmlElement: AEXMLElement) -> EPUBTableOfContents {
        let item = xmlElement["head"]["meta"].all(
            withAttributes: ["name": "dtb=uid"])?.first?.attributes["content"]
        var tableOfContents = EPUBTableOfContents(label: xmlElement["docTitle"]["text"].value!,
                                                  id: "0",
                                                  item: item, subTable: [])
        tableOfContents.subTable = evaluateChildren(from: xmlElement["navMap"])
        return tableOfContents
    }

}

extension EPUBTableOfContentsParserImplementation {

    private func evaluateChildren(from xmlElement: AEXMLElement) -> [EPUBTableOfContents] {
        if xmlElement["navPoint"].all != nil {
            var subs: [EPUBTableOfContents] = []
            for point in xmlElement["navPoint"].all! {
                subs.append(EPUBTableOfContents(label: point["navLabel"]["text"].value!,
                                                id: point.attributes["id"]!,
                                                item: point["content"].attributes["src"]!,
                                                subTable: evaluateChildren(from: point)))
            }
            return subs
        } else {
            return []
        }
    }

}
