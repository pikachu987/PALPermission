# PALPermission

[![CI Status](https://img.shields.io/travis/pikachu987/PALPermission.svg?style=flat)](https://travis-ci.org/pikachu987/PALPermission)
[![Version](https://img.shields.io/cocoapods/v/PALPermission.svg?style=flat)](https://cocoapods.org/pods/PALPermission)
[![License](https://img.shields.io/cocoapods/l/PALPermission.svg?style=flat)](https://cocoapods.org/pods/PALPermission)
[![Platform](https://img.shields.io/cocoapods/p/PALPermission.svg?style=flat)](https://cocoapods.org/pods/PALPermission)
![](https://img.shields.io/badge/Supported-iOS9%20%7C%20OSX%2010.9-4BC51D.svg?style=flat-square)
![](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

PALPermission is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PALPermission/Gallery'
pod 'PALPermission/Camera'
pod 'PALPermission/Audio'
pod 'PALPermission/Contact'
```

```swift
Permission.gallery(.main) { (result) in
    if case .success = result {
        
    } else {
        
    }
}
```

```swift
Permission.camera(.main) { (result) in
    if case .success = result {
        
    } else {
        
    }
}
```

```swift
Permission.audio(.main) { (result) in
    if case .success = result {
        
    } else {
        
    }
}
```

```swift
Permission.contact(.main) { (result) in
    if case .success = result {
        
    } else {
        
    }
}
```

## Author

pikachu987, pikachu77769@gmail.com

## License

PALPermission is available under the MIT license. See the LICENSE file for more info.
