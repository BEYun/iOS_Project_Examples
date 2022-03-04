//
//  RoundButton.swift
//  Calculator
//
//  Created by 윤병은 on 2022/03/04.
//

import UIKit

// 버튼들의 모양을 원형으로 변경해주는 커스텀 뷰

// 변경된 속성이 스토리 뷰를 통해 실시간으로 보이게 하는 어노테이션 (많이 사용 시 빌드 성능에 영향)
@IBDesignable
class RoundButton: UIButton {
    // 커스텀 뷰 속성을 스토리보드에서 바로 변경 가능하게 하는 어노테이션
  @IBInspectable var isRound: Bool = false {
    didSet {
      if isRound {
          self.clipsToBounds = true
          self.layer.cornerRadius = self.frame.height / 2
      }
    }
  }
}
