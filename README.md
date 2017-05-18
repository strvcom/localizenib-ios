# LocalizeNIB

[![CI Status](http://img.shields.io/travis/dzindra/LocalizeNIB.svg?style=flat)](https://travis-ci.org/dzindra/LocalizeNIB)
[![Version](https://img.shields.io/cocoapods/v/LocalizeNIB.svg?style=flat)](http://cocoapods.org/pods/LocalizeNIB)
[![License](https://img.shields.io/cocoapods/l/LocalizeNIB.svg?style=flat)](http://cocoapods.org/pods/LocalizeNIB)
[![Platform](https://img.shields.io/cocoapods/p/LocalizeNIB.svg?style=flat)](http://cocoapods.org/pods/LocalizeNIB)

LocalizeNIB helps you with localizing storyboards and XIB files. Put everything you want to be localized to `localizables`
outlet collection in your `UIViewController` and LocalizeNIB will use `NSLocalizedString` on everything. No more messing with unreadable
component IDs!

## Installation

LocalizeNIB is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LocalizeNIB"
```

## Usage

### Basic usage

LocalizeNIB uses `NSLocalizedString` by default. If you have your Localizable.strings file ready, then all you need to do is add all components you want to localize to `localizables` outlet collection.



## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author

Jindra Dolezy, jindra.dolezy@strv.com

## License

LocalizeNIB is available under the MIT license. See the LICENSE file for more info.
