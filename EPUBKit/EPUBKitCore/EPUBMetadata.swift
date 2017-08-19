//
//  EPUBMetadata.swift
//  EPUBKit
//
//  Created by Witek on 09/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

public struct EPUBMetadata {
    var contributor: Creator?
    var coverage: String?
    var creator: Creator?
    var date: String?
    var description: String?
    var format: String?
    var identifier: String?
    var language: String?
    var publisher: String?
    var relation: String?
    var rights: String?
    var source: String?
    var subject: String?
    var title: String?
    var type: String?
    var coverId: String?
}

public struct Creator {
    var name: String?
    var role: String?
    var fileAs: String?
    
    init(name: String?, role: String?, fileAs: String?) {
        self.name = name
        self.role = role
        self.fileAs = fileAs
    }
}
