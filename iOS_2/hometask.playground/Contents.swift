import Foundation
import PlaygroundSupport

//Домашка:
//
//Створіть такі класи - двигун, автомобіль, дисплей
//Автомобіль - класс через який користувач взаємодіє з двигуном (може керувати швидкістю, включати/включати двигун). Також автомобіль містить інфу про його модель та виводить поточний стан на Дисплей
//Двигун - класс який безпосередньо крутить колеса, керує гальмом. В нього є максимальна швидкість і стан вкл/викл
//Дисплей - це класс який ТІЛЬКИ показує статус автомобіля і двигуна (швидкість, обороти і т. п. )
//
//+ обов'язково
//доповніть кожен клас власними методами і полями (хоча б по одному на клас)

enum EngineType: String {
    static let description = "Engines Database."
    case diesel
    case i3 = "Inline 3 petrol engine"
    case i4 = "Inline 4 petrol engine"
    case v8 = "V8 petrol engine"
    case v8bi = "V8 biturbo petrol engine"
    case v12 = "V12 petrol engine"
    case electric
}

class Engine {
    static let description = "This is a class that represents engine of a car."
    private let horsePower: Int
    private let maxSpeed: Int
    private let engineType: EngineType
    var isOn = false {
        didSet {
            if !isOn && oldValue {
                electronicBrake = true
            }
        }
    }
    var electronicBrake = true
    
    init(maxSpeed: Int, horsePower: Int, engineType: EngineType) {
        self.maxSpeed = maxSpeed
        self.horsePower = horsePower
        self.engineType = engineType
    }
    
    init() {
        self.maxSpeed = 300
        self.horsePower = 400
        self.engineType = .electric
    }
    
    func getMaxSpeed() -> Int {
        return maxSpeed
    }
    
}

class Car {
    static let description = "This is a class that represents a car with automatic transmission and petrol engine."
    let brand: String
    let modelName: String
    var transmissionMode: AutomaticGearBoxMode = .P
    var drivePresetMode: DrivePresetMode = .comfort
    var engine: Engine
    var currentKmPerHour: Int = 0
    lazy var display = Display(carData: self, engineData: engine)
    var brakePushed = false {
        didSet {
            if brakePushed {
                engine.electronicBrake = false
                gasPushed = false
            }
        }
    }
    var gasPushed = false {
        didSet {
            if gasPushed {
                engine.electronicBrake = false
                brakePushed = false
            }
        }
    }
    
    enum AutomaticGearBoxMode: String {
        case R, N, D, P
    }
    
    enum DrivePresetMode: String {
        case eco, comfort, sport, race, drift, manual
    }
    
    init(brand: String, modelName: String, engineType: EngineType, maxSpeed: Int, horsePower: Int) {
        self.brand = brand
        self.modelName = modelName
        self.engine = Engine(maxSpeed: maxSpeed, horsePower: horsePower, engineType: engineType)
    }
    
    init(brand: String, modelName: String) {
        self.brand = brand
        self.modelName = modelName
        self.engine = Engine()
    }
    
    func startEngine() -> Bool {
        if transmissionMode == .P || transmissionMode == .N {
            engine.isOn = true
            return true
        }
        return false
    }
    
    func stopEngine() -> Bool {
        if engine.isOn && currentKmPerHour == 0 {
            engine.isOn = false
            return true
        }
        return false
    }
    
    func changeDrivePresetMode(to drivePresetMode: DrivePresetMode) -> Bool {
        self.drivePresetMode = drivePresetMode
        return true
    }
    
    func changeTransmissionMode(to transmissionMode: AutomaticGearBoxMode) -> Bool {
        self.transmissionMode = transmissionMode
        return true
    }
    
    func startMovement() -> Bool {
        if currentKmPerHour > 0 {
            return false
        }
        if transmissionMode == .D || transmissionMode == .R, brakePushed, engine.isOn, !engine.electronicBrake {
            self.brakePushed = false
            self.currentKmPerHour = 10
            return true
        }
        return false
    }
    
    func increaseSpead(to newSpeed: Int) -> Bool {
        if newSpeed >= engine.getMaxSpeed() || newSpeed <= currentKmPerHour {
            return false
        }
        if !engine.electronicBrake && !brakePushed && gasPushed && engine.isOn && (transmissionMode == .D || transmissionMode == .R) {
            while currentKmPerHour < newSpeed {
                currentKmPerHour += 1
            }
            return true
        }
        return false
    }
    
    func decreaseSpead(to newSpeed: Int) -> Bool {
        if newSpeed >= currentKmPerHour {
            return false
        }
        if !engine.electronicBrake && brakePushed && !gasPushed && engine.isOn && (transmissionMode == .D || transmissionMode == .R) {
            while currentKmPerHour > newSpeed {
                currentKmPerHour -= 1
            }
            return true
        }
        return false
    }
    
    func stopMovement() {
        brakePushed = true
        brakeProcess()
    }
    
    func brakeProcess() {
        while currentKmPerHour > 0 {
            currentKmPerHour -= 1
        }
    }
}

