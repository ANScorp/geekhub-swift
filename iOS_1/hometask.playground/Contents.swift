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
    case i3 = "Inline 3 petrol engine"
    case i4 = "Inline 4 petrol engine"
    case v8 = "V8 petrol engine"
    case v8bi = "V8 biturbo petrol engine"
    case v12 = "V12 petrol engine"
    case electric
}

class Engine {
    static let description = "This is a class that represents engine of a car."
    let horsePower: Int
    let maxSpeed: Int
    let engineType: EngineType
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
        if self.transmissionMode == .P || self.transmissionMode == .N {
            self.engine.isOn = true
            return true
        }
        return false
    }
    
    func stopEngine() -> Bool {
        if self.engine.isOn && self.currentKmPerHour == 0 {
            self.engine.isOn = false
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
        if newSpeed >= self.engine.maxSpeed || newSpeed <= self.currentKmPerHour {
            return false
        }
        if !engine.electronicBrake && !self.brakePushed && self.gasPushed && engine.isOn && (transmissionMode == .D || transmissionMode == .R) {
            while self.currentKmPerHour < newSpeed {
                self.currentKmPerHour += 1
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

let newCar = Car(brand: "Mercedes", modelName: "AMG GT63", engineType: .v8, maxSpeed: 315, horsePower: 639)

newCar.startEngine()
newCar.display.showTransmissionMode()

newCar.display.showElectronicBrakeStatus()
newCar.display.showEngineStatus()
newCar.display.showCurrentDrivePresetMode()
newCar.display.showTransmissionMode()
Car.description
Engine.description
newCar.changeTransmissionMode(to: .D)
newCar.display.showTransmissionMode()
newCar.brakePushed = true
newCar.startMovement()
newCar.currentKmPerHour
newCar.gasPushed = true
newCar.increaseSpead(to: 310)
newCar.display.showCurrentSpeed()
newCar.brakePushed = true
newCar.decreaseSpead(to: 199)
newCar.display.showCurrentSpeed()
newCar.startMovement()
newCar.display.showCurrentSpeed()
newCar.stopMovement()
newCar.display.showCurrentSpeed()
newCar.stopEngine()
newCar.display.showEngineStatus()
