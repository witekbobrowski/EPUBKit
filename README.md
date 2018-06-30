<p align=center>
<a href="">
<img height=180 alt="Logo" src="logo.png">
</a>
</p>
<p align=center>
    <a href="https://www.codacy.com/app/witekbobrowski/EPUBKit?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=witekbobrowski/EPUBKit&amp;utm_campaign=Badge_Grade"><img alt="CodacyBadge" src="https://api.codacy.com/project/badge/Grade/35b59c32fd77448da5bab9041ebba524"</a>
    <a href="https://swift.org"><img alt="Swift" src="https://img.shields.io/badge/Swift-4.1-orange.svg"></a>
    <a href="https://cocoapods.org/pods/EPUBKit"><img alt="CocoaPods" src="https://img.shields.io/badge/pod-0.2.2-blue.svg"></a>
    <a href="https://github.com/Carthage/Carthage"><img alt="Carthage" src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg"></a>
    <a><img alt="Platforms" src="https://img.shields.io/badge/platform-iOS | macOS | tvOS | watchOS-lightgray.svg"></a>
    <a href="https://twitter.com/witekbobrowski"><img alt="Contact" src="https://img.shields.io/badge/contact-@witekbobrowski-blue.svg"></a>
</p>
<p align=center>
📚 A simple swift library for parsing EPUB documents
</p>

__Note:__ This library is still in its early stages! I will experiment and change the API until I am satisfied with the result. I do not reccomend using this library in larger projects, although feedback will be highly appreciated 🙇

## Installation

#### [CocoaPods](https://cocoapods.org)
Add the following to your `Podfile`:
```
pod 'EPUBKit', '~> 0.2.2'
```

#### [Carthage](https://github.com/Carthage/Carthage)
Add to `Cartfile`:
```
github "witekbobrowski/EPUBKit" ~> 0.2.2
```

#### [Swift Package Manager](https://swift.org/package-manager/)
Add to `Package.swift`:
```swift
.Package(url: "https://github.com/witekbobrowski/EPUBKit.git", from: 0.2.2)
```

## Usage

#### Basic

Just import EPUBKit in your swift file.
```swift
import EPUBKit
```

Initialize document instance with `URL` of your EPUB document.
```swift
guard
    let path = Bundle.main.url(forResource: "steve_jobs", withExtension: "epub"),
    let document = EPUBDocument(url: path)
else { return }
```

If the document gets parsed correctly, you have access to full document metadata, contents, etc.
```swift
print(document.title)
> Steve Jobs
print(document.author)
> Walter Isaacson
```

#### Advanced

Although the basic usage is perfectly fine, there are times you want to have more control over stuff.
That is why I have made the parser public, so you can manually parse documents and take full adventage over the library API.

Main functionality is wrapped in a simple `EPUBParserProtocol` protocol:
```swift
public protocol EPUBParserProtocol where Self: EPUBParsable {
    var delegate: EPUBParserDelegate? { get set }
    func parse(documentAt path: URL) throws -> EPUBDocument
}
```
This basically defines the parser capabilities, and enforces one very important thing, which is conditional conformance to internal protocol `EPUBParsable`. 
The idea behind this protocol arrangement is to hide implementation details of the parsing itself, yet provide some kind of overview on the 'identity' of the `EPUBParser` class.

Having the delegate is nice becouse you can have more insight over what is happening behind the scenes.
`EPUBParserDelegate` provides a wide range of methods that let you peek under the hood of parser.

__Some simple flow would go like this:__

Lets say we are developing an app for `iOS` and have a view controller that handles epub documents in some way, for example displays a list.

In the first place you could add these two properties to the view controller
```swift
let parser: EPUBParser
let urls: [URL]

var documents: [EPUBDocument] = []
```

Add feed the VC with the missing properties through the dependency injection in init.
```swift
init(parser: EPUBParser, urls: [URL]) {
    self.parser = parser
    self.urls = urls
    super.init(nibName: nil, bundle: nil)
}
```

Now after the view loads we could set ourselfs as the delegate of the parser (after extending view controller with `EPUBParserDelegate` protocol, otherwise we get an error).
```swift
parser.delegate = self
```

And iterate over the array of url in hope of parsing every document correctly and append them to previously defined array.
```swift
urls.forEach { url in
    guard let document = try? parser.parse(documentAt: url) else { return }
    documents.append(document)
}
```

And that is basically it. Now we can for example pass parsed documents to the table view cells to enable displaing user's library.

What are the adventages of taking this approach? Firstly its reusing the parser object. 
Using the previously mentioned `EPUBDocument`'s `init(url:)` initializer we avoid instantiating it every time for each document. 
Now we have also a lot more insight on the parsing process itself, we could either check on errors in the standard swift way using `do-catch` statement,
or using delegation and `parser(:,didFailParsingDocumentAt:,with:)` that passed an error if such occurs. 
And finally we could improve user experience with something like starting to load cover before the process of parsing finishes.

As the library evolves and API gets richer and richer the possibilities of advanced usage of this library will come more and more handy.

__Note:__ Documentation is not yet ready, but you should find it easy to explore the API by yourself 🙃

## Contents

```
EPUBKit
├── EPUBKit.h
├── Info.plist
├── Model
│   ├── Creator.swift
│   ├── EPUBDocument.swift
│   ├── EPUBManifest.swift
│   ├── EPUBManifestItem.swift
│   ├── EPUBMediaType.swift
│   ├── EPUBMetadata.swift
│   ├── EPUBSpine.swift
│   ├── EPUBSpineItem.swift
│   └── EPUBTableOfContents.swift
├── Parser
│   ├── EPUBParser.swift
│   └── EPUBParserError.swift
└── Protocols
    ├── EPUBParsable.swift
    ├── EPUBParserDelegate.swift
    └── EPUBParserProtocol.swift
```
