//
//  FavoriteButton.swift
//  Landmarks
//
//  Created by 윤병은 on 2022/02/15.
//

import SwiftUI

struct FavoriteButton: View {
    // @Binding을 사용하기에 View 내부에서의 변화가 데이터 원본에 다시 전파됨
    @Binding var isSet: Bool
    
    var body: some View {
        Button {
            isSet.toggle()
        } label: {
            Label("Toggle Favorite", systemImage: isSet ? "star.fill" : "star")
                .labelStyle(.iconOnly)
                .foregroundColor(isSet ? .yellow : .gray)
        }
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteButton(isSet: .constant(true))
    }
}
