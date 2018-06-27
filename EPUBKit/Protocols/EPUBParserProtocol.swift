//
//  EPUBParserProtocol.swift
//  EPUBKit
//
//  Created by Witek Bobrowski on 27/06/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation

public protocol EPUBParserProtocol where Self: EPUBParsable {
    var delegate: EPUBParserDelegate? { get set }
    func parse(documentAt path: URL) throws -> EPUBDocument
}
