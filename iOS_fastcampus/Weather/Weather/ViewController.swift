//
//  ViewController.swift
//  Weather
//
//  Created by 윤병은 on 2022/03/19.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var cityNameTextField: UITextField!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var weatherStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapFetchWeatherButton(_ sender: UIButton) {
        if let cityName = self.cityNameTextField.text {
            self.getCurrentWeather(cityName: cityName)
            // 버튼이 눌리면 키보드가 사라지는 메소드
            self.view.endEditing(true)
        }
    }
    
    // WeatherInformation 객체의 내용을 매핑하는 메소드
    func configureView(weatherInformation: WeatherInformation) {
        self.cityNameLabel.text = weatherInformation.name
        // weather 배열의 첫번째 요소를 대입
        if let weather = weatherInformation.weather.first {
            self.weatherDescriptionLabel.text = weather.description
        }
        self.tempLabel.text = "\(Int(weatherInformation.temp.temp - 273.15))°C"
        self.minTempLabel.text = "최저 : \(Int(weatherInformation.temp.minTemp - 273.15))°C"
        self.maxTempLabel.text = "최고 : \(Int(weatherInformation.temp.maxTemp - 273.15))°C"
    }
    
    // 에러 발생 시, 에러의 내용이 표시되는 Alert UI 메소드
    func showAlert(message: String) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // cityName 파라미터에 따른 현재 위치의 날씨를 가져오는 메소드
    func getCurrentWeather(cityName: String) {
        guard let url = URL(string:
            "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=846b51159f649da6fa5ab65d49c8fc1f") else { return }
        let session = URLSession(configuration: .default)
        // completion Handler 클로저 정의
        // data 파라미터는 서버에서 응답받은 데이터가 전달, response 파라미터는 http 헤더 및 상태 응답 코드가 전달, error 객체는 요청 실패 시 에러 객체 전달
        session.dataTask(with: url) { [weak self] data, response, error in
            // response의 헤더 코드가 200번대라면, 응답받은 객체를 WeatherInformatin 객체로 디코딩, 그렇지 않으면 ErrorMessage 객체로 디코딩
            let successRange = (200..<300)
            guard let data = data, error == nil else { return }
            let decorder = JSONDecoder()
            // 응답받은 response를 HTTPURLResponse로 다운캐스팅 후, statusCode가 successRange에 있는지 확인
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                // decode 메소드의 첫 번째 파라미터는 매핑시켜 줄 Codable 프로토콜을 준수하는 사용자 정의 타입, 두 번째 파라미터는 서버에서 응답받은 데이터를 전달
                // 실패하면 error를 던져주기 때문에 try? 키워드 사용
                guard let weatherInformation = try? decorder.decode(WeatherInformation.self, from: data) else { return }
                // 네트워크 작업은 별도의 스레드에서 진행을 하고 응답이 와도 자동으로 메인 스레드로 돌아오지 않기에 UI 작업을 메인 스레드에서 진행할 수 있도록 설정
                DispatchQueue.main.async {
                    self?.weatherStackView.isHidden = false
                    self?.configureView(weatherInformation: weatherInformation)
                }
            } else {
                guard let errorMessage = try? decorder.decode(ErrorMessage.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
            }

        }.resume()
    }
}

