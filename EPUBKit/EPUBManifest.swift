//
//  EPUBItem.swift
//  EPUBKit
//
//  Created by Witek on 10/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation



public class EPUBManifest {
    
    var id: String?
    var children: [String:EPUBManifestItem]
    
    init(id: String?, children: [String:EPUBManifestItem]) {
        self.id = id
        self.children = children
    }
    
    convenience init(children: [String:EPUBManifestItem]) {
        self.init(id: nil, children: children)
    }
    
    func getTOCPath(id: String) -> String {
        return children[id]!.path
    }
    
}

public class EPUBManifestItem: Hashable {
    
    var id: String
    var path: String
    var mediaType: String
    var property: String?
    
    init(id: String, path: String, mediaType: String, property: String?) {
        self.id = id
        self.path = path
        self.mediaType = mediaType
        self.property = property
    }
    
    static public func == (left: EPUBManifestItem, right: EPUBManifestItem) -> Bool {
        return left.id == right.id
    }
    
    public var hashValue: Int { return self.id.hashValue }

}
