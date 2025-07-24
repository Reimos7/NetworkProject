//
//  BoxOfficeViewController.swift
//  NetworkProject
//
//  Created by Reimos on 7/23/25.
//

import UIKit
import SnapKit
import Alamofire

final class BoxOfficeViewController: UIViewController {
    
    var movie = MovieInfo.movies
    
    var sortedMovies: [Movie] = []
    
    // api용
    var boxOffice: [BoxOffice] = []
    
    var rank = 0
    
    private let tableView = UITableView()
    
    // 배경 이미지
    private let backgroundImage = {
        let img = UIImageView()
        img.image = UIImage(resource: .background)
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private let backgroundView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    private let textField = {
        let tf = UITextField()
        tf.placeholder = "영화 정보를 입력해주세요"
        tf.keyboardType = .numberPad
        tf.borderStyle = .none
        tf.font = .boldSystemFont(ofSize: 15)
        tf.layer.borderWidth = 1
        tf.backgroundColor = .white
        tf.tintColor = .white
        return tf
    }()
    
    
    
    private let searchButton = {
        let btn = UIButton()
        btn.setTitle("검색", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureView()
        
        //print(movie)
        //calculateRank()
        
        // 항상 어제 날짜 기준으로 박스오피스 정보 가져오기
        boxOfficeRequest(movieDate: calculateYesterday)
    }
    
    
    // MARK: - 어제 날짜 계산
    var calculateYesterday: String {
        let today = Date()
        let calendar = Calendar.current
        // 현재 지역 기준 어제 날짜 구하기
        let yesterDay = calendar.date(byAdding: .day, value: -1, to: today)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let yesterString = dateFormatter.string(from: yesterDay)
        return yesterString
    }
    
    private func calculateRank() {
        
        // 전체 갯수
        // let movieCount = movie.count
        
        // 관객 수로 정렬하기 1등부터 많은 순서임
        let sortedMovie = movie.sorted { $0.audienceCount > $1.audienceCount }
        
        for (index, movie) in sortedMovie.enumerated() {
            print("\(index+1) \(movie.title)")
            rank = index
            print(rank+1)
        }
        
        sortedMovies = sortedMovie
        
        dump(rank)
        
        dump(sortedMovie)
    }
    
    
    // MARK: - Request API
    func boxOfficeRequest(movieDate: String) {
        var url = APIKey.movieURL
        url += movieDate
        print(url)
        
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BoxOfficeResult.self) { response in
                switch response.result {
                
                case .success(let value):
                    print(value)
                
                    self.boxOffice = value.boxOfficeResult.dailyBoxOfficeList
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                    
                case .failure(let error):
                    self.showAlert(title: "에러 발생", message: "\(self.calculateYesterday) 형식 기준으로 작성 해주세요", preferredStyle: .alert)
                    self.textField.text = ""
                    print(error)
            }
                
        }
    }
}
    
 

extension BoxOfficeViewController: ViewDesignProtocol {
    func configureHierarchy() {
        view.addSubview(backgroundImage)
        view.addSubview(backgroundView)
        view.addSubview(textField)
        view.addSubview(searchButton)
        view.addSubview(tableView)
    }
    
    func configureLayout() {
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(40)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-120)
        }
        
        searchButton.snp.makeConstraints { make in
            //make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.bottom.equalTo(textField.snp.bottom)
            make.leading.equalTo(textField.snp.trailing).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    func configureView() {
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        
        textField.delegate = self
        
        // 코드 기반 셀 등록
        tableView.register(BoxOfficeTableViewCell.self, forCellReuseIdentifier: BoxOfficeTableViewCell.identifier)
        
        searchButton.addTarget(self, action: #selector(tappedSearchButton), for: .touchUpInside)
    }
    
    
    // MARK: - 버튼 클릭
    @objc
    func tappedSearchButton() {
        print(#function)
        
        inputValidation()
        
    }
     
    
    // MARK: - 입력값 검증 < 빈값 체크, 날짜 형식 검증, 미래 날짜인지 검증 (어제 기준으로 오늘과 미래 검증) >
    private func inputValidation() {
        guard let dateText = textField.text,
              !dateText.isEmpty else {
            self.showAlert(title: "에러 발생", message: "\(self.calculateYesterday) 형식 기준으로 작성 해주세요", preferredStyle: .alert)
            textField.text = ""
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        // 사용자가 입력한 텍스트가 dateFormat 형식이 아니라면 alert 맞으면 아래 조건
        guard let inputDate = dateFormatter.date(from: dateText) else {
            self.showAlert(title: "입력 오류", message: "날짜 형식이 잘못됐어요\n\(self.calculateYesterday) 형식 기준으로 작성 해주세요", preferredStyle: .alert)
            textField.text = ""
            return
        }
        
        // 어제 날짜 계산
        let today = Date()
        let calendar = Calendar.current
        guard let yesterday = calendar.date(byAdding: .day, value: -1, to: today) else {return}
        
        // 사용자가 입력한 날짜가 어제 날짜보다 크다면 -> 미래라면 alert
        // Date -> Comparable protocol
        if inputDate > yesterday {
            showAlert(title: "입력 오류", message: "어제보다 미래 날짜는 입력할 수 없어요", preferredStyle: .alert)
            textField.text = ""
        }
        // 입력한 날짜를 string 으로 변경해야지 boxOfficeRequest 호출 가능
        let inputDateString = dateFormatter.string(from: inputDate)
        //sortedMovies.shuffle()
        
        boxOfficeRequest(movieDate: inputDateString)
        
        tableView.reloadData()
    }
    
}


// MARK: - BoxOfficeViewController
extension BoxOfficeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return sortedMovies.count
        return boxOffice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BoxOfficeTableViewCell.identifier, for: indexPath) as! BoxOfficeTableViewCell
        
        //let movie = sortedMovies[indexPath.row]
        let boxOffice = boxOffice[indexPath.row]
        //let rank = indexPath.row + 1
        
        //cell.boxOfficeRankLabel.text = movie.jack
        
        //cell.configureCell(rankLabel: "\(rank)", name: movie.title, date: movie.releaseDate.customDateFormat)
        cell.configureCell(rankLabel: boxOffice.rank, name: boxOffice.movieNm, date: boxOffice.openDt)
        cell.selectionStyle = .none
       
        return cell
    }
    
    
}


// MARK: - UITableViewDelegate
extension BoxOfficeViewController: UITableViewDelegate {
    
}


// MARK: - UITextFieldDelegate
// 엔터키 입력
extension BoxOfficeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(#function)
        
        inputValidation()
        return true
    }
}
