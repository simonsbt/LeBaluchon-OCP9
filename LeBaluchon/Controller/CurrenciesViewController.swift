//
//  CurrenciesViewController.swift
//  LeBaluchon
//
//  Created by Simon Sabatier on 24/07/2023.
//

import UIKit

class CurrenciesViewController: UIViewController {
        
    private var rate: Double = ((UserDefaults.standard.object(forKey: "USD") ?? 1.00) as! Double)
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var containerView1: UIView!
    @IBOutlet weak var containerView2: UIView!
    
    @IBOutlet weak var currency2Button: UIButton!
    @IBOutlet weak var lastAPICallDateLabel: UILabel!
    
    @IBOutlet weak var baseCurrencyField: UITextField!
    @IBOutlet weak var currency2Field: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
        self.showActivityIndicator(show: true)
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
        for currency in CurrenciesService.shared.currencies {
            menu2Children.append(UIAction(title: currency, state: currency == "USD" ? .on : .off, handler: optionsClosure))
        }
        currency2Button.menu = UIMenu(children: menu2Children)
        
        checkIfAPICalledToday()
    }
    
    private func showActivityIndicator(show: Bool) {
        containerView1.isHidden = show
        containerView2.isHidden = show
        activityIndicator.isHidden = !show
    }
    
    private func checkIfAPICalledToday() {
        if let lastAPICallDate = UserDefaults.standard.object(forKey: "lastAPICallDate") as? Date {
            if Calendar.current.isDateInToday(lastAPICallDate) {
                self.refreshLastCallDate()
                self.showActivityIndicator(show: false)
            } else {
                callAPI { success in
                    self.showActivityIndicator(show: !success)
                }
            }
        } else {
            callAPI { success in
                self.showActivityIndicator(show: !success)
            }
        }
    }
    
    private func callAPI(callback: @escaping (Bool) -> Void) {
        print("Need to call the API today")
        CurrenciesService.shared.getCurrenciesRates { (success, currencies) in
            if success, let currencies = currencies {
                currencies.saveCurrenciesRates()
                UserDefaults.standard.set(Date(), forKey: "lastAPICallDate")
                callback(true)
            } else {
                self.presentAlert(title: "Error", message: "Erreur dans la récupération des taux de change")
                callback(false)
            }
            self.refreshLastCallDate()
        }
    }
    
    private func refreshLastCallDate() {
        if let lastAPICallDate = UserDefaults.standard.object(forKey: "lastAPICallDate") as? Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .medium
            lastAPICallDateLabel.text = "Dernière actualisation : " + dateFormatter.string(from: lastAPICallDate)
        } else {
            lastAPICallDateLabel.text = "Dernière actualisation : N/A"
        }
        
    }
    
    private func presentAlert(title: String, message: String) {
          let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
          alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
       present(alertVC, animated: true, completion: nil)
    }
    
    private func convertCurrencies(sender: UITextField) {
        if let text = sender.text?.replacingOccurrences(of: ",", with: ".") {
            if let value = Double(text) {
                if sender.tag == 1 {
                    print("currency2Field")
                    let convertedValue = value * rate
                    let roundedValue = Double(round(100 * convertedValue) / 100)
                    currency2Field.text = String(roundedValue)
                } else {
                    print("baseCurrencyField")
                    let convertedValue = value / rate
                    let roundedValue = Double(round(100 * convertedValue) / 100)
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
