//
//  WeatherInformation.swift
//  Weather
//
//  Created by 윤병은 on 2022/03/19.
//

import Foundation

// Codable 프로토콜을 채택하여 Decodable, Incodable 가능
struct WeatherInformation: Codable {
    let weather: [Weather]
    let temp: Temp
    let name: String
    
    // 서버로부터 받아오는 CodingKey 구현
    enum CodingKeys: String, CodingKey {
        case weather
        case temp = "main"
        case name
    }
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Temp: Codable {
    let temp: Double
    let feelsLike: Double
    let minTemp: Double
    let maxTemp: Double
    
    // 구조체에 서버와 다른 키 값을 지니고 있더라도 열거형으로 CodingKey 프로토콜을 채택하여 서버의 키 값이 구조체와 매핑 가능
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}
