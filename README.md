# EPUBKit

<p align="center">
    <img src="EPUBKit.png" alt="EPUBKit Logo" width="256">
</p>

<p align="center">
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" alt="Swift Package Manager">
    </a>
    <a href="https://swift.org">
        <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fwitekbobrowski%2FEPUBKit%2Fbadge%3Ftype%3Dswift-versions" alt="Swift Version">
    </a>
    <a href="https://swiftpackageindex.com/witekbobrowski/EPUBKit">
        <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fwitekbobrowski%2FEPUBKit%2Fbadge%3Ftype%3Dplatforms" alt="Platforms">
    </a>
    <a href="https://github.com/witekbobrowski/EPUBKit/blob/main/LICENSE">
        <img src="https://img.shields.io/github/license/witekbobrowski/EPUBKit" alt="License">
    </a>
</p>

<p align="center">
    <strong>A powerful and modern Swift library for parsing EPUB documents</strong>
</p>

EPUBKit provides a comprehensive solution for parsing and extracting information from EPUB files in Swift. Built with modern Swift practices and designed for reliability, it supports both EPUB 2 and EPUB 3 specifications while maintaining a clean, intuitive API.

## Features

- 📚 **Complete EPUB Support**: Full parsing of EPUB 2 and EPUB 3 documents
- 🏗️ **Modern Swift**: Built with Swift 6+, leveraging modern language features
- 📋 **Rich Metadata**: Extract comprehensive Dublin Core metadata
- 🗂️ **Manifest Parsing**: Access all publication resources with media type detection  
- 📖 **Reading Order**: Parse spine for linear reading progression
- 🧭 **Navigation**: Extract table of contents and navigation structure
- 🧪 **Thoroughly Tested**: Comprehensive test suite built with Swift Testing
- 🎯 **Thread Safe**: Designed for concurrent parsing operations

## Installation

### Swift Package Manager

Add EPUBKit to your project via Xcode or by adding it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/witekbobrowski/EPUBKit.git", from: "1.0.0")
]
```

### CocoaPods

```ruby
pod 'EPUBKit'
```

## Quick Start

### Basic Usage

```swift
import EPUBKit

// Parse an EPUB file
guard let epubURL = Bundle.main.url(forResource: "book", withExtension: "epub"),
      let document = EPUBDocument(url: epubURL) else {
    print("Failed to load EPUB")
    return
}

// Access document metadata
print("Title: \(document.title)")
print("Author: \(document.author)")
print("Publisher: \(document.publisher)")
print("Language: \(document.language)")

// Access document structure
print("Chapters: \(document.spine.items.count)")
print("Resources: \(document.manifest.items.count)")
```

### Working with Document Components

```swift
// Access metadata details
if let creator = document.metadata.creator {
    print("Author: \(creator.name)")
    print("Role: \(creator.role)")
    print("File as: \(creator.fileAs)")
}

// Iterate through spine items (reading order)
for spineItem in document.spine.items {
    if let manifestItem = document.manifest.items[spineItem.idref] {
        print("Chapter: \(manifestItem.path)")
        print("Media Type: \(manifestItem.mediaType)")
    }
}

// Access table of contents
func printTOC(_ toc: EPUBTableOfContents, level: Int = 0) {
    let indent = String(repeating: "  ", count: level)
    print("\(indent)- \(toc.label)")
    
    for child in toc.children {
        printTOC(child, level: level + 1)
    }
}

printTOC(document.tableOfContents)
```

## EPUB Specification Support

EPUBKit supports the EPUB specification standards:

- ✅ **EPUB 3.3** - Full support for modern EPUB files
- ✅ **EPUB 2.0** - Backward compatibility with older EPUB files
- ✅ **Dublin Core Metadata** - Complete metadata extraction
- ✅ **OCF (Open Container Format)** - Proper ZIP archive handling
- ✅ **NCX Navigation** - Table of contents parsing
- ✅ **Media Type Detection** - Automatic resource type identification

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

EPUBKit is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
