//
//  ContentView.swift
//  Landmarks
//
//  Created by 윤병은 on 2022/02/11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LandmarkList()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
