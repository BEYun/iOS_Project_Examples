//
//  LandmarkList.swift
//  Landmarks
//
//  Created by 윤병은 on 2022/02/14.
//

import SwiftUI

struct LandmarkList: View {
    @EnvironmentObject var modelData: ModelData
    
    // View의 @State는 자신 및 하위 View와 관련된 정보를 공유하기에 private로 선언
    @State private var showFavoritesOnly = false
    
    var filteredLandmarks: [Landmark] {
        modelData.landmarks.filter { landmark in
            (!showFavoritesOnly || landmark.isFavorite)
        }
    }
    
    var body: some View {
        // 클로저를 이용한 동적 리스트 할당
        // Landmark 구조체에 Identifiable 프로토콜을 채택하여 Landmark.id 값 없이 List 동적 할당 가능
        NavigationView {
            List {
                // $ 키워드를 통해 상태 변수에 엑세스
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favorites Only")
                }
                
                ForEach(filteredLandmarks) { landmark in
                    NavigationLink {
                        // 결과로 보여질 View (destination)
                        LandmarkDetail(landmark: landmark)
                    } label: {
                        // 현재 보여질 View (label)
                        LandmarkRow(landmark: landmark)
                    }
                }
            }
            .navigationTitle("Landmarks")
        }
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        // environmentObject(_:) 수정자가 부모에 적용된 한 modelData 속성은 자동으로 값을 가져옴
        LandmarkList()
            .environmentObject(ModelData())
    }
}
