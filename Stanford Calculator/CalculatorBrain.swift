//
//  CalculatorBrain.swift
//  Stanford Calculator
//
//  Created by Diogo M Souza on 2017/05/31.
//  Copyright © 2017 Diogo M Souza. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    private var accumulator : (value : Double?, text : String?)
    
    var description : String? {
        get {
            if !resultIsPending {
                return accumulator.text
            } else {
                return pendingBinaryOperation!.descriptionFunction(pendingBinaryOperation!.firstDescriptionOperand, accumulator.text ?? "")
            }
        }
    }
    
    var resultIsPending : Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    private enum Operation {
        case rand(() -> Double)
        case constant(Double)
        case unaryOperation((Double) -> Double, (String) -> String)
        case binaryOperation((Double,Double) -> Double, (String, String) -> String)
        case equals
    }
    
    private var operations: Dictionary<String,Operation> = [
        "Rand" : Operation.rand({Double(arc4random())/Double(UInt32.max)}),
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt,   {"√(\($0))"}),
        "±" : Operation.unaryOperation({-$0},  {"-(\($0))"}),
        "x⁻¹":Operation.unaryOperation({1/$0}, {"(\($0))⁻¹"}),
        "cos":Operation.unaryOperation(cos,    {"cos(\($0))"}),
        "sin":Operation.unaryOperation(sin,    {"sin(\($0))"}),
        "tan":Operation.unaryOperation(tan,    {"tan(\($0))"}),
        "x!": Operation.unaryOperation(factorial, {"!(\($0))"}),
        "+" : Operation.binaryOperation(+, {$0 + " + " + $1}),
        "−" : Operation.binaryOperation(-, {$0 + " - " + $1}),
        "×" : Operation.binaryOperation(*, {$0 + " × " + $1}),
        "÷" : Operation.binaryOperation(/, {$0 + " ÷ " + $1}),
        "=" : Operation.equals
    ]
    
    
    
    mutating func performOperation(_ symbol : String) {
        if let operation = operations[symbol] {
            switch operation {
            case .rand(let function):
                let randNumber = function()
                accumulator = (randNumber, "rand(" + formatter.string(from: randNumber as NSNumber)! + ")")
            case .constant(let value):
                accumulator = (value, symbol)
            case .unaryOperation(let (function, description)):
                if accumulator.value != nil {
                    accumulator = (function(accumulator.value!), description(accumulator.text!))
                }
            case .binaryOperation(let (function, descriptionFunction)):
                //if user wants to do multiple operations without pressing "=",
                //calculate previous result first (first 3 lines are same code as "case .equals"):
                performPendingBinaryOperation()
                
                if accumulator.value != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator.value!, descriptionFunction: descriptionFunction, firstDescriptionOperand: accumulator.text!)
                    accumulator = (nil, nil)
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if accumulator.value != nil && pendingBinaryOperation != nil {
            accumulator.value = pendingBinaryOperation!.perform(with: accumulator.value!)
            accumulator.text = pendingBinaryOperation!.performDescription(with: accumulator.text!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation : PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function : (Double,Double) -> Double
        let firstOperand : Double
        let descriptionFunction : (String, String) -> String
        let firstDescriptionOperand : String
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
        
        func performDescription(with secondOperand: String) -> String {
            return descriptionFunction(firstDescriptionOperand, secondOperand)
        }
    }
    
    var result : Double? {
        get {
            return accumulator.value
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = (operand, formatter.string(from: operand as NSNumber))
    }
    
    
}

func factorial(_ number: Double) -> Double {
    var result = 1.0
    var x = number
    while (x > 0) {
        result = result * x
        x = x - 1
    }
    return result
}

let formatter : NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    //formatter.usesSignificantDigits = true
    formatter.maximumFractionDigits = 6
    formatter.notANumberSymbol = "Error"
    formatter.locale = Locale.current
    return formatter
}()
