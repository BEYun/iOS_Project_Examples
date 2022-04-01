//
//  UIButton.swift
//  NetflixStyleSampleApp
//
//  Created by 윤병은 on 2022/04/01.
//

import UIKit

// plusButton과 infoButton의 아이콘이 수직으로 정렬되도록 하는 메소드 구현
extension UIButton {
    func adjustVerticalLayout(_ spacing: CGFloat = 0) {
        let imageSize = self.imageView?.frame.size ?? .zero
        let titleLabelSize = self.titleLabel?.frame.size ?? .zero
        
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0)
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleLabelSize.height + spacing), left: 0, bottom: 0, right: -titleLabelSize.width)
    }
}
