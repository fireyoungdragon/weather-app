import Foundation
import CoreLocation

protocol weatherControlDelegate {
    func didUpdateWeather(_ weatherControl: weatherControl, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct weatherControl {
    let urlWeather = "https://api.openweathermap.org/data/2.5/weather?appid=47eb4dba4f8be9357cce33ffba786fb1&units=metric"
    
    var delegate: weatherControlDelegate?
    
    func getWeather(cityName: String) {
        let urlString = ("\(urlWeather)&q=\(cityName)")
        doRequest(with: urlString)
    }
    
    func getWeather(latitude: CLLocationDegrees, longitude:CLLocationDegrees) {
        let urlString = ("\(urlWeather)&lat=\(latitude)&lon=\(longitude)")
        doRequest(with: urlString)
    }
    
    
    
    func handler(data: Data?, response: URLResponse?, error: Error?) {
        
    }
    
    func doRequest(with urlString: String) {
        //1.create a URl
        if let url = URL(string: urlString){
            //2.create a URLSession
            let session = URLSession(configuration: .default)
            //3.give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let weather = self.JSONparsing(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4.start the task
            task.resume()
        }
    }
    
    func JSONparsing(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodedData.name
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            
            let weather = WeatherModel(cityName: name, temperature: temp, conditionId: id)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

