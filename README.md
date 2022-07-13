<p align=center>
<a href="">
<img alt="Logo" src="EPUBKit.png">
</a>
</p>
<p align=center>
    <a href="https://swift.org"><img alt="Swift" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fwitekbobrowski%2FEPUBKit%2Fbadge%3Ftype%3Dswift-versions"></a>
    <a href="https://swiftpackageindex.com/witekbobrowski/EPUBKit"><img alt="Platforms" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fwitekbobrowski%2FEPUBKit%2Fbadge%3Ftype%3Dplatforms"></a>
    <a href="https://twitter.com/witekbobrowski"><img alt="Contact" src="https://img.shields.io/badge/contact-@witekbobrowski-blue.svg"></a>
</p>
<p align=center>
📚 A simple swift library for parsing EPUB documents
</p>

__Note:__ This library is still in its early stages! I will experiment and change the API until I am satisfied with the result. I do not reccomend using this library in larger projects, although feedback will be highly appreciated 🙇

## Installation

#### Swift Package Manager
Add to `Package.swift`:
```swift
.package(url: "https://github.com/witekbobrowski/EPUBKit.git", from: "0.4.0")
```

#### CocoaPods
Add the following to your `Podfile`:
```
pod 'EPUBKit'
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

Lets say we are developing an app for `iOS` and have a view controller that handles epub documents in some way, for example displays a list.

In the first place you could add these two properties to the view controller (dont forget to import the library).
```swift
let parser: EPUBParser
let urls: [URL]

var documents: [EPUBDocument] = []
```

And feed the VC with the missing properties through the dependency injection in init.
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

And that is basically it. Now for example, you could pass parsed documents to the table view.

What are the adventages of taking this approach? Firstly its reusing the parser object. 
Using the previously mentioned `EPUBDocument`'s `init(url:)` initializer we avoid instantiating it every time for each document. 
Now we have also a lot more insight on the parsing process itself, we could either check on errors in the standard swift way using `do-catch` statement,
or using delegation and `parser(:,didFailParsingDocumentAt:,with:)` that passes an error if such occurs. 
And finally we could improve user experience with something like starting to load cover before the process of parsing finishes.

As the library evolves and API gets richer and richer the possibilities of advanced usage of this library will come more and more handy.

__Note:__ Documentation is not yet ready, but you should find it easy to explore the API by yourself 🙃

