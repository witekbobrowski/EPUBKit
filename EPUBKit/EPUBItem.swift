//
//  EPUBItem.swift
//  EPUBKit
//
//  Created by Witek on 10/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation


public class EPUBItem: Hashable {
    
    var id: String
    var path: String
    var mediaType: String
    var property: [ManifestItemProperty]?
    
    convenience init(id: String, path: String, mediaType: String) {
        self.init(id: id, path: path, mediaType: mediaType, property: nil)
    }
    
    init(id: String, path: String, mediaType: String, property: [ManifestItemProperty]?) {
        self.id = id
        self.path = path
        self.mediaType = mediaType
        self.property = property
    }
    
    static public func == (left: EPUBItem, right: EPUBItem) -> Bool {
        return left.id == right.id
    }
    
    public var hashValue: Int { return self.id.hashValue }

}

public enum ManifestItemProperty{
    case Glossary
    case Dictionary
    case SearchKeyMap
}
