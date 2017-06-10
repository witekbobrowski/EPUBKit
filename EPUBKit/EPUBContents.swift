//
//  EPUBContents.swift
//  EPUBKit
//
//  Created by Witek on 10/06/2017.
//  Copyright © 2017 Witek Bobrowski. All rights reserved.
//

import Foundation

public class EPUBContents {
    
    var manifest: Set<EPUBItem>
    var spine: [String]
    
    init(manifest: Set<EPUBItem>, spine: [String]) {
        self.manifest = manifest
        self.spine = spine
    }
    
}
