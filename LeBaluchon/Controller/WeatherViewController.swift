//
//  WeatherViewController.swift
//  LeBaluchon
//
//  Created by Simon Sabatier on 17/08/2023.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet var citiesView: [UIView]!
    @IBOutlet var activityIndicators: [UIActivityIndicatorView]!
    @IBOutlet var citiesNameLabels: [UILabel]!
    @IBOutlet var citiesLocalHourLabels: [UILabel]!
    @IBOutlet var citiesTempLabels: [UILabel]!
    @IBOutlet var citiesWeatherDescriptionLabels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        
        self.navigationController?.isToolbarHidden = false
        var items = [UIBarButtonItem]()
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.loadData))
        )
        toolbarItems = items
    }
    
    private func presentAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func displayWeatherInfos(weatherResponse: WeatherResponse, tag: Int) {
        citiesView[tag].backgroundColor = weatherResponse.getViewColor()
        let temp = weatherResponse.main.temp
        citiesTempLabels[tag].text = String(format: "%.1f", temp) + "°C"
        
        let description = weatherResponse.weather[0].weatherDescription
        citiesWeatherDescriptionLabels[tag].text = description.capitalizingFirstLetter()
        
        if let cityName = weatherResponse.name {
            citiesNameLabels[tag].text = cityName
        }
        citiesLocalHourLabels[tag].text = weatherResponse.getLocalTime()
        
    }
    
    @objc private func loadData() {
        for indicator in activityIndicators {
            indicator.isHidden = false
        }
        let citiesLatLon = WeatherService.shared.citiesLatLon
        if citiesLatLon.count == citiesView.count {
            for (index, element) in citiesLatLon.enumerated() {
                WeatherService.shared.getWeather(cityLatLon: element, callback: { (success, weatherResponse, errorMessage) in
                    if success, let weatherResponse = weatherResponse {
                        self.displayWeatherInfos(weatherResponse: weatherResponse, tag: index)
                    } else {
                        self.presentAlert(title: "Erreur", message: errorMessage ?? "Erreur lors de la récupération des données")
                    }
                    self.activityIndicators[index].isHidden = true
                })
            }
        }
    }
}
