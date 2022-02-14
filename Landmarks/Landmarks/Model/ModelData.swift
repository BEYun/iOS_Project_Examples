//
//  ModelData.swift
//  Landmarks
//
//  Created by 윤병은 on 2022/02/14.
//

import Foundation

var landmarks: [Landmark] = load("landmarkData.json")

func load<T: Decodable>(_ filename: String) -> T{
    let data: Data
    
    // Bundle.main.url에 filename 매개변수를 이용하여 url을 지닌 file 변수 생성
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    // Data(contentsOf: url) 메서드를 이용하여 data 변수에 url을 NSData 개체로 변환하여 매핑
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    // JSONDecoder() 메서드를 이용하여 파싱한 데이터를 return 값으로 반환
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
