//
//  WeatherViewController.swift
//  LeBaluchon
//
//  Created by Simon Sabatier on 17/08/2023.
//

import UIKit

class WeatherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        WeatherService.shared.getWeather { (success, weatherResponse) in
            if success, let weatherResponse = weatherResponse {
                print("success")
                print(weatherResponse)
            } else {
                print("error")
            }
        }
        // Do any additional setup after loading the view.
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
