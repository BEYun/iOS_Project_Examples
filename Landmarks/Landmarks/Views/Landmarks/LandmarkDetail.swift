//
//  LandmarkDetail.swift
//  Landmarks
//
//  Created by 윤병은 on 2022/02/14.
//

import SwiftUI

struct LandmarkDetail: View {
    // LandmarkList와 LandmarkDetail 모두 동일한 ModelData 객체에 접근하므로(EnvironmentObject), 두 View는 일관성을 유지할 수 있음
    @EnvironmentObject var modelData: ModelData
    
    var landmark: Landmark
    
    // modelData의 인덱스 값 계산
    var landmarkIndex: Int {
        modelData.landmarks.firstIndex(where: {$0.id == landmark.id
        })!
    }
    
    var body: some View {
        ScrollView {
            MapView(coordinate: landmark.locationCoordinate)
                .frame(height: 300)
                .ignoresSafeArea(edges: .top)
            
            CircleImage(image: landmark.image)
                .offset(y: -130)
                .padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(landmark.name)
                        .font(.title)
                    // FavoriteButton이 landmarkIndex를 통해 modelData 객체에 저장된 landmark의 isFavorite 속성 업데이트
                    // $를 이용하여 isFavorite 속성에 바인딩 제공
                    FavoriteButton(isSet: $modelData.landmarks[landmarkIndex].isFavorite)
                }
                
                HStack {
                    Text(landmark.park)
                        .font(.subheadline)
                    Spacer()
                    Text(landmark.state)
                        .font(.subheadline)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Divider()
                
                Text("About \(landmark.name)")
                    .font(.title2)
                
                Text(landmark.description)
            }
            .padding()
        }
        .navigationTitle(landmark.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static let modelData = ModelData()
    
    static var previews: some View {
        LandmarkDetail(landmark: modelData.landmarks[0])
            .environmentObject(modelData)
    }
}
