//
//  EPUBParsable.swift
//  EPUBKit
//
//  Created by Witek on 19/08/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

protocol EPUBParsable {
    associatedtype XMLElement
    func unzip(archiveAt path: URL) throws -> URL
    func getContentPath(from documentPath: URL) throws -> URL
    func getMetadata(from xmlElement: XMLElement) -> EPUBMetadata
    func getManifest(from xmlElement: XMLElement) -> EPUBManifest
    func getSpine(from xmlElement: XMLElement) -> EPUBSpine
    func getTableOfContents(from xmlElement: XMLElement) -> EPUBTableOfContents
}
