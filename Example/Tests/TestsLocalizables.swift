import UIKit
import XCTest
import LocalizeNIB

class TestsLocalizables: XCTestCase {
    let provider: LocalizedStringProvider = {
        [
            "s1": "l1",
            "s2": "l2",
            "s3": "l3",
            "s4": "l4",
            "s5": "l5"
        ][$0] ?? $0
    }

    func helperLocalize(_ localizable: Localizable) {
        do {
            try localizable.localize(provider: provider)
        } catch {
            XCTFail("Localizable thrown error: \(error)")
        }
    }

    func testLabel() {
        let label = UILabel()
        label.text = "s1"

        helperLocalize(label)
        XCTAssertEqual(label.text, "l1")
    }

    func testTextField() {
        let textField = UITextField()
        textField.text = "s1"
        textField.placeholder = "s2"

        helperLocalize(textField)
        XCTAssertEqual(textField.text, "l1")
        XCTAssertEqual(textField.placeholder, "l2")
    }

    func testButton() {
        var button = UIButton()
        button.setTitle("s1", for: .normal)

        helperLocalize(button)
        XCTAssertEqual(button.title(for: .normal), "l1")
        XCTAssertEqual(button.title(for: .disabled), "l1")
        XCTAssertEqual(button.title(for: .highlighted), "l1")
        XCTAssertEqual(button.title(for: .selected), "l1")
        XCTAssertEqual(button.title(for: .focused), "l1")


        button = UIButton()
        button.setTitle("s1", for: .normal)
        button.setTitle("s2", for: .highlighted)

        helperLocalize(button)
        XCTAssertEqual(button.title(for: .normal), "l1")
        XCTAssertEqual(button.title(for: .disabled), "l1")
        XCTAssertEqual(button.title(for: .highlighted), "l2")
        XCTAssertEqual(button.title(for: .selected), "l1")
        XCTAssertEqual(button.title(for: .focused), "l1")


        button = UIButton()
        button.setTitle("s1", for: .normal)
        button.setTitle("s2", for: .disabled)
        button.setTitle("s3", for: .highlighted)
        button.setTitle("s4", for: .selected)
        button.setTitle("s5", for: .focused)

        helperLocalize(button)
        XCTAssertEqual(button.title(for: .normal), "l1")
        XCTAssertEqual(button.title(for: .disabled), "l2")
        XCTAssertEqual(button.title(for: .highlighted), "l3")
        XCTAssertEqual(button.title(for: .selected), "l4")
        XCTAssertEqual(button.title(for: .focused), "l5")
    }

    func testSegmented() {
        let segmented = UISegmentedControl(items: ["s1", "s2", "s3"])

        helperLocalize(segmented)
        XCTAssertEqual(segmented.titleForSegment(at: 0), "l1")
        XCTAssertEqual(segmented.titleForSegment(at: 1), "l2")
        XCTAssertEqual(segmented.titleForSegment(at: 2), "l3")
    }

    func testTextView() {
        let textView = UITextView()
        textView.text = "s1"

        helperLocalize(textView)
        XCTAssertEqual(textView.text, "l1")
    }

    func testBarItem() {
        let barItem = UIBarButtonItem()
        barItem.title = "s1"

        helperLocalize(barItem)
        XCTAssertEqual(barItem.title, "l1")
    }

    func testNavItem() {
        let navItem = UINavigationItem()
        navItem.title = "s1"
        navItem.prompt = "s2"
        navItem.backBarButtonItem = UIBarButtonItem(title: "s3", style: .plain, target: nil, action: nil)

        helperLocalize(navItem)
        XCTAssertEqual(navItem.title, "l1")
        XCTAssertEqual(navItem.prompt, "l2")
        XCTAssertEqual(navItem.backBarButtonItem?.title, "l3")
    }

    func testSearchBar() {
        let searchBar = UISearchBar()
        searchBar.text = "s1"
        searchBar.placeholder = "s2"
        searchBar.prompt = "s3"
        searchBar.scopeButtonTitles = ["s4", "s5"]

        helperLocalize(searchBar)
        XCTAssertEqual(searchBar.text, "l1")
        XCTAssertEqual(searchBar.placeholder, "l2")
        XCTAssertEqual(searchBar.prompt, "l3")
        XCTAssertEqual(searchBar.scopeButtonTitles!, ["l4", "l5"])
    }

    func testViewController() {
        let viewController = UIViewController()
        viewController.title = "s1"

        helperLocalize(viewController)
        XCTAssertEqual(viewController.title, "l1")
    }

}
