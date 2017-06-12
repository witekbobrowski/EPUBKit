//
//  EPUBDocumnet.swift
//  Reader
//
//  Created by Witek on 09/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

public class EPUBDocument {
    
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
