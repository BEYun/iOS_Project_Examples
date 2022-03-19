//
//  ViewController.swift
//  COVID19
//
//  Created by 윤병은 on 2022/03/19.
//

import UIKit
import Charts
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseLabel: UILabel!
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicatorView.startAnimating()
        self.fetchCovidOverview(completionHandler: { [weak self] result in
            guard let self = self else { return }
            self.indicatorView.stopAnimating()
            self.indicatorView.isHidden = true
            self.labelStackView.isHidden = false
            self.pieChartView.isHidden = false
            switch result {
            case let .success(result):
                self.configureStackView(koreaCovidOverview: result.korea)
                let covidOverviewList = self.makeCovidOverviewList(cityCovidOverview: result)
                self.configureChartView(covidOverviewList: covidOverviewList)
            case let .failure(error):
                debugPrint(error)
            }
        })
    }
    
    // 시도별 확진자 수를 CovidOverview 타입의 배열로 변환하는 메서드
    // JSON 타입의 결과는 하나의 객체로 전달되기에 객체로 변환하는 작업을 수행
    func makeCovidOverviewList(
        cityCovidOverview: CityCovidOverview
    ) -> [CovidOverview] {
        return [
            cityCovidOverview.seoul,
            cityCovidOverview.busan,
            cityCovidOverview.daegu,
            cityCovidOverview.incheon,
            cityCovidOverview.gwangju,
            cityCovidOverview.daejeon,
            cityCovidOverview.ulsan,
            cityCovidOverview.sejong,
            cityCovidOverview.gyeonggi,
            cityCovidOverview.chungbuk,
            cityCovidOverview.chungnam,
            cityCovidOverview.gyeongbuk,
            cityCovidOverview.gyeongnam,
            cityCovidOverview.jeju,
        ]
    }
    
    // 파이차트를 구성하는 메서드 구현
    func configureChartView(covidOverviewList: [CovidOverview]) {
        self.pieChartView.delegate = self
        // 파라미터로 전달받은 CovidOverview 타입의 배열을 PieChartDataEntry 객체로 매핑하기 위한 작업 수행
        let entries = covidOverviewList.compactMap { [weak self] overview -> PieChartDataEntry? in
            guard let self = self else { return nil }
            // value 파리미터에는 차트 항목에 들어가는 값을 대입, Double 타입을 넘겨주어야 하기에 removeFormatString() 메소드에 전달인자로 overview.newCase를 전달
            // label 파라미터는 파이차트에 들어갈 항목 이름을 대입
            return PieChartDataEntry(
                value: self.removeFormatString(string: overview.newCase),
                label: overview.countryName,
                data: overview)
        }
        // PieChartDataEntry 객체를 DataSet으로 변환
        let dataSet = PieChartDataSet(entries: entries, label: "코로나 발생 현황")
        
        // 파이차트 꾸미기
        dataSet.sliceSpace = 1
        dataSet.entryLabelColor = .black
        dataSet.valueTextColor = .black
        dataSet.xValuePosition = .outsideSlice
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.3
        
        // 파이차트의 색상 추가
        dataSet.colors = ChartColorTemplates.vordiplom() +
            ChartColorTemplates.joyful() +
            ChartColorTemplates.liberty() +
            ChartColorTemplates.pastel() +
            ChartColorTemplates.material()
        
        self.pieChartView.data = PieChartData(dataSet: dataSet)
        // 파이차트 회전
        self.pieChartView.spin(duration: 0.3, fromAngle: self.pieChartView.rotationAngle, toAngle: self.pieChartView.rotationAngle + 80)
    }
    
    // JSON 객체의 전달 값이 String과 ','로 구분되어 있기에 Double 타입으로 반환하는 메서드 구현
    func removeFormatString(string: String) -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: string)?.doubleValue ?? 0
    }
    
    // 확진자 수를 제공하는 메서드 구현
    func configureStackView(koreaCovidOverview: CovidOverview) {
        self.totalCaseLabel.text = "\(koreaCovidOverview.totalCase)명"
        self.newCaseLabel.text = "\(koreaCovidOverview.newCase)명"
    }
    
    func fetchCovidOverview(
        // completionHandler 클로저는 Result 제네릭 열거형에 의해 요청에 성공하면 CityCovidOverview 연관값을 전달, 요청에 실패하거나 에러 발생하면 Error 객체가 연관값으로 전달
        // @escaping 클로저는 함수의 전달인자인 클로저가 함수가 반환된 후에도 실행되는 것을 의미, 함수의 인자가 함수의 밖에서도 사용할 수 있다는 개념, 주로 비동기식 작업 처리(네트워크 통신 등)에서 사용
        // reponseData 함수의 completionHandler 클로저는 fetchCovidOverview 함수가 반환된 후 호출될 것, 서버에서 데이터를 언제 응답시켜줄 지 모르기 때문, 그렇기에 탈출 클로저를 사용
        completionHandler: @escaping (Result<CityCovidOverview, Error>) -> Void
    ) {
        let url = "https://api.corona-19.kr/korea/country/new/"
        let param = [
            "serviceKey": "U6IXax5mgueAPjJlz1VhMKFWGBSs8dT4Y"
        ]
        
        // alarmofire 메소드 호출
        // parameters 파라미터에 딕셔너리 형태로 전달을 하면 url 파라미터 뒤에 자동으로 param 추가
        AF.request(url, method: .get, parameters: param)
        // 응답 데이터를 받을 수 있는 responseData() 메서드 체이닝, 응답 데이터가 completionHandler 클로저 파라미터로 전달됨
            .responseData(completionHandler: { response in
                // response 파라미터는 Response 타입이며, static 프로퍼티로 .result 프로퍼티를 지니며, result는 .success() 메서드와 .failure() 메서드가 있음
                switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CityCovidOverview.self, from: data)
                        // fetchCovidOverview의 파라미터인 completionHandler를 호출하여 .success 열거형에서 연관값을 서버에서 응답받은 JSON 데이터가 매핑된 result를 전달
                        completionHandler(.success(result))
                    } catch {
                        // 매핑 실패시, .failure 열거형 값을 전달하여 연관값에 error를 전달
                        completionHandler(.failure(error))
                    }
                case let .failure(error):
                    completionHandler(.failure(error))
                }
            })
    }
}

extension ViewController: ChartViewDelegate {
    // 차트에서 항목을 선택하였을 때 호출되는 메서드, entry 파라미터를 통해 선택된 항목의 데이터를 가져옴
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let covidDetailViewController = self.storyboard?.instantiateViewController(withIdentifier:
            "CovidDetailViewController") as? CovidDetailViewController else { return }
        guard let covidOverview = entry.data as? CovidOverview else { return }
        // entry 파라미터를 통해 받아온 covidOverview 객체를 covidDetailViewController 객체의 covidOverview에 대입
        covidDetailViewController.covidOverview = covidOverview
        self.navigationController?.pushViewController(covidDetailViewController, animated: true)
    }
}
