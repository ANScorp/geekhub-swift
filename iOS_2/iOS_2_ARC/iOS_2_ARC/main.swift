//
//  main.swift
//  iOS_2_ARC
//
//  Created by Alex on 11/3/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import Foundation

//ARC:
//
//1*. Створіть retain cycle використовуючи тільки один клас.
//2. Створіть retain cycle для об’єктів трьох різних класів. В вас має бути 3 класи, в кожному класі може бути тільки одна проперті, тип цієї проперті не може бути таким же як клас де вона об’явлена.
//3. Пофіксіть створені retain cycle

class One {
    //retain cycle fix
    weak var a: One?
    
    init() {
        print("Instance of One is being initialized.")
    }
    
    deinit {
        print("One: \(#function)")
    }
}

var one: One? = One() // One = 1
var anotherOne: One? = one // One = 2

//retain cycle
one?.a = anotherOne // One = 3
anotherOne?.a = one // One = 4
one = nil // One = 3
anotherOne = nil // One = 2


class A {
    //retain cycle fix
    weak var prop: B?
    
    init() {
        print("Instance of A is being initialized.")
    }
    
    deinit {
        print("A: \(#function)")
    }
}

class B {
    //retain cycle fix
    weak var prop: C?
    
    init() {
        print("Instance of B is being initialized.")
    }
    
    deinit {
        print("B: \(#function)")
    }
}

class C {
    //retain cycle fix
    weak var prop: A?
    
    init() {
        print("Instance of C is being initialized.")
    }
    
    deinit {
        print("C: \(#function)")
    }
}

var a1: A? = A() // A = 1
var b1: B? = B() // B = 1
var c1: C? = C() // C = 1

a1!.prop = b1 // A = 1; B = 2; C = 1
b1!.prop = c1 // A = 1; B = 2; C = 2
c1!.prop = a1 // A = 2; B = 2; C = 2

a1 = nil // A = 1; B = 2; C = 2
b1 = nil // A = 1; B = 1; C = 2
c1 = nil // A = 1; B = 1; C = 1

