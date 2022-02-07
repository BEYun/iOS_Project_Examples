import UIKit

var greeting = "Hello, playground"

let cities = ["Seoul", "Tokyo", "Sydney"]

func test(a: String) -> String {
    return "Beautiful " + a
}

test(a: cities[0])

let newCities = cities.map(test)

let newCities2 = cities.map { a in
    "Beautiful " + a}
