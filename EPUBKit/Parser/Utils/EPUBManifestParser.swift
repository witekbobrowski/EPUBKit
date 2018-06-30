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
        for item in xmlElement["item"].all! {
            let id = item.attributes["id"]!
            let path = item.attributes["href"]!
            let mediaType = item.attributes["media-type"]
            let properties = item.attributes["properties"]
            items[id] = EPUBManifestItem(id: id,
                                         path: path,
                                         mediaType: EPUBMediaType(rawValue: mediaType!) ?? .unknown,
                                         property: properties)
        }
        return EPUBManifest(id: xmlElement["id"].value, items: items)
    }

}
