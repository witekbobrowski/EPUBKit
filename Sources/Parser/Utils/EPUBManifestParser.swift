//
//  EPUBManifestParser.swift
//  EPUBKit
//
//  Created by Witek Bobrowski on 30/06/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation
import AEXML

protocol EPUBManifestParser {
    func parse(_ xmlElement: AEXMLElement) -> EPUBManifest
}

class EPUBManifestParserImplementation: EPUBManifestParser {

    func parse(_ xmlElement: AEXMLElement) -> EPUBManifest {
        var items: [String: EPUBManifestItem] = [:]
        xmlElement["item"].all?
            .compactMap { item in
                guard
                    let id = item.attributes["id"],
                    let path = item.attributes["href"]
                else { return nil }
                let mediaType = item.attributes["media-type"]
                    .map { EPUBMediaType(rawValue: $0) } ?? nil
                let properties = item.attributes["properties"]
                return EPUBManifestItem(
                    id: id, path: path, mediaType: mediaType ?? .unknown, property: properties
                )
            }
            .forEach { items[$0.id] = $0 }
        return EPUBManifest(id: xmlElement["id"].value, items: items)
    }

}
