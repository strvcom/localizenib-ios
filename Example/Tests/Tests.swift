import XCTest
import LocalizeNIB

class Tests: XCTestCase {
    var localizeNIB: LocalizeNIB!
    
    override func setUp() {
        super.setUp()
        
        localizeNIB = LocalizeNIB(debugMode: false, stringProvider: nil)
    }
    
    func helperLocalize(_ objects: [AnyObject]) {
        do {
            try localizeNIB.localize(objects)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testLocalizeString() {
        var called = false
        localizeNIB.stringProvider = {
            called = true
            return $0 == "test" ? "localized" : $0
        }
        XCTAssertEqual(localizeNIB.localize("test"), "localized")
        XCTAssertTrue(called, "String provider not called")
    }
    
    func testLocalizeObjects() {
        let localizable1 = TestLocalizable(text: "string1")
        let localizable2 = TestLocalizable(text: "string2")
        let localizable3 = TestLocalizable(text: "string3")
        
        var called = false
        localizeNIB.stringProvider = {
            called = true
            return ["string1": "locString1", "string2": "locString2"][$0] ?? $0
        }
        localizeNIB.debugBlock = { _ in XCTFail("Debug block should not be called") }
        
        helperLocalize([localizable1, localizable2, localizable3])
        
        XCTAssertTrue(called, "String provider not called")
        XCTAssertEqual(localizable1.text, "locString1")
        XCTAssertEqual(localizable2.text, "locString2")
        XCTAssertEqual(localizable3.text, "string3")
    }
    
    func testLocalizeAll() {
        let localizable1 = TestLocalizable(text: "string1")
        let localizable2 = TestLocalizable(text: "string2")
        
        var called = false
        localizeNIB.localizeAll = { obj, provider in
            called = true
            if obj === localizable1 {
                // object is localizable1 -> skip localization by returning true
                return true
            } else {
                // continue with localization
                return false
            }
        }
        localizeNIB.stringProvider = { _ in "provider" }
        localizeNIB.debugBlock = { _ in XCTFail("Debug block should not be called") }
        
        helperLocalize([localizable1, localizable2])
        
        XCTAssertTrue(called, "Localize all not called")
        XCTAssertEqual(localizable1.text, "string1")
        XCTAssertEqual(localizable2.text, "provider")
    }
    
    func testDebugModeNotLocalizable() {
        var called = false
        localizeNIB.debugMode = true
        localizeNIB.debugBlock = { string in
            called = true
            print(string)
            XCTAssertFalse(string.isEmpty)
        }
        helperLocalize([NotLocalizable()])
        XCTAssertTrue(called, "Debug block not called")
    }
    
    func testDebugModeNotFound() {
        let localizable1 = TestLocalizable(text: "this text doesn't exist")
        var called = false
        
        localizeNIB.debugMode = true
        localizeNIB.debugBlock = { string in
            called = true
            print(string)
            XCTAssertFalse(string.isEmpty)
        }
        
        helperLocalize([localizable1])
        XCTAssertEqual(localizable1.text, "this text doesn't exist")
        XCTAssertTrue(called, "Debug block not called")
    }
    
    func testDefaultProvider() {
        localizeNIB.debugBlock = { _ in XCTFail("Debug block should not be called") }

        XCTAssertEqual(localizeNIB.localize("label"), "Localized label") // this uses Localizable.strings from main app bundle
        XCTAssertEqual(localizeNIB.localize("not existing"), "not existing")
    }
}

class NotLocalizable {
    
}

class TestLocalizable: Localizable {
    var text: String?
    
    init(text: String? = nil) {
        self.text = text
    }
    
    func localize(provider: (String) -> String) throws {
        text = text.map { provider($0) }
    }
}
