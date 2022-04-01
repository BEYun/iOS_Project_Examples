//
//  ContentCollectionViewCell.swift
//  NetflixStyleSampleApp
//
//  Created by 윤병은 on 2022/04/01.
//

import UIKit
import SnapKit

class ContentCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    
    // 코딩을 통한 레이아웃 설정 (스토리보드를 통해 레이아웃을 설정하는 것과 동일함)
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // contentView라는 기본 객체를 superView로 보고 레이아웃을 적용해야 함
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        
        imageView.contentMode = .scaleToFill
        
        contentView.addSubview(imageView)
        
        // SnapKit을 이용한 오토레이아웃 설정
        imageView.snp.makeConstraints {
            // contentView(SuperView)의 모든 edge에 맞게 설정
            $0.edges.equalToSuperview()
        }
    }
}
