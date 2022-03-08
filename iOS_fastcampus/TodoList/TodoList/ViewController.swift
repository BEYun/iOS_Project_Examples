//
//  ViewController.swift
//  TodoList
//
//  Created by 윤병은 on 2022/03/08.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    // done 버튼으로도 활용하기 위해 strong 참조
    @IBOutlet var editButton: UIBarButtonItem!
    var doneButton: UIBarButtonItem?
    
    var tasks = [Task]() {
        // tasks 배열에 할 일이 추가될 때마다 saveTasks() 메소드를 호출하여 할 일을 저장하는 프로퍼티 옵져버 작성
        didSet {
            self.saveTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTap))
        // 저장되어 있는 할 일을 테이블 뷰에 표시
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // 저장된 할 일들을 불러오기
        self.loadTasks()
    }
    
    @objc func doneButtonTap() {
        // 편집모드로 전환 해제
        self.navigationItem.leftBarButtonItem = self.editButton
        self.tableView.setEditing(false, animated: true)
    }
    
    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        guard !self.tasks.isEmpty else { return }
        // 편집모드로 전환
        self.navigationItem.leftBarButtonItem = self.doneButton
        self.tableView.setEditing(true, animated: true)
    }

    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "할 일 등록", message: nil, preferredStyle: .alert)
        
        // 강한 순환 참조를 방지하기 위한 weak self 키워드 사용
        let registerButton = UIAlertAction(title: "등록", style: .default, handler: { [weak self] _ in
            guard let title = alert.textFields?[0].text else { return }
            let task = Task(title: title, done: false)
            self?.tasks.append(task)
            self?.tableView.reloadData()
        })
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        alert.addAction(registerButton)
        alert.addTextField(configurationHandler: { textfield in
            textfield.placeholder = "할 일을 입력해주세요."
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveTasks() {
        // 데이터를 딕셔너리 형태로 저장
        let data = self.tasks.map {
            [
                "title": $0.title,
                "done": $0.done
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "tasks")
    }
    
    func loadTasks() {
        let userDefaults = UserDefaults.standard
        // 딕셔너리 형태로 저장되어 있던 tasks를 object 프로퍼티로 호출하면 Any 타입으로 반환되기에 타입캐스팅
        guard let data = userDefaults.object(forKey: "tasks") as? [[String : Any]] else { return }
        self.tasks = data.compactMap {
            guard let title = $0["title"] as? String else { return nil }
            guard let done = $0["done"] as? Bool else {return nil }
            return Task(title: title, done: done)
        }
    }
    
}

// 가독성을 위해 익스텐션을 통해 UITableViewDataSource 프로토콜 채택, 옵셔널이 붙지 않은 메소드(필수) 구현
extension ViewController: UITableViewDataSource {
    // 각 세션에 표시할 행의 개수를 반환하는 메소드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    // 특정 세션의 N번째 섹션의 행을 그리는 데 필요한 셀을 반환하는 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 메모리 낭비를 방지하기 위해 스크롤을 통해 셀을 재사용 하는 dequeueReusableCell 메소드를 사용
        // withIdentifier 파라미터는 재사용 할 셀의 식별자를 의미, indexPath 파라미터는 테이블 뷰에서 셀의 위치를 나타내는 인덱스
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = self.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        // 셀에 체크마크 표시
        if task.done {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    // 편집모드에서 삭제 버튼을 선택 시 어떤 셀의 삭제 버튼을 선택하였는지 알려주는 메소드, 선택한 셀을 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        // 할 일이 존재하지 않다면, 자동으로 편집모드에서 탈출
        if self.tasks.isEmpty {
            self.doneButtonTap()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 행이 다른 위치로 이동하면 sourceIndexPath 파라미터를 이용하여 기존의 셀의 위치를 알려주고, destinationIndexPath 파라미터를 이용하여 변경된 셀의 위치를 알려주는 메소드
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // tasks의 위치를 재정렬
        var tasks = self.tasks
        let task = tasks[sourceIndexPath.row]
        tasks.remove(at: sourceIndexPath.row)
        tasks.insert(task, at: destinationIndexPath.row)
        self.tasks = tasks
    }
}

extension ViewController: UITableViewDelegate {
    // 셀을 선택하였을 때 어떤 셀을 선택하였는지 알려주는 메소드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task = self.tasks[indexPath.row]
        // done이 true라면 false로, false라면 true로 전환
        task.done = !task.done
        self.tasks[indexPath.row] = task
        // 선택된 셀만 리로드
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
