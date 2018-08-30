//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
//类型参数 Element
struct Stack<Element> {
    var items = [Element]()
    mutating func push(_ item:Element) {
        items.append(item)
    }
    
    mutating func pop() -> Element{
        return items.removeLast()
    }
}

//扩展一个泛型类型
extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}


//类型约束 类型约束可以指定一个类型参数必须继承自指定类，或者符合一个特定的协议或协议组合。

//Swift 标准库中定义的一个特定协议。所有的 Swift 基本类型（例如 String、Int、Double 和 Bool）默认都是可哈希的。
func findIndex<T:Equatable>(of valueToFind:T,in array:[T]) -> Int? {
    for (index,value) in array.enumerated() {
        if (value == valueToFind){
            return index;
        }
    }
    return nil;
}


protocol Container {
    associatedtype Item
    mutating func append(_ item:Item)
    var count: Int {get}
    subscript(i: Int) -> Item {get}
    
}

struct IntStack: Container {

    
    // IntStack 的原始实现部分
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
    // Container 协议的实现部分
//    typealias Item = Int
    mutating func append(_ item: Int) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}











