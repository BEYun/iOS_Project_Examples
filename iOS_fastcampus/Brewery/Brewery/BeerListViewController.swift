//
//  BeerListViewController.swift
//  Brewery
//
//  Created by 윤병은 on 2022/04/03.
//

import UIKit

class BeerListViewController: UITableViewController {
    var beerList = [Beer]()
    // 이니셜라이즈 된 페이지를 저장하는 task 배열
    var dataTasks = [URLSessionTask]()
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBar
        title = "패캠 브루어리"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // UITableView
        tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
        tableView.rowHeight = 150
        
        // 추가 페이지를 위한 prefetchDataDelegate
        tableView.prefetchDataSource = self
        
        fetchBeer(of: currentPage)
    }
}

// UITableView DataSource, Delegate
extension BeerListViewController: UITableViewDataSourcePrefetching {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("Rows : \(indexPath.row)")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListCell", for: indexPath) as? BeerListCell else { return UITableViewCell() }
        
        let beer = beerList[indexPath.row]
        cell.configure(with: beer)
        
        return cell
    }
    
    // 맥주가 선택되었을 때 데이터 전송 및 뷰 전환
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBeer = beerList[indexPath.row]
        let detailViewController = BeerDetailViewController()
        
        detailViewController.beer = selectedBeer
        self.show(detailViewController, sender: nil)
    }
    
    //
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard currentPage != 1 else { return }
        
        indexPaths.forEach {
            //($0.row + 1)/25 + 1은 현재 페이지를 나타냄
            if ($0.row + 1)/25 + 1 == currentPage {
                self.fetchBeer(of: currentPage)
            }
        }
    }
}

// Data Fetching, 보안을 위해 private로 선언
private extension BeerListViewController {
    func fetchBeer(of page: Int) {
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)"),
              // dataTasks의 task(여기서는 $0 파라미터)의 url이 nil이면(page를 지닌 url이 요청되지 않았었다면), url 생성
            dataTasks.firstIndex(where: { $0.originalRequest?.url == url }) == nil else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // URLSession을 이용하여 디코딩 한 Beer 객체를 dataTask 객체에 fetching
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil,
                  let self = self,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let beers = try? JSONDecoder().decode([Beer].self, from: data) else {
                    print("ERROR: URLSession data task error \(error?.localizedDescription ?? "")")
                    return
            }
            
            switch response.statusCode {
            case (200...299): // 성공
                self.beerList += beers
                self.currentPage += 1
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case (400...499): // 클라이언트 에러
                print("""
                        ERROR : Client ERROR \(response.statusCode)
                        RESPONSE : \(response)
                    """)
            case (500...599): // 서버 에러
                print("""
                        ERROR : Server ERROR \(response.statusCode)
                        RESPONSE : \(response)
                    """)
            default:
                print("""
                        ERROR : \(response.statusCode)
                        RESPONSE : \(response)
                    """)
            }
        }
        // datatask 꼭 실행 시켜주어야 한다!!
        dataTask.resume()
        dataTasks.append(dataTask)
    }
}