class Display {
    static let description = "This is a class that represents Car's display and provide all information about a car and engine state."
    let carData: Car
    let engineData: Engine
    private var getTransmissionMode: String {
        get {
            carData.transmissionMode.rawValue
        }
    }
    private var getElectronicBrakeStatus: String {
        get {
            engineData.electronicBrake ? "On" : "Off"
        }
    }
    private var getCarBrakeStatus: String {
        get {
            carData.brakePushed ? "On" : "Off"
        }
    }
    private var getEngineStatus: String {
        get {
            engineData.isOn ? "On" : "Off"
        }
    }
    private var getCarGasPedalStatus: String {
        get {
            carData.gasPushed ? "On" : "Off"
        }
    }
    private var getCurrentDriveMode: String {
        get {
            carData.drivePresetMode.rawValue
        }
    }
    private var getCurrentSpeed: Int {
        return carData.currentKmPerHour
    }
    
    init(carData: Car, engineData: Engine) {
        self.carData = carData
        self.engineData = engineData
    }
    
    func showTransmissionMode() {
        print("Current transmission mode is \(getTransmissionMode)")
    }
    
    func showElectronicBrakeStatus() {
        print("Current electronic brake status is \(getElectronicBrakeStatus)")
    }
    
    func showCurrentDrivePresetMode() {
        print("Current drive mode is \(getCurrentDriveMode.capitalized)")
    }
    
    func showEngineStatus() {
        print("Your \(carData.brand)'s Engine is \(getEngineStatus)")
    }
    
    func showCurrentSpeed() {
        print("Current speed is \(getCurrentSpeed) km/h")
    }
    
}

//Inheritance:
//Створіть класс Трактор який наслідується від Автомобіль у якого є додаткове поле Ковш
//Ковш має бути окремим класом із методами вкл/викл і методи для керування ковшом (підняти, повернути, опустити)
//
//Polymorphism:
//Змінити методи вкл/викл у Трактора (цей метод наслідуєтбься від класу Автомобіль) щоб вони включали і виключали окрім Двигуна ще й Ковш
//
//Incapsulation:
//Захистіть поля і методи Двигуна так щоб користувач не знав нічого про Двигун якщо використовує класс Автомобіль
//
//Сlosure:
//Створити аналог функції фільтр (в середині не можна використовувати функції масиву).
//Розібратись і написати пару прикладів map, reduce, sort.

class Tractor: Car {
    var bucket: Bucket
    
    override init(brand: String, modelName: String, engineType: EngineType, maxSpeed: Int, horsePower: Int) {
        self.bucket = Bucket()
        super.init(brand: brand, modelName: modelName, engineType: engineType, maxSpeed: maxSpeed, horsePower: horsePower)
    }
    
    override func startEngine() -> Bool {
        super.startEngine()
        bucket.turnOn()
        return true
    }
    
    override func stopEngine() -> Bool {
        super.stopEngine()
        bucket.turnOff()
        return true
    }
}

class Bucket {
    var isOn = false
    var isRaised = false
    var isLowered = true
    var rotatedDeg = 0
    
    func turnOn() {
        isOn = true
    }
    
    func turnOff() {
        isOn = false
    }
    
    func raise() -> Bool {
        if isOn && !isRaised {
            isLowered = false
            isRaised = true
            return true
        }
        return false
    }
    
    func lower() -> Bool {
        if isOn && !isLowered {
            isRaised = false
            isLowered = true
            return true
        }
        return false
    }
    
    func rotate(to deg: Int) -> Bool {
        if isOn {
            rotatedDeg = deg
            return true
        }
        return false
    }

}

let newTractor = Tractor(brand: "John Deere", modelName: "Evolution", engineType: .diesel, maxSpeed: 100, horsePower: 100)

newTractor.startEngine()
newTractor.display.showEngineStatus()
newTractor.display.showTransmissionMode()
newTractor.bucket.isOn
newTractor.bucket.isRaised
newTractor.bucket.raise()
newTractor.bucket.rotate(to: 30)
newTractor.bucket.isRaised
newTractor.bucket.rotatedDeg
newTractor.stopEngine()
newTractor.display.showEngineStatus()
newTractor.bucket.isOn

let arr = [3, 8, 4, 9, 22, 11, 2]

let greaterThanThree = arr.filter { num in return num > 3 }
print(greaterThanThree)

extension Array {
    func filterNew(_ body: (Element) -> Bool) -> Array {
        var arrOut: Array = []
        for obj in self {
            if body(obj) {
                arrOut += [obj]
            }
        }
        return arrOut
    }
}

let greaterThanThree1 = arr.filterNew({ $0 > 3 })

print(greaterThanThree1)

print([3, 9, 0, -1, 45, -5].map({ $0 > 3 }))
print([3, 9, 0, -1, 45, -5].map({ $0 + 1 }))

print([3, 9, 0, -1, 4, -5].reduce(0, { x, y in x - y }))
print([3, 9, 0, -1, 4, -5].reduce(0, +))
