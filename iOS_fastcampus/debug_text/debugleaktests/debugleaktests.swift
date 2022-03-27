//
//  debugleaktests.swift
//  debug_text
//
//  Created by 윤병은 on 2022/03/27.
//

import XCTest
import XCTAssertNoLeak

@testable import debug_text

class debugleaktests: XCTestCase {
    func testAssertNoLeak() {
        XCTAssertNoLeak(ViewController())

        let rootViewController = UIApplication.shared.keyWindow?.rootViewController!
        let viewController = ViewController()

        XCTAssertNoLeak { context in
            rootViewController?.present(viewController, animated: true) {
                context.traverse(viewController)
                rootViewController?.dismiss(animated: true) {
                    context.completion()
                }
            }
            
        }
    }
}
