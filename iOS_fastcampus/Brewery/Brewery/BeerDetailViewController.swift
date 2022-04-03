//
//  BeerDetailViewController.swift
//  Brewery
//
//  Created by 윤병은 on 2022/04/03.
//

import UIKit

class BeerDetailViewController: UITableViewController {
    var beer: Beer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = beer?.name ?? "이름 없는 맥주"
        
        tableView = UITableView(frame: tableView.frame, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BeerDetailListCell")
        tableView.rowHeight = UITableView.automaticDimension
        
        let headerView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
        let imageURL = URL(string: beer?.imageURL ?? "")
        
        headerView.contentMode = .scaleAspectFit
        headerView.kf.setImage(with: imageURL, placeholder: UIImage(named: "beer_icon"))

        tableView.tableHeaderView = headerView
    }
}


// UITableView DataSource, Delegate
extension BeerDetailViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // id, description, brewers tips, food paring 총 4개의 table을 보여줌
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 나머지는 1개의 데이터만 불러오지만, food paring의 경우는 배열의 개수만큼 반환하므로 다른 case를 두어야 함
        switch section {
        case 3:
            return beer?.foodPairing?.count ?? 0
        default:
            return 1
        }
    }
    
    // title 값을 설정
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "ID"
        case 1:
            return "Description"
        case 2:
            return "Brewers Tips"
        case 3:
            let foodParing = beer?.foodPairing?.count ?? 0
            let containFoodParing = foodParing != 0
            return containFoodParing ? "Food Paring" : nil
        default:
            return nil
        }
    }
    
    // 셀 설정
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "BeerDetailListCell")
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = String(describing: beer?.id ?? 0)
            return cell
        case 1:
            cell.textLabel?.text = beer?.description ?? "설명 없는 맥주"
            return cell
        case 2:
            cell.textLabel?.text = beer?.brewersTips ?? "팁 없는 맥주"
            return cell
        default:
            cell.textLabel?.text = beer?.foodPairing?[indexPath.row] ?? ""
            return cell
        }
    }
}
