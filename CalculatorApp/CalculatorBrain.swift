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
    private var stringAccumulator = ""
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private var operations: Dictionary<String,Operation> = [
        "pie" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "∛" : Operation.UnaryOperation({pow($0, 1/3)}),
        "sin" : Operation.UnaryOperation(sin),
        "cos" : Operation.UnaryOperation(cos),
        "tan" : Operation.UnaryOperation(tan),
        "%" : Operation.UnaryOperation({$0/100}),
        "1/x" : Operation.UnaryOperation({1/$0}),
        "±": Operation.UnaryOperation({-$0}),
        "x^2": Operation.UnaryOperation({pow($0, 2)}),
        "x^3": Operation.UnaryOperation({pow($0, 3)}),
        "x!" : Operation.UnaryOperation(factorial),
        "×": Operation.BinaryOperation({ $0 * $1 }),
        "÷": Operation.BinaryOperation({ $0 / $1 }),
        "+": Operation.BinaryOperation({ $0 + $1 }),
        "−": Operation.BinaryOperation({ $0 - $1 }),
        "=": Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    func setDescription(input: String) {
        stringAccumulator += input
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        //makes property read only
        get {
            return accumulator
        }
    }
    var description: String {
        get {
            return stringAccumulator
        }
    }
}
