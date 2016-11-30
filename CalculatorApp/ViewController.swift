//
//  ViewController.swift
//  CalculatorApp
//
//  Created by Blake Robinson on 11/19/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        let textCurrentlyInDisplay = display.text!
        
        if digit == "." && textCurrentlyInDisplay.range(of: ".") != nil {

        } else if userIsInTheMiddleOfTyping {
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
        brain.setDescription(input: digit)
        
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)
            if mathematicalSymbol != "=" {
                brain.setDescription(input: mathematicalSymbol)
            }
        }
        displayValue = brain.result
        print(brain.description)
        print(brain.isPartialResult)
    }


}

