//
//  TranslateViewController.swift
//  LeBaluchon
//
//  Created by Simon Sabatier on 27/07/2023.
//

import UIKit

class TranslateViewController: UIViewController {
    
    @IBOutlet weak var targetLanguageButton: UIButton!
    
    @IBOutlet weak var sourceLanguageLabel: UILabel!
    
    @IBOutlet weak var translateButton: UIButton!

    @IBOutlet weak var sourceTextView: UITextView!
    @IBOutlet weak var targetTextView: UITextView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// TapGestureRecognizer to dismiss the keyboard when tapping outside UITextView.
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        self.showActivityIndicator(show: false)
        
        /// Executed when the language target is changed, handled by each item of the menu.
        let targetOptionsClosure = { (action: UIAction) in
            switch self.targetLanguageButton.title(for: .normal) {
            case "English":
                TranslateService.shared.targetLanguage = "en"
            case "Français":
                TranslateService.shared.targetLanguage = "fr"
            case "Spanish":
                TranslateService.shared.targetLanguage = "es"
            case "Japanese":
                TranslateService.shared.targetLanguage = "ja"
            default:
                TranslateService.shared.targetLanguage = "en"
            }
        }
        
        /// Creates items corresponding to languages to add them in the menu.
        var targetLanguagesChildren: [UIAction] = []
        for language in TranslateService.shared.languages {
            targetLanguagesChildren.append(UIAction(title: language, state: language == "English" ? .on : .off, handler: targetOptionsClosure))
        }
        targetLanguageButton.menu = UIMenu(children: targetLanguagesChildren)
    }
    
    @IBAction func translateButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        if let text = sourceTextView.text, sourceTextView.text.count >= 1 {
            showActivityIndicator(show: true)
            TranslateService.shared.expressionToTranslate = text // Save the expression to translate.
            detectLanguage()
        } else {
            self.presentAlert(title: "Erreur", message: "Erreur lors de la récupération du texte.")
        }
    }
    
    private func translate() {
        TranslateService.shared.getTranslation { (success, translation, errorMessage) in
            if success, let translation = translation {
                self.targetTextView.text = translation // Display the translation.
            } else {
                if let errorMessage = errorMessage {
                    self.presentAlert(title: "Erreur", message: errorMessage)
                } else {
                    self.presentAlert(title: "Erreur", message: "Erreur lors de la traduction.")
                }
            }
        }
    }
    
    /// Executed when the translateButton is tapped.
    private func detectLanguage() {
        TranslateService.shared.detectLanguage { (success, detectedLanguage, errorMessage) in
            if success, let detectedLanguage = detectedLanguage {
                if let language = Locale.current.localizedString(forLanguageCode: detectedLanguage) {
                    self.sourceLanguageLabel.text = "Détecter la langue : \(language)"
                }
                /// Translate an expression from a language to the same language doesn't work in this API
                if detectedLanguage == TranslateService.shared.targetLanguage {
                    self.targetTextView.text = TranslateService.shared.expressionToTranslate // Translate API can't traduce to a target language that is the same as the source language
                } else {
                    TranslateService.shared.sourceLanguage = detectedLanguage
                    self.translate()
                }
            } else {
                if let errorMessage = errorMessage {
                    self.presentAlert(title: "Erreur", message: errorMessage)
                } else {
                    self.presentAlert(title: "Erreur", message: "Erreur lors de la traduction.")
                }
                
            }
            self.showActivityIndicator(show: false)
        }
    }

    /// Used to hide/show the UIAtivityIndicatorView and the UITextFields.
    private func showActivityIndicator(show: Bool) {
        translateButton.isHidden = show
        activityIndicator.isHidden = !show
    }

    /// Present an UIAlertController with a custom title and message.
    private func presentAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
