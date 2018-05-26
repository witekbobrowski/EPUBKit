//
//  EPUBParsable.swift
//  EPUBKit
//
//  Created by Witek on 19/08/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation
import AEXML

protocol EPUBParsable {
    func unzip(archiveAt path: URL) throws -> URL
    func getContentPath(from bookDirectory: URL) throws -> URL
    func getMetadata(from xmlElement: AEXMLElement) -> EPUBMetadata
    func getManifest(from xmlElement: AEXMLElement) -> EPUBManifest
    func getSpine(from xmlElement: AEXMLElement) -> EPUBSpine
    func getTableOfContents(from xmlElement: AEXMLElement) -> EPUBTableOfContents
}
