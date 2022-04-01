//
//  ContentCollectionViewHeader.swift
//  NetflixStyleSampleApp
//
//  Created by 윤병은 on 2022/04/01.
//

import UIKit

// UICollectionReusableView 프로토콜을 준수해야만 Header, Footer가 될 수 있음
class ContentCollectionViewHeader: UICollectionReusableView {
    let sectionNameLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sectionNameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        sectionNameLabel.textColor = .white
        sectionNameLabel.sizeToFit()
        
        addSubview(sectionNameLabel)
        
        sectionNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.bottom.leading.equalToSuperview().offset(10)
        }
    }
}
