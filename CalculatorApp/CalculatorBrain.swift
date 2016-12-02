//
//  CalculatorBrain.swift
//  CalculatorApp
//
//  Created by Blake Robinson on 11/29/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import Foundation

func factorial(operand: Double) -> Double {
    //check if operand is an integer
    if operand.rounded(.towardZero) == operand {
        if operand == 0 || operand == 1 {
            return Double(1)
        } else {
            return operand * factorial(operand: operand-1)
        }
    } else {
        return operand
    }
    
}
class CalculatorBrain {
    
    private var accumulator = 0.0
    private var stringAccumulator = " "
    private var internalProgram = [AnyObject]()
    
    
    func setOperand(operand: Double) {
        accumulator = operand
        stringAccumulator = String(operand)
        internalProgram.append(operand as AnyObject)
    }
    
    private var operations: Dictionary<String,Operation> = [
        "pie" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt, {"√(" + $0 + ")"}),
        "∛" : Operation.UnaryOperation({pow($0, 1/3)}, {"∛(" + $0 + ")"}),
        "sin" : Operation.UnaryOperation(sin, {"sin(" + $0 + ")"}),
        "cos" : Operation.UnaryOperation(cos, {"cos(" + $0 + ")"}),
        "tan" : Operation.UnaryOperation(tan, {"tan(" + $0 + ")"}),
        "%" : Operation.UnaryOperation({$0/100}, {$0 + "%"}),
        "1/x" : Operation.UnaryOperation({1/$0}, {"1/" + $0}),
        "±": Operation.UnaryOperation({-$0}, {"±" + $0}),
        "x^2": Operation.UnaryOperation({pow($0, 2)}, {$0 + "^2"}),
        "x^3": Operation.UnaryOperation({pow($0, 3)}, {$0 + "^3"}),
        "x!" : Operation.UnaryOperation(factorial, {$0 + "!"}),
        "×": Operation.BinaryOperation({ $0 * $1 }, { $0 + "×" + $1}, 1),
        "÷": Operation.BinaryOperation({ $0 / $1 }, { $0 + "÷" + $1}, 1),
        "+": Operation.BinaryOperation({ $0 + $1 }, { $0 + "+" + $1}, 0),
        "−": Operation.BinaryOperation({ $0 - $1 }, { $0 + "−" + $1}, 0),
        "C": Operation.Clear,
        "=": Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double, (String) -> String)
        case BinaryOperation((Double, Double) -> Double, (String, String) -> (String), Int)
        case Clear
        case Equals
    }
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
                stringAccumulator = symbol
            case .UnaryOperation(let function, let descriptionFunction):
                accumulator = function(accumulator)
                stringAccumulator = descriptionFunction(stringAccumulator)
            case .BinaryOperation(let function, let descriptionFunction, let precedence):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator, descriptionFirstOperand: stringAccumulator, descriptionFunction: descriptionFunction)
            case .Clear:
                clear()
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    func addToDescription(input: String) {
        stringAccumulator += " " + input
        //if unary operator on result of binary operator
        //show the binary operation in parentheses after
        //the unary operator
    }
    
    
    
    private func executePendingBinaryOperation() {
        if let newPending = pending {
            accumulator = newPending.binaryFunction(newPending.firstOperand, accumulator)
            stringAccumulator = newPending.descriptionFunction(newPending.descriptionFirstOperand, stringAccumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    private var currentPrecedence = Int.max //initialized to highest integer to give highest precedence by default
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
        var descriptionFirstOperand: String
        var descriptionFunction: (String, String) -> String
        
    }
    
    private var pastBinaryOperation: String = ""
    
    var result: Double {
        //makes property read only
        get {
            return accumulator
        }
    }
    var description: String {
        get {
            if pending == nil {
                return stringAccumulator
            } else {
                let descriptionFirstOperand = pending?.descriptionFirstOperand
                //in most circumstances of a pending binary 
                //operation, the second operand in description
                //will be an empty string because that operand 
                //will not have been entered yet, as is fitting
                // for a pending thing.  This will not be the
                //case when a second operand has been entered and
                //then a unary operation is pressed by the user.
                //in this case the description first operand will
                //not match the stringAccumulator because the 
                //stringAccumulator will represent the
                //second operand.  In these cases, 
                //stringAccumulator via secondOperand needs to be
                //passed into the descriptionFunction.
                var secondOperand = ""
                if descriptionFirstOperand != stringAccumulator {
                    secondOperand = stringAccumulator
                }
                return (pending?.descriptionFunction(descriptionFirstOperand!, secondOperand))!
            }
        }
    }
    //this documents that this is a PropertyList
    typealias PropertyList = AnyObject
//    var program: PropertyList {
//        get {
//            return internalProgram as CalculatorBrain.PropertyList
//        }
//        set {
//            clear()
//            if let array
//        }
//    }
    
    private func clear() {
        accumulator = 0.0
        stringAccumulator = " "
        pending = nil
        internalProgram.removeAll()
    }
    
    var isPartialResult: Bool {
        get {
            return (pending != nil) ? true : false
        }
    }
}
