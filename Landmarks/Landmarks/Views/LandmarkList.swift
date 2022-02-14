//
//  LandmarkList.swift
//  Landmarks
//
//  Created by 윤병은 on 2022/02/14.
//

import SwiftUI

struct LandmarkList: View {
    var body: some View {
        // 클로저를 이용한 동적 리스트 할당
        // Landmark 구조체에 Identifiable 프로토콜을 채택하여 Landmark.id 값 없이 List 동적 할당 가능
        NavigationView {
            List(landmarks) { landmark in
                NavigationLink {
                    // 결과로 보여질 View (destination)
                    LandmarkDetail(landmark: landmark)
                } label: {
                    // 현재 보여질 View (label)
                    LandmarkRow(landmark: landmark)
                }
            }
            .navigationTitle("Landmarks")
        }
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE (2nd generation)", "iPhone XS Max"], id: \.self) { deviceName in
                    LandmarkList()
                        .previewDevice(PreviewDevice(rawValue: deviceName))
                        .previewDisplayName(deviceName)
                }
    }
}
