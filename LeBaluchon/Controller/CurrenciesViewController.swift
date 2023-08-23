//
//  CurrenciesViewController.swift
//  LeBaluchon
//
//  Created by Simon Sabatier on 24/07/2023.
//

import UIKit

class CurrenciesViewController: UIViewController {
    
    // TODO: rename currency2Field to targetCurrencyField and currency2Button to targetCurrencyButton

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
        
        /// TapGestureRecognizer to dismiss the keyboard when tapping outside UITextField.
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        self.showActivityIndicator(show: true)

        /// Executed when the currency target is changed, handled by each item of the menu
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
        
        /// Creates items corresponding to currencies to add them in the menu
        var menu2Children: [UIAction] = []
        for currency in CurrenciesService.shared.currencies {
            menu2Children.append(UIAction(title: currency, state: currency == "USD" ? .on : .off, handler: optionsClosure))
        }
        currency2Button.menu = UIMenu(children: menu2Children)
        
        CurrenciesService.shared.callAPI { success in
            if !success {
                self.presentAlert(title: "Error", message: "Erreur dans la récupération des taux de change")
            }
            self.refreshLastCallDate()   
            self.showActivityIndicator(show: false)
        }
    }
    
    /// Update the UILabel with the date of the last API call.
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
    
    /// Convert the value entered in the sender to the target currency.
    private func convertCurrencies(sender: UITextField) {
        if let text = sender.text?.replacingOccurrences(of: ",", with: ".") {
            if let value = Double(text) {
                if sender.tag == 1 {
                    let convertedValue = value * rate
                    let roundedValue = Double(round(100 * convertedValue) / 100) // Round the value to 2 decimals
                    currency2Field.text = String(roundedValue)
                } else {
                    let convertedValue = value / rate
                    let roundedValue = Double(round(100 * convertedValue) / 100) // Round the value to 2 decimals
                    baseCurrencyField.text = String(roundedValue)
                }
            } else { // Executed when the value entered cannot be converted to Double type
                self.presentAlert(title: "Error", message: "Erreur lors de la conversion")
                currency2Field.text = ""
                baseCurrencyField.text = ""
            }
        }
        self.presentAlert(title: "Error", message: "Erreur lors de la lecture des données")
    }
    
    // TODO: Rename currency2ValueChanged to targetCurrencyValueChanged

    @IBAction func currency2ValueChanged(_ sender: UITextField) {
        convertCurrencies(sender: sender)
    }
    
    @IBAction func baseCurrencyValueChanged(_ sender: UITextField) {
        convertCurrencies(sender: sender)
    }

    /// Used to hide/show the UIAtivityIndicatorView and the UITextFields.
    private func showActivityIndicator(show: Bool) {
        containerView1.isHidden = show
        containerView2.isHidden = show
        activityIndicator.isHidden = !show
    }
    
    /// Present an UIAlertController with a custom title and message.
    private func presentAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
