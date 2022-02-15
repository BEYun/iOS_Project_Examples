//
//  LandmarksApp.swift
//  Landmarks
//
//  Created by 윤병은 on 2022/02/11.
//

import SwiftUI

@main
struct LandmarksApp: App {
    // @StateObject 속성을 사용하여 앱의 라이프 사이클 동안 한 번만 지정된 속성에 대한 모델 개체를 초기화
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
