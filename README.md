# AlamofireJsonToObjects

<!---
 [![Circle CI](https://img.shields.io/circleci/project/evermeer/AlamofireJsonToObjects.svg?style=flat)](https://circleci.com/gh/evermeer/AlamofireJsonToObjects)
 -->
[![Build Status](https://travis-ci.org/evermeer/AlamofireJsonToObjects.svg?branch=master)](https://travis-ci.org/evermeer/AlamofireJsonToObjects)
[![Issues](https://img.shields.io/github/issues-raw/evermeer/AlamofireJsonToObjects.svg?style=flat)](https://github.com/evermeer/AlamofireJsonToObjects/issues)
[![Documentation](https://img.shields.io/badge/documented-100%-brightgreen.svg?style=flat)](http://cocoadocs.org/docsets/AlamofireJsonToObjects)
[![Stars](https://img.shields.io/github/stars/evermeer/AlamofireJsonToObjects.svg?style=flat)](https://github.com/evermeer/AlamofireJsonToObjects/stargazers)
[![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/matteocrippa/awesome-swift#json)

[![Version](https://img.shields.io/cocoapods/v/AlamofireJsonToObjects.svg?style=flat)](http://cocoadocs.org/docsets/AlamofireJsonToObjects)
[![Language](https://img.shields.io/badge/language-swift3-f48041.svg?style=flat)](https://developer.apple.com/swift)
[![Platform](https://img.shields.io/cocoapods/p/AlamofireJsonToObjects.svg?style=flat)](http://cocoadocs.org/docsets/AlamofireJsonToObjects)
[![Support](https://img.shields.io/badge/support-iOS%208%2B%20|%20OSX%2010.9+%20|%20WOS%202+-blue.svg?style=flat)](https://www.apple.com/nl/ios/)
[![License](https://img.shields.io/cocoapods/l/AlamofireJsonToObjects.svg?style=flat)](http://cocoadocs.org/docsets/AlamofireJsonToObjects)

[![Git](https://img.shields.io/badge/GitHub-evermeer-blue.svg?style=flat)](https://github.com/evermeer)
[![Twitter](https://img.shields.io/badge/twitter-@evermeer-blue.svg?style=flat)](http://twitter.com/evermeer)
[![LinkedIn](https://img.shields.io/badge/linkedin-Edwin Vermeer-blue.svg?style=flat)](http://nl.linkedin.com/in/evermeer/en)
[![Website](https://img.shields.io/badge/website-evict.nl-blue.svg?style=flat)](http://evict.nl)
[![eMail](https://img.shields.io/badge/email-edwin@evict.nl-blue.svg?style=flat)](mailto:edwin@evict.nl?SUBJECT=About AlamofireJsonToObjects)

If you have a question and don't want to create an issue, then we can [![Join the chat at https://gitter.im/evermeer/EVReflection](https://badges.gitter.im/evermeer/EVReflection.svg)](https://gitter.im/evermeer/EVReflection?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) (EVReflection is the base of AlamofireJsonToObjects)

With AlamofireJsonToObjects it's extremely easy to fetch a json feed and parse it into objects. No property mapping is required. Reflection is used to put the values in the corresponding properties.

AlamofireJsonToObjects is based on the folowing libraries:
- [Alamofire](https://github.com/Alamofire/Alamofire) is an elegant HTTP Networking library in Swift
- [EVReflection](https://github.com/evermeer/EVReflection) is used to parse the JSON result to your objects

This library was greatly inspired by [AlamofireObjectMapper](https://github.com/tristanhimmelman/AlamofireObjectMapper)

At this moment the master branch is for Swift3. If you want to continue using Swift 2.2 (or 2.3) then switch to the Swift2.2 branch.
Run the tests to see AlamofireJsonToObjects in action.

## Using AlamofireJsonToObjects in your own App 

'AlamofireJsonToObjects' is available through the dependency manager [CocoaPods](http://cocoapods.org). 

You can just add AlamofireJsonToObjects to your workspace by adding the folowing 2 lines to your Podfile:

```
use_frameworks!
pod "AlamofireJsonToObjects"
```

you also have to add an import at the top of your swift file like this:

```
import AlamofireJsonToObjects
```

## Sample code

```
class WeatherResponse: EVNetworkingObject {
    var location: String?
    var three_day_forecast: [Forecast] = [Forecast]()
}

class Forecast: EVNetworkingObject {
    var day: String?
    var temperature: NSNumber?
    var conditions: String?
}

class AlamofireJsonToObjectsTests: XCTestCase {
    func testResponseObject() {
        let URL = "https://raw.githubusercontent.com/evermeer/AlamofireJsonToObjects/master/AlamofireJsonToObjectsTests/sample_json"
        Alamofire.request(URL)
           .responseObject { (response: Result<WeatherResponse>) in
           if let result = response.value {
            // That was all... You now have a WeatherResponse object with data
           }
        }
        waitForExpectationsWithTimeout(10, handler: { (error: NSError!) -> Void in
            XCTAssertNil(error, "\(error)")
        })
    }
}
```

The code above will pass the folowing json to the objects:

```
{  "location": "Toronto, Canada",    
   "three_day_forecast": [
      { "conditions": "Partly cloudy",
        "day" : "Monday",
        "temperature": 20 
      }, { 
        "conditions": "Showers",
        "day" : "Tuesday",
        "temperature": 22 
      }, { 
        "conditions": "Sunny",
        "day" : "Wednesday",
        "temperature": 28 
      }
   ]
}
```

## Advanced object mapping
AlamofireJsonToObjects is based on [EVReflection](https://github.com/evermeer/EVReflection) and you can use all [EVReflection](https://github.com/evermeer/EVReflection) features like property mapping, converters, validators and key kleanup. See [EVReflection](https://github.com/evermeer/EVReflection) for more information.

## Handling HTTP status >= 300
When a network call returns a [HTTP error status](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) (300 or highter) then this will be added to the evReflectionStatuses as a custom error. see the unit test testErrorResponse as a sample. In order to make this work, you do have to set EVNetworkingObject as your bass class and not EVObject. You then also have to be aware that if you override the initValidation or the propertyMapping function, that you also have to call the super for that function.


## License

AlamofireJsonToObjects is available under the MIT 3 license. See the LICENSE file for more info.

## My other libraries:
Also see my other open source iOS libraries:

- [EVReflection](https://github.com/evermeer/EVReflection) - Swift library with reflection functions with support for NSCoding, Printable, Hashable, Equatable and JSON 
- [EVCloudKitDao](https://github.com/evermeer/EVCloudKitDao) - Simplified access to Apple's CloudKit
- [EVFaceTracker](https://github.com/evermeer/EVFaceTracker) - Calculate the distance and angle of your device with regards to your face in order to simulate a 3D effect
- [EVURLCache](https://github.com/evermeer/EVURLCache) - a NSURLCache subclass for handling all web requests that use NSURLReques
- [AlamofireJsonToObject](https://github.com/evermeer/AlamofireJsonToObjects) - An Alamofire extension which converts JSON response data into swift objects using EVReflection
- [AlamofireXmlToObject](https://github.com/evermeer/AlamofireXmlToObjects) - An Alamofire extension which converts XML response data into swift objects using EVReflection and XMLDictionary
- [AlamofireOauth2](https://github.com/evermeer/AlamofireOauth2) - A swift implementation of OAuth2 using Alamofire
- [EVWordPressAPI](https://github.com/evermeer/EVWordPressAPI) - Swift Implementation of the WordPress (Jetpack) API using AlamofireOauth2, AlomofireJsonToObjects and EVReflection (work in progress)
- [PassportScanner](https://github.com/evermeer/PassportScanner) - Scan the MRZ code of a passport and extract the firstname, lastname, passport number, nationality, date of birth, expiration date and personal numer.
