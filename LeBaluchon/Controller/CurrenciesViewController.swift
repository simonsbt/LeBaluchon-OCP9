//
//  CurrenciesViewController.swift
//  LeBaluchon
//
//  Created by Simon Sabatier on 24/07/2023.
//

import UIKit

class CurrenciesViewController: UIViewController {
    
    private let currenciesService = CurrenciesService()
    
    private var rate: Double = ((UserDefaults.standard.object(forKey: "USD") ?? 1.00) as! Double)
    
    @IBOutlet weak var currency2Button: UIButton!
    @IBOutlet weak var lastAPICallDateLabel: UILabel!
    
    @IBOutlet weak var baseCurrencyField: UITextField!
    @IBOutlet weak var currency2Field: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let optionsClosure = { (action: UIAction) in
            switch self.currency2Button.title(for: .normal) {
            case "USD":
                self.rate = (UserDefaults.standard.object(forKey: "USD") as! Double)
                self.currency2Field.placeholder = "$"
            case "GBP":
                self.rate = (UserDefaults.standard.object(forKey: "GBP") as! Double)
                self.currency2Field.placeholder = "£"
            case "JPY":
                self.rate = (UserDefaults.standard.object(forKey: "JPY") as! Double)
                self.currency2Field.placeholder = "¥"
            case "CAD":
                self.rate = (UserDefaults.standard.object(forKey: "CAD") as! Double)
                self.currency2Field.placeholder = "$ CA"
            default:
                self.rate = (UserDefaults.standard.object(forKey: "USD") as! Double)
                self.currency2Field.placeholder = "$"
            }
            self.convertCurrencies(sender: self.baseCurrencyField)
        }
        
        var menu2Children: [UIAction] = []
        for currency in currenciesService.currencies {
            menu2Children.append(UIAction(title: currency, state: currency == "USD" ? .on : .off, handler: optionsClosure))
        }
        currency2Button.menu = UIMenu(children: menu2Children)
        
        checkIfAPICalledToday()
    }
    
    private func checkIfAPICalledToday() {
        if let lastAPICallDate = UserDefaults.standard.object(forKey: "lastAPICallDate") as? Date {
            if Calendar.current.isDateInToday(lastAPICallDate) {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .long
                dateFormatter.timeStyle = .medium
                lastAPICallDateLabel.text = "Dernière actualisation : " + dateFormatter.string(from: lastAPICallDate)
                print("API was called today ! (\(dateFormatter.string(from: lastAPICallDate)))")
                
                let currenciesRatesKey = ["USD", "GBP", "JPY", "CAD"]
                for key in currenciesRatesKey {
                    let rate = UserDefaults.standard.double(forKey: key)
                    print("\(rate) for the key \(key)")
                }
                
            } else {
                callAPI()
            }
        } else {
            callAPI()
        }
    }
    
    
    
    private func callAPI() {
        print("Need to call the API today")
        let date = Date()
        UserDefaults.standard.set(date, forKey: "lastAPICallDate")
        currenciesService.getCurrenciesRates()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
        lastAPICallDateLabel.text = "Dernière actualisation : " + dateFormatter.string(from: date)
    }
    
    private func convertCurrencies(sender: UITextField) {
        if let senderText = sender.text {
            let text = senderText.replacingOccurrences(of: ",", with: ".")
            if let value = Double(text) {
                if sender.tag == 1 {
                    print("currency2Field")
                    let convertedValue = value * rate
                    let roundedValue = Double(round(1000 * convertedValue) / 1000)
                    currency2Field.text = String(roundedValue)
                } else {
                    print("baseCurrencyField")
                    let convertedValue = value / rate
                    let roundedValue = Double(round(1000 * convertedValue) / 1000)
                    baseCurrencyField.text = String(roundedValue)
                }
            } else {
                currency2Field.text = ""
                baseCurrencyField.text = ""
            }
        }
    }
    
    
    @IBAction func currency2ValueChanged(_ sender: UITextField) {
        convertCurrencies(sender: sender)
    }
    
    @IBAction func baseCurrencyValueChanged(_ sender: UITextField) {
        convertCurrencies(sender: sender)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
