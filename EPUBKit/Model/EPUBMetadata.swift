//
//  EPUBMetadata.swift
//  EPUBKit
//
//  Created by Witek on 09/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

public struct EPUBMetadata {
    
    public struct Creator {
        public var name: String?
        public var role: String?
        public var fileAs: String?
    }
    
    public var contributor: Creator?
    public var coverage: String?
    public var creator: Creator?
    public var date: String?
    public var description: String?
    public var format: String?
    public var identifier: String?
    public var language: String?
    public var publisher: String?
    public var relation: String?
    public var rights: String?
    public var source: String?
    public var subject: String?
    public var title: String?
    public var type: String?
    public var coverId: String?
}

