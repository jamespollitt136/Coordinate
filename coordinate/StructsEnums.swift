//
//  StructsEnums.swift
//  coordinate
//
//  Created by Pollitt James on 28/05/2017.
//  Copyright © 2017 Pollitt James. All rights reserved.
//

import Foundation

enum Operator: String {
    case add = "+"
    case subtract = "-"
    case times = "*"
    case divide = "/"
    case nothing = ""
}

enum CalculationState: String {
    case enteringNum = "enteringNum"
    case newNumStarted = "newNumStarted"
}