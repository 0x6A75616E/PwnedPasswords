//
// PwnedPasswords, https://github.com/0x6A75616E/PwnedPasswords
// by @0x6A75616E
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Daniel Thorpe
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


import Foundation
import CommonCrypto


fileprivate let kRangePrefixLength = 5
fileprivate let kRangeResultLength = 35 // length of sha1 (40) - kRangePrefixLength



public class PwnedPasswords {
    
    private let baseURL = URL(string: "https://api.pwnedpasswords.com/range")!

    public static var shared = PwnedPasswords()
    
    public var userAgent: String = {
        let bundleName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
        let bundleVersion = Bundle.main.infoDictionary![kCFBundleVersionKey as String] as! String
        
        return "\(bundleName)/\(bundleVersion) (PwnedPasswords) - github.com/0x6A75616E/SwiftPwnedPassword"
    }()
    
    
    
    /// Searches for occurrences of `password` in the haveibeenpwned.com database of compromises.
    /// The api used implements a k-Anonymity model, so the password or its hash is never disclosed in full
    /// to a third party.
    ///
    /// - Parameters:
    ///     - password: The *password* to check
    ///     - completionHandler: Is called with the result of the query.
    ///                          The call is not guaranteed to happen on the main thread.
    ///
    ///                          *completionHandler* is given a `Result`, which contains a
    ///                          *RangeCheckResult* and a `RequestError`.
    ///
    public func check( password: String, completionHandler: @escaping (Result<Int, RequestError>) -> Void)  {
        
        // sha1 hash of the entire password (not disclosed)
        let hash = password.sha1().uppercased()
        
        // first `kRangePrefixLength` characters of the hash (the only part disclosed to the api)
        let rangeQuery = String(hash.prefix( kRangePrefixLength ))
        
        // remainder of the password (not disclosed)
        let rangeResultMatch = String(hash.suffix( kRangeResultLength ))
    
        
        let url = self.baseURL.appendingPathComponent( rangeQuery )
        let session = URLSession.shared
        var request = URLRequest(url: url)
        
        request.setValue(self.userAgent, forHTTPHeaderField: "User-Agent")
        
        
        let task = session.dataTask(with: request) { (data, responseObject, error) in
            
            // assert response is HTTPURLResponse
            guard let response = responseObject as? HTTPURLResponse else {
                fatalError( "Response was not a HTTPURLResponse" )
            }
            
            // handle URLSession errors
            if let error = error {
                completionHandler(.failure( .PreconditionFailed(reason: error.localizedDescription) ))
                return
            }
            
            // make sure response status code is within 200 range
            if !(200 ... 299).contains(response.statusCode) {
                completionHandler(.failure( .Non200StatusCode(statusCode: response.statusCode) ))
                return
            }
            
            // retrieve response body as string
            guard let data = data, let responseBody = String(data: data, encoding: .utf8) else {
                completionHandler(.failure( .PreconditionFailed(reason: "Invalid response data") ))
                return
            }
            
            // find `rangeResultMatch`, which is the rest of the hash followed by ":"
            if let matchRange = responseBody.range(of: rangeResultMatch + ":") {
                
                // after the ":", find numbers (representing the number of pwnd matches)
                let countString = responseBody[matchRange.upperBound...].prefix(while: { "0"..."9" ~= $0 })
                
                // parse the count as Int
                let count = Int(countString, radix: 10)!
                
                completionHandler( .success(count) )
                
                return
                
            }
            
            
            completionHandler( .success(0) )

        }
        
        task.resume()

    }

}



extension PwnedPasswords {
    
    public enum RequestError: Error {
        case Non200StatusCode(statusCode: Int)
        case PreconditionFailed(reason: String)
    }
    
}



// MARK: Hashing
fileprivate extension String {
    
    func sha1() -> String {
        
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        
        data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            _ = CC_SHA1(bytes.baseAddress, CC_LONG(data.count), &digest)
        }
        
        let hexBytes = digest.map {
            String(format: "%02hhx", $0)
        }
        
        return hexBytes.joined()
        
    }
    
}
