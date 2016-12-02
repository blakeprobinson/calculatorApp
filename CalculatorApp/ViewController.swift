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
    @IBOutlet weak var descriptionDisplay: UILabel!
    
    private var userIsInTheMiddleOfTypingDigits = false
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        let textCurrentlyInDisplay = display.text!
        
        if digit == "." && textCurrentlyInDisplay.range(of: ".") != nil {

        } else if userIsInTheMiddleOfTypingDigits {
            display.text = textCurrentlyInDisplay + digit
            //brain.addToDescription(input: digit)
        } else {
            display.text = digit
            if brain.isPartialResult {
                //brain.addToDescription(input: digit)
            } else {
                //brain.description = digit
            }
            
        }
        userIsInTheMiddleOfTypingDigits = true
        
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var descriptionDisplayValue: String {
        get {
            return descriptionDisplay.text!
        }
        set {
            if brain.isPartialResult {
                descriptionDisplay.text = newValue + " ..."
            } else if userIsInTheMiddleOfTypingDigits || newValue == " " {
                descriptionDisplay.text = newValue
            } else {
                descriptionDisplay.text = newValue + " ="
            }
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTypingDigits {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTypingDigits = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)
        }
        displayValue = brain.result
        descriptionDisplayValue = brain.description
    }


}

