//
//  Employee.swift
//  ReactiveCocoa
//
//  Created by  on 3/3/17.
//  Copyright © 2017 801kz. All rights reserved.
//

import Foundation

class Employee {
    var name: String
    var gender: Int
    var salary: String
    
    init(_ name: String, _ gender: Int, _ salary: String) {
        self.name = name
        self.gender = gender
        self.salary = salary
    }
}
