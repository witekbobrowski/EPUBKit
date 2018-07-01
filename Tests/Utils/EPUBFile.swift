//
//  EPUBFile.swift
//  EPUBKit-iOS
//
//  Created by Witek Bobrowski on 01/07/2018.
//  Copyright © 2018 Witek Bobrowski. All rights reserved.
//

import Foundation

enum EPUBFile {
    // valid
    case alicesAdventuresinWonderland
    case theGeographyofBliss
    case theMetamorphosis
    case theProblemsofPhilosophy
    // broken
    case alicesAdventuresinWonderlandBrokenArchive
    case theGeographyofBlissBrokenContainer
    case theMetamorphosisBrokenToc
    case theProblemsofPhilosophyBrokenContent

    var fileName: String {
        switch self {
        case .alicesAdventuresinWonderland: return "Alices_Adventures_in_Wonderland"
        case .theGeographyofBliss: return "Geography_of_Bliss"
        case .theMetamorphosis: return "The_Metamorphosis"
        case .theProblemsofPhilosophy: return "The_Problems_of_Philosophy"
        case .alicesAdventuresinWonderlandBrokenArchive: return "broken_archive_alice"
        case .theGeographyofBlissBrokenContainer: return "broken_container_bliss"
        case .theMetamorphosisBrokenToc: return "broken_toc_metamorphosis"
        case .theProblemsofPhilosophyBrokenContent: return "broken_content_philosophy"
        }
    }

    var isBroken: Bool {
        switch self {
        case .alicesAdventuresinWonderland,
             .theGeographyofBliss,
             .theMetamorphosis,
             .theProblemsofPhilosophy:
            return false
        case .alicesAdventuresinWonderlandBrokenArchive,
             .theGeographyofBlissBrokenContainer,
             .theMetamorphosisBrokenToc,
             .theProblemsofPhilosophyBrokenContent:
            return true
        }
    }

    var fileExtension: String {
        switch self {
        default: return "epub"
        }
    }

    var fullName: String {
        return fileName + "." + fileExtension
    }
}
