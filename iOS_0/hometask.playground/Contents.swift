import Foundation
import PlaygroundSupport

/*
 1 Use and understand Swift's basic types like Bool, Int, String, and Double
Створіть константи із вказаними значеннями двома способами (явно вказуючи тип і неявно)
Перевірте себе функцією type(of: тут вкажіть назву константи)
а) ціле число 1
b) дійсне число 1.0
с) рядок, що містить фразу Hello world!
d) рядок, що містить фразу The number is та константу з числом 42
e) хибне значення
f) істинне значення
*/

let int1 = 1
type(of: int1)
let int2: Int = 1
type(of: int2)

let d = 1.0
type(of: d)
let dd: Double = 1.0
type(of: dd)

let str1 = "Hello world!"
type(of: str1)
let str2: String = "Hello world!"
type(of: str2)

let num = 42
let si = "The number is " + String(num)
type(of: si)
let sii: String = "The number is " + String(num)
type(of: sii)

let bool1 = false
type(of: bool1)
let bool2: Bool = false
type(of: bool2)

let b2 = true
type(of: b2)
let bb2: Bool = true
type(of: bb2)

/*
 2 Declare and use variables and constants (var let)
a) Зробіть константу цілого типу зі значенням 3
b) Зробіть змінну типу рядок зі значенням "The three is "
c) Змініть значення змінної на таке, що містить раніше створену константу
*/

let num1 = 3

var str = "The three is "

str = String(num1)

/*
 3 Handle flow control and looping constructs (if for while switch)
a) Створіть розгалуження яке до змінної b додасть число 1 якщо b додатнє і відніме - якщо від'ємне
b) Пройдіть циклом по числам від 1 до 10 і виведіть їх (використайте спочатку for потім while)
c) Використайте switch із цілочисельною змінною який виведе фразу "Low" для значень від 1 до 18, "High" для 19-36, "Zero" для 0 та "Unknown" для решти значень
*/

var b: Int = 0
if b > 0 {
    b += 1
} else if b < 0 {
    b -= 1
} else {
    b
}

for index in 1...10 {
    print(index)
}
var i = 0
while i < 10 {
    i += 1
    print(i)
}

let val = 4
switch val {
    case 1...18:
        print("Low")
    case 19...36:
        print("High")
    case 0:
        print("Zero")
    default:
        print("Unknown")
}

/*
4 Create and use collections (Array Set Dictionary)
a) Створіть масив (Array) цілих чисел та посортуйте його
b) Створіть дві множини (Set) цілих чисел та знайдіть їх перетин
с) Створіть Dictionary в якому ключем виступає рядок а значенням будь-який тип і заповніть його
*/

var arr: [Int] = [2, 9, 1, 9, 32, 11]
arr.sort()

var set1: Set = [2, 9, 1, 9, 32, 11]
var set2: Set = [3, 8, 10, 9]
set1.intersection(set2)

var dict = [String: Int]()
for index in 1...10 {
    dict["num" + String(index)] = index
}
print(dict)

/*
 5 Develop and use simple functions ( inout ->  )
а) Створіть функцію яка приймає на вхід масив і віддає найчастіше повторюване значення в ньому
b) Створіть функцію яка приймає на вхід масив і змінює його ж, додаючи до кожного значення 1
*/

func mostRepeated(arr: [Int]) -> String? {
    if arr.isEmpty {
        return nil
    }
    var counts: [Int: Int] = [:]
    for indexArr in 0..<arr.count {
        let item = arr[indexArr]
        if counts[item] != nil {
            counts[item]! += 1
        } else {
            counts[item] = 1
        }
    }
    let resDict = counts.max{a, b in a.value < b.value}
    if let result = resDict {
        return "Result: '\(result.key)' number occures \(result.value) times"
    }
    return nil
}

func addOneToArr(arr: inout [Int]) {
    for index in 0..<arr.count {
        arr[index] += 1
    }
}

var arrIn = [1, 4, 22, 4, 9, 1, 1, 22, 9, 9, 9]

if let str = mostRepeated(arr: arrIn) {
    print(str)
}

addOneToArr(arr: &arrIn)

/*
 6-7 Cast objects safely from one type to another ( as! as? as init). Handle optionals and unwrap them safely (if let ; guard let ; != nil)
Створіть функцію яка приймає на вхід змінну типу Any? і перевіряє тип значення на String, Int, Double, Float та інші базові типи.
Результат виконання функції - рядок з відповідним типом або "Unknown type" якщо визначити тип не вдалось.
(!) Для виконання цього завдання НЕ використовуйте метод type(of: ).
(!!) Для виконання цього завдання МОЖНА використовувати наступні конструкції (спробуйте кожну з них в окремії функції)
a) `if let`
b) switch.
*/

func isTypeIf (param: Any?) -> String {
    let double = param as? Double
    if let result = param as? String {
        return "'\(result)' is String"
    } else if let result = param as? Int {
        return "'\(result)' is Int"
    } else if let result = param as? Float {
        return "'\(result)' is Float"
    } else if let result = double {
        return "'\(result)' is Double"
    } else if let (x, y) = param as? (Double, Double) {
        return "(\(x),\(y)) is Point"
    } else if param == nil {
        return "nil"
    }
    return "Unknown type"
}

func isTypeSwitch (param: Any?) -> String {
    switch param {
        case let value as Double:
            return "'\(value)' is Double"
        case is Int:
            let value = param as! Int
            return "'\(value)' is Int"
        case let value as String:
            return "'\(value)' is String"
        case let value as Float:
            return "'\(value)' is Float"
        case let (x, y) as (Double, Double):
            return "(\(x), \(y)) is Point"
        case nil:
            return "nil"
        default:
            return "Unknown type"
    }
}

isTypeIf(param: Float(2.0))
isTypeSwitch(param: 2.0)
