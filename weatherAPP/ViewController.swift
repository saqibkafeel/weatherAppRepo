//
//  ViewController.swift
//  weatherAPP
//
//  Created by saqib on 8/25/19.
//  Copyright © 2019 saqib. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ViewController: UIViewController {
    @IBOutlet weak var searchTextfield: UITextField!
    
    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.apicall(cityName: "Karachi")
    }
    func apicall(cityName:String){
        let strURL = "http://api.openweathermap.org/data/2.5/weather"
        let params = ["q":cityName,"APPID":"54c5f16f2f875bbc70a0360b225b5808"]
        
        Alamofire.request( strURL, method:.get, parameters: params).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess {
                let responseJson = JSON(responseObject.result.value!)
                print(responseJson)
                if(responseJson["cod"] == 200){
                    let rainChances = responseJson["clouds"]["all"].int
                    let temperature = responseJson["main"]["temp"].double
                    let name = responseJson["name"]
                    
                    self.placeImage(Chances: rainChances!)
                    self.temperatureLabel.text = "\(temperature!) ºF"
                    self.cityNameLabel.text = "\(name)"
                    
                    
                }else{
                    self.temperatureLabel.text = ""
                    self.cityNameLabel.text = "City Not Found"
                    //self.statusImageView.image = UIImage(named: "")
                    self.statusLabel.text = ""
                }
                
                
            }
            if responseObject.result.isFailure {
                let error : NSError = responseObject.result.error! as NSError
                print(error)
                
            }
        }
    }
    func placeImage(Chances:Int){
        if(Chances >= 0 && Chances <= 20){
            self.statusImageView.image = UIImage(named: "sun")
            self.statusLabel.text = "(sunny)"
        }else if(Chances > 20 && Chances <= 50){
            self.statusImageView.image = UIImage(named: "sunnyCloud")
            self.statusLabel.text = "(sunny With Clouds)"
        }else if(Chances > 50 && Chances <= 75){
            self.statusImageView.image = UIImage(named: "cloudy")
            self.statusLabel.text = "(cloudy)"
        }else if(Chances > 75 && Chances <= 100){
            self.statusImageView.image = UIImage(named: "rain")
            self.statusLabel.text = "(rain)"
        }
    }
    @IBAction func goButtonAction(_ sender: Any) {
        
        self.apicall(cityName: self.searchTextfield.text!)
    }
    func convertToCelsius(fahrenheit: Int) -> Int {
        return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }
}

