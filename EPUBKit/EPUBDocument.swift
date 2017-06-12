//
//  EPUBDocumnet.swift
//  Reader
//
//  Created by Witek on 09/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

public protocol Parsable {
    
    init?(fileName: String)
    
}

public class EPUBDocument: Parsable {
    
    var directory: URL
    var metadata: EPUBMetadata
    var manifest: EPUBManifest
    var spine: EPUBSpine
    var tableOfContents: EPUBTableOfContents
    
    init (directory: URL, metadata: EPUBMetadata, manifest: EPUBManifest, spine: EPUBSpine, toc: EPUBTableOfContents) {
        self.directory = directory
        self.metadata = metadata
        self.manifest = manifest
        self.spine = spine
        self.tableOfContents = toc
    }
    
    public required init?(fileName: String) {
        do {
            let book = try EPUBParser.parse(fileName)
            self.directory = book.directory
            self.metadata = book.metadata
            self.manifest = book.manifest
            self.spine = book.spine
            self.tableOfContents = book.tableOfContents
        } catch {
            return nil
        }
    }
    
    public var title: String {
        return metadata.title ?? "Untitled"
    }
    
    public var author: String {
        return metadata.creator?.name ?? "Author unknown"
    }
    
    public var publisher: String {
        return metadata.publisher ?? "Publisher unknown"
    }
    
}
