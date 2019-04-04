# Anchor

[![Version](https://img.shields.io/cocoapods/v/Anchor.svg?style=flat)](https://cocoapods.org/pods/Anchor)
[![License](https://img.shields.io/cocoapods/l/Anchor.svg?style=flat)](https://cocoapods.org/pods/Anchor)
[![Platform](https://img.shields.io/cocoapods/p/Anchor.svg?style=flat)](https://cocoapods.org/pods/Anchor)

## Usage

```swift
import Anchor

let anchorView = AnchorView(title: "Lorem Ipsum", contentView: contentScrollView, style: .light)
```
Create  an Anchor View.  

Required  
`title`: Title of your view.  
`contentView`: A scrollView that houses your content.  

Optional  
`style`: Of type `UIBlurEffect.Style`. Default value is `.dark`.  
`parentView`: A parent view to place the Anchor View in. If none is provided, `UIApplication.shared.keyWindow` is used.  

```swift
anchorView.open()

anchorView.close()
```
Open and close view. 


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

This pod is made with Swift 5.

## Installation

Anchor is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Anchor'
```

## Author

Armando Castaneda Elguero, armando.cas27@gmail.com

## License

Anchor is available under the MIT license. See the LICENSE file for more info.
