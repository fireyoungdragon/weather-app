import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    
    //API key 47eb4dba4f8be9357cce33ffba786fb1
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var WeatherControl = weatherControl()
    let userLocation = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*userLocation.delegate = self
        userLocation.requestWhenInUseAuthorization()
        userLocation.requestLocation()
         */
        
        WeatherControl.delegate = self
        searchTextField.delegate = self
    }
    
    @IBAction func locationTap(_ sender: UIButton) {
        userLocation.delegate = self
        userLocation.requestWhenInUseAuthorization()
        userLocation.requestLocation()
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchTap(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        } else {
            searchTextField.placeholder = "Type city"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text{
            WeatherControl.getWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - weatherControlDelegate

extension WeatherViewController: weatherControlDelegate {
    
    func didUpdateWeather(_ weatherControl: weatherControl, weather: WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImage.image = UIImage(systemName: weather.conditionType)
            self.cityLabel.text = weather.cityName
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            userLocation.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            WeatherControl.getWeather(latitude: lat, longitude: lon)
        }
        print("get location data")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
