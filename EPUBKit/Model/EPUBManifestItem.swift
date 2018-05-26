//
//  EPUBManifestItem.swift
//  EPUBKit
//
//  Created by Witek Bobrowski on 26/05/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation

public struct EPUBManifestItem {
    public var id: String
    public var path: String
    public var mediaType: EPUBMediaType
    public var property: String?
}
