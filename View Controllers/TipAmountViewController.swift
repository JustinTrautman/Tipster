//
//  ViewController.swift
//  Tipster
//
//  Created by Justin Trautman on 6/18/18.
//  Copyright © 2018 Justin Trautman. All rights reserved.
//

import UIKit

class TipAmountViewController: UIViewController {
    
    // MARK: Properties
    let defaultFont = "HelveticaNeue-UltraLight"
    let defaultTextColor:UIColor = .black
    var tipPercentageSelected = 0
    var billTotal: Double = 0.0
    var tip: Double = 0.0
    var tipLabel = UILabel()
    var totalLabel = UILabel()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // MARK: - Programmatic view setup        
        let tipPercentage = UILabel(frame: CGRect(x: view.frame.midX - (view.frame.width * 0.98 * 0.5), y: view.frame.midY - (view.frame.height * 0.45), width: view.frame.width, height: view.frame.height * 0.25))
        tipPercentage.textAlignment = .center
        tipPercentage.adjustsFontSizeToFitWidth = true
        tipPercentage.font = UIFont(name: defaultFont, size: 32)
        tipPercentage.text = "Tip Percentage"
        tipPercentage.textColor = defaultTextColor
        view.addSubview(tipPercentage)
        
        // MARK: - Tip Selector SegmentedControl
    
        let tipSelector = UISegmentedControl(frame: CGRect(x: view.frame.midX - (view.frame.width * 0.4), y: view.frame.midY - (view.frame.height * 0.28), width: view.frame.width * 0.8, height: view.frame.height * 0.15))
        
        tipSelector.insertSegment(withTitle: "10%", at: 0, animated: true)
        tipSelector.insertSegment(withTitle: "15%", at: 1, animated: true)
        tipSelector.insertSegment(withTitle: "20%", at: 2, animated: true)
        tipSelector.insertSegment(withTitle: "25%", at: 3, animated: true)
        tipSelector.insertSegment(withTitle: "Custom", at: 4, animated: true)
        tipSelector.addTarget(self, action: #selector(selectTipPercentage), for: .valueChanged)
        view.addSubview(tipSelector)
        
        // Bill Total Label
        let billTotal = UILabel(frame: CGRect(x: view.frame.midX - (view.frame.width * 0.98 * 0.4), y: view.frame.midY - (view.frame.height * 0.2), width: view.frame.width * 0.75, height: view.frame.height * 0.20))
        billTotal.textAlignment = .center
        billTotal.adjustsFontSizeToFitWidth = true
        billTotal.font = UIFont(name: defaultFont, size: 20)
        billTotal.text = "Bill Total"
        billTotal.textColor = defaultTextColor
        view.addSubview(billTotal)
        
        // Total without tip label
        let total = UITextField(frame: CGRect(x: view.frame.midX - (view.frame.width * 0.25), y: view.frame.midY - (view.frame.height * 0.05), width: view.frame.width * 0.5, height: view.frame.height * 0.05))
        total.textAlignment = .center
        total.keyboardType = .decimalPad
        total.placeholder = "0.00"
        total.font = UIFont(name: defaultFont, size: 18)
        total.textColor = defaultTextColor
        total.layer.borderColor = UIColor.black.cgColor
        total.addTarget(self, action: #selector(setTotal), for: .allEditingEvents)
        view.addSubview(total)
        
        // Add "$" Sign
        let dollarSign = UILabel(frame: CGRect(x: view.frame.midX - total.frame.width * 0.6, y: view.frame.midY - (view.frame.height * 0.05), width: view.frame.width * 0.2, height: view.frame.height * 0.05))
        dollarSign.font = UIFont(name: defaultFont, size: 18)
        dollarSign.textAlignment = .center
        dollarSign.text = "$"
        view.addSubview(dollarSign)
        
        // Tip Amount Label
        let tipAmount = UILabel(frame: CGRect(x: view.frame.midX - (view.frame.width * 0.75 * 0.5), y: view.frame.midY + (view.frame.height * 0.075), width: view.frame.width * 0.75, height: view.frame.height * 0.10))
        tipAmount.textAlignment = .center
        tipAmount.adjustsFontSizeToFitWidth = true
        total.font = UIFont(name: defaultFont, size: 32)
        tipAmount.text = "Tip Amount"
        view.addSubview(tipAmount)
        
        // Total with tip label
        let totalWithTip = UILabel(frame: CGRect(x: view.frame.midX - (view.frame.width * 0.75 * 0.5), y: view.frame.midY + (view.frame.height * 0.25), width: view.frame.width * 0.75, height: view.frame.height * 0.10))
        totalWithTip.textAlignment = .center
        totalWithTip.adjustsFontSizeToFitWidth = true
        totalWithTip.font = UIFont(name: defaultFont, size: 32)
        totalWithTip.text = "Total with Tip"
        totalWithTip.textColor = defaultTextColor
        view.addSubview(totalWithTip)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        resignFirstResponder()
    }
    
    @objc func selectTipPercentage(sender: UISegmentedControl) {
        let percentageString = sender.titleForSegment(at: sender.selectedSegmentIndex)
        let percentage = percentageString?.replacingOccurrences(of: "%", with: "")
        if let tipString = percentage {
            if let tip = Int(tipString) {
                tipPercentageSelected = tip
            }
        }
        
        if billTotal != 0 {
            calculateTip()
        }
            dismissKeyboard()
        }
    
    @objc func setTotal(sender: UITextView) {
        if let input = sender.text {
            if let total = Double(input) {
                billTotal = total
            }
        }
        if (tipPercentageSelected != 0) {
           calculateTip()
        }
    }
    
    func calculateTip() {
        tipLabel.removeFromSuperview()
        tipLabel = UILabel(frame: CGRect(x: view.frame.midX - (view.frame.width * 0.75 * 0.5), y: view.frame.midY + (view.frame.height * 0.075), width: view.frame.width * 0.75, height: view.frame.height * 0.25))
        tip = Double(tipPercentageSelected) * 0.01 * billTotal
        let tenPercent = tip * 10
        if tenPercent.remainder(dividingBy: 1) == 0 || tenPercent.remainder(dividingBy: 1) >= 0.99 {
            // Treat the result as a decimal
            tipLabel.text = "$ " + String(format: "%.2f", tip)
        } else {
            tipLabel.text = "$ " + String(format: "%.2f", tip)
        }
        tipLabel.font = UIFont(name: defaultFont, size: 48)
        tipLabel.textAlignment = .center
        view.addSubview(tipLabel)
        
        totalLabel.removeFromSuperview()
        totalLabel = UILabel(frame: CGRect(x: view.frame.midX - (view.frame.width * 0.75 * 0.5), y: view.frame.midY + (view.frame.height * 0.25), width: view.frame.width * 0.75, height: view.frame.height * 0.25))
        let total = (tip + billTotal)
        let tenTotal = total * 10
        if tenTotal.remainder(dividingBy: 1) == 0 {
            totalLabel.text = "$ " + String(format: "%.2f", total)
        } else {
            totalLabel.text = "$ " + String(format: "%.2f", total)
        }
        totalLabel.font = UIFont(name: defaultFont, size: 48)
        totalLabel.textAlignment = .center
        view.addSubview(totalLabel)
    }
}
