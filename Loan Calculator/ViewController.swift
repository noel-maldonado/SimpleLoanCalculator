//
//  ViewController.swift
//  Loan Calculator
//
//  Created by Noel Maldonado on 3/4/20.
//  Copyright © 2020 Noel Maldonado. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        configureTapGesture()
        // Do any additional setup after loading the view.
    }
    
    
    var usersName: String = ""
    var loanAmount: Double = 0.0
    var loanYears: Int = 0
    var downPayment: Double = 0.0
    
    func monthsInYears(_ loanYears: Int) -> Int {
        let years = loanYears
        let months = years * 12
        return months
    }
    
    lazy var loanMonths = monthsInYears(loanYears)
    
    let interestRate: Double = 0.0

    func interestPerMonth(_ interestRate: Double) -> Double {
        let interest = interestRate
        let interestPerMonth = ((interest / 100) / 12)
        return interestPerMonth
    }
    
    lazy var interestMonth = interestPerMonth(interestRate)
    
    
    func paymentAmountPerMonth(interestPerYear: Double, loanMonths: Int,
                               loanAmount: Int) -> Double {
        let intPerMonth: Double = interestPerMonth(interestPerYear);
        let months: Double = Double(loanMonths);
        let amount: Double = Double(loanAmount);
        let numerator: Double = (intPerMonth * (pow((1 + intPerMonth), months)))
        let denominator: Double = ((pow(1 + intPerMonth, months)) - 1)
       
        let monthlyPayment = amount * (numerator / denominator)
        return monthlyPayment
    }
    
    
    @IBOutlet weak var userLoanAmount: UITextField!
    @IBOutlet weak var userLoanLength: UITextField!
    @IBOutlet weak var userLoanRate: UITextField!
    @IBOutlet weak var userDownPayment: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    
    private func configureTextFields() {
        userLoanAmount.delegate = self
        userLoanLength.delegate = self
        userLoanRate.delegate = self
        userDownPayment.delegate = self
    }
    
    //configures to hide keyboard when clicked outside of text fields
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        print("Handle tap was called")
        view.endEditing(true)
    }
    
    
    @IBAction func Calculate(_ sender: Any) {
        let rateMonthly = interestPerMonth(Double(userLoanRate.text!)!)
        let amount = Int(userLoanAmount.text!)! - Int(userDownPayment.text!)!
        let months = (Int(userLoanLength.text!)! * 12)
        
        let paymonthly = paymentAmountPerMonth(interestPerYear: rateMonthly, loanMonths: months, loanAmount: amount)
        
        let strmonthly = String(format: "%.2f", paymonthly)
        
        textView.text = "Loan Amount: $\(userLoanAmount.text!)\nLoan Length: \(userLoanLength.text!)\nInterest Rate: \(userLoanRate.text!)%\nDown Payment: $\(userDownPayment.text!)\nMonthly Payment: $\(strmonthly)"
        
    }
    
    
    
    
    
    
    
}

extension ViewController: UITextFieldDelegate {
    //when return is pressed on software keyboard, the keyboard is dismissed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
