# EPUBKit

### Installation

##### CocoaPods
Add the following to your `Podfile`:
```
pod 'EPUBKit', :git => 'https://github.com/witekbobrowski/EPUBKit.git'

```
and then run this command
```
pod install
```

### Usage
Just import EPUBKit in your swift file.

```
import EPUBKit
```
### API
Initialize document with name of `EPUB` file

```
let epubDocument: EPUBDocument? = EPUBDocument(named: "Brave New World")
```


### Structure

```
|-- EPUBKit.h
|-- EPUBKitCore
|   |-- Model
|   |   |-- EPUBDocument.swift
|   |   |-- EPUBManifest.swift
|   |   |-- EPUBMetadata.swift
|   |   |-- EPUBSpine.swift
|   |   `-- EPUBTableOfContents.swift
|   `-- Utils
|       |-- EPUBParsable.swift
|       |-- EPUBParser.swift
|       `-- EPUBParserError.swift
|-- EPUBKitView
|   |-- Data Sources
|   |   `-- EKTableOfContentsDataSource.swift
|   |-- Main.storyboard
|   |-- Protocols
|   |   |-- EKViewDataSource.swift
|   |   `-- EKViewDataSourceDelegate.swift
|   |-- View\ Controllers
|   |   |-- EKTableOfContentsViewController.swift
|   |   `-- EKViewController.swift
|   `-- Views
|       |-- epubVC
|       |   |-- EKInfiniteScrollView.swift
|       |   `-- EKInfiniteScrollView.xib
|       `-- tableOfConentsVC
|           |-- EKTableOfContentsViewCellTableViewCell.swift
|           `-- EKTableOfContentsViewCellTableViewCell.xib
`-- Info.plist
```

### TODO

- [ ] CocoaPods support
- [ ] Carthage support
- [ ] Swift Package Manager support
- [ ] TravisCI integration
- [ ] Documentation
- [ ] Full EPUB 3 support
- [ ] PageView
- [ ] Remove storyboards
