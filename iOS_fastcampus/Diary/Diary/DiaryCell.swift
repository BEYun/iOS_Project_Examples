//
//  DiaryCell.swift
//  Diary
//
//  Created by 윤병은 on 2022/03/10.
//

import UIKit

class DiaryCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    // 스토리보드가 생성될 때 이 생성자를 통해 초기화 되도록 함
    // 즉, 아래 조건에 해당되는 셀이 생성됨
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
    }
}
