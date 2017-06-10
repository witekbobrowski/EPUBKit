//
//  EPUBDocumnet.swift
//  Reader
//
//  Created by Witek on 09/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

public class EPUBDocument {
    
    var metadata: EPUBMetadata
    var contents: EPUBContents
    var tableOfContents: EPUBTableOfContents
    
    init (metadata: EPUBMetadata, contents: EPUBContents, toc: EPUBTableOfContents) {
        self.metadata = metadata
        self.contents = contents
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
