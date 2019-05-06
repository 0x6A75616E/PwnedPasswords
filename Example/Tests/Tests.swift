import XCTest
import PwnedPasswords

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCompromisedMatch(){
        
        let expectation = self.expectation(description: "Pwned Check Callback")
        
        var foundCount: Int?
        
        PwnedPasswords.shared.check(password: "password1") { (result) in
            
            switch result {
                
                case .success( let count ):
                    
                    foundCount = count
                
                case .failure:
                    
                    foundCount = nil
                
            }
            
            expectation.fulfill()
            
        }
        
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertNotNil( foundCount )
        
        XCTAssert( foundCount! > 0 )
        
    }
    
    
    func testUncompromisedMatch(){
        
        let password = UUID().uuidString + UUID().uuidString + UUID().uuidString + UUID().uuidString
        
        let expectation = self.expectation(description: "Pwned Check Callback")
        
        var foundCount: Int?
        
        PwnedPasswords.shared.check(password: password) { (result) in
            
            switch result {
                
                case .success( let count ):
                    
                    foundCount = count
                
                case .failure:
                    
                    foundCount = nil
                
            }
            
            expectation.fulfill()
            
        }
        
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertNotNil( foundCount )
        
        XCTAssert( foundCount! == 0 )
        
    }
    
}
