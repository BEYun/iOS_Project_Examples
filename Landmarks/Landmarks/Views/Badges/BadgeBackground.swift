//
//  BadgeBackground.swift
//  Landmarks
//
//  Created by 윤병은 on 2022/02/16.
//

import SwiftUI

struct BadgeBackground: View {
    var body: some View {
        // GeometryReader를 사용하면, 앱의 다른 곳이나 다른 크기의 디스플레이에서 뷰를 재사용할 때, 올바른 값이 나올 확률이 있는 하드코딩 대신 위치와 크기를 동적으로 조절
        GeometryReader { geometry in
            // Path에서 .move 프로퍼티는 커서 이동을, .addLine, .addQuadCurve 등은 선, 곡선 등의 작성을 의미
            Path { path in
                var width: CGFloat = min(geometry.size.width, geometry.size.height)
                let height = width
                let xScale: CGFloat = 0.832
                let xOffset = (width * (1.0 - xScale)) / 2.0
                width *= xScale
                
                path.move(
                    to: CGPoint(
                        x: width * 0.95 + xOffset,
                        y: height * (0.20 + HexagonParameters.adjustment)
                    )
                )
                
                // addLine() 메서드를 통해 자동으로 segments 배열의 다음 좌표로 이동하며 도형 생성
                HexagonParameters.segments.forEach { segment in
                    path.addLine(
                        to: CGPoint(
                            x: width * segment.line.x + xOffset,
                            y: height * segment.line.y
                        )
                    )
                    
                    path.addQuadCurve(
                        to: CGPoint(
                            x: width * segment.curve.x + xOffset,
                            y: height * segment.curve.y
                        ),
                        control: CGPoint(
                            x: width * segment.control.x + xOffset,
                            y: height * segment.control.y
                        )
                    )
                }
            }
            .fill(.linearGradient(
                Gradient(colors: [Self.gradientStart, Self.gradientEnd]),
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 0.6)
            ))
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    static let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
    static let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
}

struct BadgeBackground_Previews: PreviewProvider {
    static var previews: some View {
        BadgeBackground()
    }
}
