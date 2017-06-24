//
//  ViewController.swift
//  Stanford Calculator
//
//  Created by Diogo M Souza on 2017/05/31.
//  Copyright © 2017 Diogo M Souza. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var acButton: UIButton! //All Clear button. Changes to "C" (clear) when userIsInTheMiddleOfTyping
    @IBOutlet weak var decimalSeparatorButton: UIButton! {
        didSet {
            decimalSeparatorButton.setTitle(decimalSeparator, for: UIControlState())
        }
    }
    
    private var decimalSeparator = formatter.decimalSeparator ?? "."
    private var userIsInTheMiddleOfTyping = false
    private var userIsTypingDoubleValue = false  //flag to avoid numbers with 2 or more dots "."
    private var displayValue : Double {
        get {
            let doubleValue = formatter.number(from: displayLabel.text!)  //convert formatted string to accepted number (e.g "2,34" to "2.34")
            return doubleValue!.doubleValue
        }
        set {
            displayLabel.text = formatter.string(from: newValue as NSNumber)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func touchedDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = displayLabel.text!
            displayLabel.text = textCurrentlyInDisplay + digit
        } else {
            displayLabel.text = digit
            userIsInTheMiddleOfTyping = true
            acButton.setTitle("C", for: .normal)
        }
    }
    
    //Action for when "." is pressed. 
    //"." can only be inserted once per number
    @IBAction func touchedDot(_ sender: UIButton) {
        let dot = sender.currentTitle!
        if !userIsTypingDoubleValue && userIsInTheMiddleOfTyping{
            let textCurrentlyInDisplay = displayLabel.text!
            displayLabel.text = textCurrentlyInDisplay + dot
        } else if !userIsTypingDoubleValue {
            displayLabel.text = "0" + dot
        }
        userIsTypingDoubleValue = true
        userIsInTheMiddleOfTyping = true
        acButton.setTitle("C", for: .normal)
    }
    

    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
            userIsTypingDoubleValue = false
            acButton.setTitle("AC", for: .normal)
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
        if let description = brain.description {
            if brain.resultIsPending {
                descriptionLabel.text = description + " ..."
            } else {
                descriptionLabel.text = description + " ="
            }
        }
    }

    //Reset brain (by reinitializing the CalculatorBrain
    //and clear the display label
    @IBAction func touchedAC(_ sender: UIButton) {
        if !userIsInTheMiddleOfTyping {
            brain = CalculatorBrain()
            descriptionLabel.text = " "
        }
        displayLabel.text = "0"
        userIsInTheMiddleOfTyping = false
        userIsTypingDoubleValue = false
        acButton.setTitle("AC", for: .normal)
    }

}

