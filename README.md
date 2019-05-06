# PwnedPasswords
[![License](https://img.shields.io/cocoapods/l/PwnedPasswords.svg?style=flat)](https://cocoapods.org/pods/PwnedPasswords)

PwnedPasswords implements a client for HaveIBeenPwned.com's [Pwned Passwords API v2](https://haveibeenpwned.com/API/v2#PwnedPasswords) in Swift.

- Its only dependencies are `Foundation` and `CommonCrypto`.
- Does not disclose the password being checked to third parties. Only the first 5 characters of the password sha1 *hash* are disclosed (See [k-Anonymity](https://en.wikipedia.org/wiki/K-anonymity).)
- Can target iOS, macOS, tvOS, and watchOS.


## Example

```swift
    PwnedPasswords.shared.check(password: "password1") { (result) in

        switch result {

            case .success( let count ):

                if count > 0 {
                
                  print( "This password has been found \(count) times in compromised accounts" )
                  
                } else {
                
                  print( "This password wasn't found to be compromised." )
                  
                }
                
            case .failure:

                print( "This password could not be checked at this time" )

        }

    }
```

## Installation: CocoaPods

PwnedPasswords is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PwnedPasswords'
```

## Installation: Manual

Copy `PwnedPasswords.swift` to your project.


## License

PwnedPasswords is available under the MIT license. See the LICENSE file for more info.
