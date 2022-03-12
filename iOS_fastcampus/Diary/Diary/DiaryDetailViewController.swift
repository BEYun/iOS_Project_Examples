//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 윤병은 on 2022/03/10.
//

import UIKit

protocol DiaryDetailViewDelegate: AnyObject {
    func didSelectDelete(indexPath: IndexPath)
}

class DiaryDetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsLabel: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    weak var delegate: DiaryDetailViewDelegate?
    
    var diary: Diary?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    // 프로퍼티를 통해 전달받은 객체를 뷰에 초기화
    private func configureView() {
        guard let diary = self.diary else { return }
        self.titleLabel.text = diary.title
        self.contentsLabel.text = diary.contents
        self.dateLabel.text = self.dateToString(date: diary.date)
    }
    
    // Date 타입을 전달받으면 문자열로 반환해주는 메소드
    private func dateToString(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    // 수정된 Diary 객체를 전달 받아 뷰에 업데이트하는 셀렉터
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        self.diary = diary
        // 수정된 값으로 뷰 업데이트
        self.configureView()
    }
    
    // 수정 버튼을 클릭 시,
    // 1) WriteDiaryViewController 뷰에 현재 indexPath와 diary 인스턴스, diaryEditorMode를 지닌 상태로 푸쉬
    // 2) WriteDiaryViewController 뷰에 Observer를 추가하여 수정되는 값 관찰
    @IBAction func tapEditButton(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WriteDiaryViewController") as? WriteDiaryViewController else { return }
        guard let indexPath = self.indexPath else { return }
        guard let diary = self.diary else { return }
        // 수정 버튼을 눌렀을 때, diaryEditorMode가 .edit으로 변경되고 연관 값으로 indexPath와 diary값을 지니게 됨
        viewController.diaryEditorMode = .edit(indexPath, diary)
        // 특정 이름의 NotificationCenter를 계속 관찰하며 특정 이벤트가 발생 시, selector 파라미터에 정의된 함수를 수행
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editDiaryNotification(_:)),
            name: NSNotification.Name("editDiary"),
            object: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        guard let indexPath = self.indexPath else { return }
        self.delegate?.didSelectDelete(indexPath: indexPath)
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        // 해당 인스턴스에 추가된 observer 제거
        NotificationCenter.default.removeObserver(self)
    }
    
}
