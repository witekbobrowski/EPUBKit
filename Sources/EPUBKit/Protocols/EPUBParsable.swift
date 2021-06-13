//
//  EPUBParsable.swift
//  EPUBKit
//
//  Created by Witek on 19/08/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

public protocol EPUBParsable {
    associatedtype XMLElement
    func unzip(archiveAt path: URL) throws -> URL
    func getSpine(from xmlElement: XMLElement) -> EPUBSpine
    func getMetadata(from xmlElement: XMLElement) -> EPUBMetadata
    func getManifest(from xmlElement: XMLElement) -> EPUBManifest
    func getTableOfContents(from xmlElement: XMLElement) -> EPUBTableOfContents
}
