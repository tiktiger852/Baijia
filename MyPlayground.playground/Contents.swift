//: Playground - noun: a place where people can play

import XCPlayground
//XCPSetExecutionShouldContinueIndefinitely(true)
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

import UIKit
import Alamofire
import SwiftyJSON
import Security

var str = "Hello, playground"
/*
var str1 = withUnsafeMutablePointer(&str, { (ptr: UnsafeMutablePointer<String>) -> String in
    ptr.memory = "fuck"
    return ptr.memory
})

print("str:\(str), str1:\(str1)")
*/


let r = Range<String.Index>(start: str.startIndex.advancedBy(0), end: str.startIndex.advancedBy(2))

let str2 = str.substringWithRange(r)
print(str2)