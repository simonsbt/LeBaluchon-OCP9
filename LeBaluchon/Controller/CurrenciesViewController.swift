//
//  CurrenciesViewController.swift
//  LeBaluchon
//
//  Created by Simon Sabatier on 24/07/2023.
//

import UIKit

class CurrenciesViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var containerView1: UIView!
    @IBOutlet weak var containerView2: UIView!
    
    @IBOutlet weak var targetCurrencyButton: UIButton!

    @IBOutlet weak var lastAPICallDateLabel: UILabel!
    
    @IBOutlet weak var baseCurrencyField: UITextField!
    @IBOutlet weak var targetCurrencyField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// TapGestureRecognizer to dismiss the keyboard when tapping outside UITextField.
        let tap = UITapGestureRecognizer(target: view, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.showActivityIndicator(show: true)

        /// Executed when the currency target is changed, handled by each item of the menu
        let optionsClosure = { (action: UIAction) in
            switch self.targetCurrencyButton.title(for: .normal) {
            case "USD":
                CurrenciesService.shared.rate = (UserDefaults.standard.object(forKey: "USD") as! Double)
                self.targetCurrencyField.placeholder = "$"
            case "GBP":
                CurrenciesService.shared.rate = (UserDefaults.standard.object(forKey: "GBP") as! Double)
                self.targetCurrencyField.placeholder = "£"
            case "JPY":
                CurrenciesService.shared.rate = (UserDefaults.standard.object(forKey: "JPY") as! Double)
                self.targetCurrencyField.placeholder = "¥"
            case "CAD":
                CurrenciesService.shared.rate = (UserDefaults.standard.object(forKey: "CAD") as! Double)
                self.targetCurrencyField.placeholder = "$ CA"
            default:
                CurrenciesService.shared.rate = (UserDefaults.standard.object(forKey: "USD") as! Double)
                self.targetCurrencyField.placeholder = "$"
            }
            self.convertCurrencies(sender: self.baseCurrencyField)
        }
        
        /// Creates items corresponding to currencies to add them in the menu
        var menu2Children: [UIAction] = []
        for currency in CurrenciesService.shared.currencies {
            menu2Children.append(UIAction(title: currency, state: currency == "USD" ? .on : .off, handler: optionsClosure))
        }
        targetCurrencyButton.menu = UIMenu(children: menu2Children)
        
        CurrenciesService.shared.callAPI { success in
            if !success {
                self.presentAlert(title: "Erreur", message: "Erreur dans la récupération des taux de change.")
            }
            self.refreshLastCallDate()   
            self.showActivityIndicator(show: false)
            if let rate = (UserDefaults.standard.object(forKey: "USD") ?? 1.00) as? Double {
                CurrenciesService.shared.rate = rate
            }
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
                // Call model's func with value and tag, returning roundedValue as Double
                let convertedStringValue = CurrenciesService.shared.convertValue()
                sender.text = convertedStringValue
                /*if sender.tag == 1 {
                    targetCurrencyField.text = String(convertedStringValue)
                } else {
                    baseCurrencyField.text = String(roundedValue)
                }*/
            } else { // Executed when the value entered cannot be converted to Double type
                if text.count >= 1 {
                    self.presentAlert(title: "Erreur", message: "Erreur lors de la conversion.")
                }
                targetCurrencyField.text = ""
                baseCurrencyField.text = ""
            }
        } else {
            self.presentAlert(title: "Erreur", message: "Erreur lors de la lecture des données.")
        }
    }
    
    // TODO: Rename currency2ValueChanged to targetCurrencyValueChanged

    @IBAction func targetCurrencyValueChanged(_ sender: UITextField) {
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

    /// Used to dismiss the keyboard
    @objc private func dismissKeyboard() {
        baseCurrencyField.resignFirstResponder()
        targetCurrencyField.resignFirstResponder()
    }
}
