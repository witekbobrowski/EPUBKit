//
//  EPUBMetadataParser.swift
//  EPUBKit
//
//  Created by Witek Bobrowski on 30/06/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation
import AEXML

protocol EPUBMetadataParser {
    func parse(_ xmlElement: AEXMLElement) -> EPUBMetadata
}

class EPUBMetadataParserImplementation: EPUBMetadataParser {

    func parse(_ xmlElement: AEXMLElement) -> EPUBMetadata {
        var metadata = EPUBMetadata()
        metadata.contributor = Creator(name: xmlElement["dc:contributor"].value,
                                       role: xmlElement["dc:contributor"].attributes["opf:role"],
                                       fileAs: xmlElement["dc:contributor"].attributes["opf:file-as"])
        metadata.coverage = xmlElement["dc:coverage"].value
        metadata.creator = Creator(name: xmlElement["dc:creator"].value,
                                   role: xmlElement["dc:creator"].attributes["opf:role"],
                                   fileAs: xmlElement["dc:creator"].attributes["opf:file-as"])
        metadata.date = xmlElement["dc:date"].value
        metadata.description = xmlElement["dc:description"].value
        metadata.format = xmlElement["dc:format"].value
        metadata.identifier = xmlElement["dc:identifier"].value
        metadata.language = xmlElement["dc:language"].value
        metadata.publisher = xmlElement["dc:publisher"].value
        metadata.relation = xmlElement["dc:relation"].value
        metadata.rights = xmlElement["dc:rights"].value
        metadata.source = xmlElement["dc:source"].value
        metadata.subject = xmlElement["dc:subject"].value
        metadata.title = xmlElement["dc:title"].value
        metadata.type = xmlElement["dc:type"].value
        for metaItem in xmlElement["meta"].all ?? [] where metaItem.attributes["name"] == "cover" {
            metadata.coverId = metaItem.attributes["content"]
        }
        return metadata
    }

}
