////////////////////////////////////////////////////////////////////////////
//
// Copyright 2014 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

import XCTest
import Realm
import TestFramework

class SwiftObjectInterfaceTests: SwiftTestCase {

    // Swift models
    func testStuff() {
        let realm = realmWithTestPath()
        let co = SwiftCompanyObject()

        realm.write {
            realm.add(co)
            co.employees.append(SwiftEmployeeObject())
        }

        XCTAssertEqual(1, realm.objects(SwiftEmployeeObject).count)
    }

    func testSwiftObject() {
        let realm = realmWithTestPath()
        realm.beginWrite()

        let obj = SwiftObject()
        realm.add(obj)

        obj.boolCol = true
        obj.intCol = 1234
        obj.floatCol = 1.1
        obj.doubleCol = 2.2
        obj.stringCol = "abcd"
        obj.binaryCol = "abcd".dataUsingEncoding(NSUTF8StringEncoding)
        obj.dateCol = NSDate(timeIntervalSince1970: 123)
        obj.objectCol = SwiftBoolObject()
        obj.objectCol.boolCol = true
        obj.arrayCol.append(obj.objectCol)
        realm.commitWrite()

        let firstObj = realm.objects(SwiftObject).first()!
        XCTAssertEqual(firstObj.boolCol, true, "should be true")
        XCTAssertEqual(firstObj.intCol, 1234, "should be 1234")
        XCTAssertEqual(firstObj.floatCol, 1.1, "should be 1.1")
        XCTAssertEqual(firstObj.doubleCol, 2.2, "should be 2.2")
        XCTAssertEqual(firstObj.stringCol, "abcd", "should be abcd")
        XCTAssertEqual(firstObj.binaryCol!, "abcd".dataUsingEncoding(NSUTF8StringEncoding)!, "should be abcd data")
        XCTAssertEqual(firstObj.dateCol, NSDate(timeIntervalSince1970: 123), "should be epoch + 123")
        XCTAssertEqual(firstObj.objectCol.boolCol, true, "should be true")
        XCTAssertEqual(obj.arrayCol.count, 1, "array count should be 1")
        XCTAssertEqual(obj.arrayCol.first()!.boolCol, true, "should be true")
    }

    func testDefaultValueSwiftObject() {
        let realm = realmWithTestPath()
        realm.beginWrite()
        realm.add(SwiftObject())
        realm.commitWrite()

        let firstObj = realm.objects(SwiftObject).first()!
        XCTAssertEqual(firstObj.boolCol, false, "should be false")
        XCTAssertEqual(firstObj.intCol, 123, "should be 123")
        XCTAssertEqual(firstObj.floatCol, 1.23, "should be 1.23")
        XCTAssertEqual(firstObj.doubleCol, 12.3, "should be 12.3")
        XCTAssertEqual(firstObj.stringCol, "a", "should be a")
        XCTAssertEqual(firstObj.binaryCol!, "a".dataUsingEncoding(NSUTF8StringEncoding)!, "should be a data")
        XCTAssertEqual(firstObj.dateCol, NSDate(timeIntervalSince1970: 1), "should be epoch + 1")
        XCTAssertEqual(firstObj.objectCol.boolCol, false, "should be false")
        XCTAssertEqual(firstObj.arrayCol.count, 0, "array count should be zero")
    }

    func testOptionalSwiftProperties() {
        let realm = realmWithTestPath()
        realm.beginWrite()

        let obj = SwiftOptionalObject()
//        obj.optBoolCol = true
//        obj.optIntCol = 1234
//        obj.optFloatCol = 1.1
//        obj.optDoubleCol = 2.2
        obj.optStringCol = "abcd"
        obj.optBinaryCol = "abcd".dataUsingEncoding(NSUTF8StringEncoding)
        obj.optDateCol = NSDate(timeIntervalSince1970: 123)
//        obj.optObjectCol = SwiftBoolObject()
//        obj.optObjectCol!.boolCol = true
        realm.add(obj)

        realm.commitWrite()

        let firstObj = realm.objects(SwiftOptionalObject).first()!
//        XCTAssertEqual(firstObj.optBoolCol!, true, "should be true")
//        XCTAssertEqual(firstObj.optIntCol!, 1234, "should be 1234")
//        XCTAssertEqual(firstObj.optFloatCol!, 1.1, "should be 1.1")
//        XCTAssertEqual(firstObj.optDoubleCol!, 2.2, "should be 2.2")
        XCTAssertEqual(firstObj.optStringCol!, "abcd", "should be abcd")
        XCTAssertEqual(firstObj.optBinaryCol!, "abcd".dataUsingEncoding(NSUTF8StringEncoding)!, "should be abcd data")
        XCTAssertEqual(firstObj.optDateCol!, NSDate(timeIntervalSince1970: 123), "should be epoch + 123")
//        XCTAssertEqual(firstObj.objectCol.boolCol, true, "should be true")
//        XCTAssertEqual(obj.arrayCol.count, 1, "array count should be 1")
//        XCTAssertEqual((obj.arrayCol.firstObject() as? SwiftBoolObject)!.boolCol, true, "should be true")
    }

    func testSwiftClassNameIsDemangled() {
        XCTAssertEqual(SwiftObject.className()!, "SwiftObject", "Calling className() on Swift class should return demangled name")
    }
}
