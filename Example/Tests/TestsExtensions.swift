import UIKit
import XCTest
import LocalizeNIB

class TestsExtensions: XCTestCase {
    
    func testViewControllerExt() {
        let localizable = TestLocalizable(text: "localizable")
        
        var called = false
        LocalizeNIB.instance.stringProvider = { string in
            called = true
            XCTAssertEqual(string, "localizable")
            return "localized"
        }
        
        let vc = UIViewController()
        vc.localizables = [localizable]
        
        XCTAssertTrue(called, "String provider not called")
        XCTAssertEqual(localizable.text, "localized")
        XCTAssertTrue(vc.localizables.isEmpty)
    }
    
    func testTableViewCellExt() {
        let localizable = TestLocalizable(text: "localizable")
        
        var called = false
        LocalizeNIB.instance.stringProvider = { string in
            called = true
            XCTAssertEqual(string, "localizable")
            return "localizedTV"
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.localizables = [localizable]
        
        XCTAssertTrue(called, "String provider not called")
        XCTAssertEqual(localizable.text, "localizedTV")
        XCTAssertTrue(cell.localizables.isEmpty)
    }
    
    func testCollectionViewCellExt() {
        let localizable = TestLocalizable(text: "localizable")
        
        var called = false
        LocalizeNIB.instance.stringProvider = { string in
            called = true
            XCTAssertEqual(string, "localizable")
            return "localizedCV"
        }
        
        let cell = UICollectionViewCell()
        cell.localizables = [localizable]
        
        XCTAssertTrue(called, "String provider not called")
        XCTAssertEqual(localizable.text, "localizedCV")
        XCTAssertTrue(cell.localizables.isEmpty)
    }
    
    func testStringExt() {
        var called = false
        LocalizeNIB.instance.stringProvider = { string in
            called = true
            XCTAssertEqual(string, "test string")
            return "localized test string"
        }
        
        let result = "test string".localized
        XCTAssertTrue(called, "String provider not called")
        XCTAssertEqual(result, "localized test string")
    }
    
}
