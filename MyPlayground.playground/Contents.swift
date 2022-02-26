import Foundation

let hello = { () -> () in
    print("hello")
}

hello()

let hello2 = { (name: String) -> String in
    return "Hello, \(name)"
}

hello2("Gunter")

func doSomething(closure: () -> ()) {
    closure()
}

doSomething (closure: { <#T##() -> ()#> in
})
