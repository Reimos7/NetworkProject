//
//  BoxOfficeViewController.swift
//  NetworkProject
//
//  Created by Reimos on 7/23/25.
//

import UIKit
import SnapKit

final class BoxOfficeViewController: UIViewController {
    
    var movie = MovieInfo.movies
    
    var sortedMovies: [Movie] = []
    
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
        calculateRank()
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
        tableView.rowHeight = 80
        
        
        
        // 코드 기반 셀 등록
        tableView.register(BoxOfficeTableViewCell.self, forCellReuseIdentifier: BoxOfficeTableViewCell.identifier)
        
        searchButton.addTarget(self, action: #selector(tappedSearchButton), for: .touchUpInside)
    }
    
    @objc
    func tappedSearchButton() {
        print(#function)
        sortedMovies.shuffle()
        
        tableView.reloadData()
    }
     
    
    
    
}


// MARK: - BoxOfficeViewController
extension BoxOfficeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BoxOfficeTableViewCell.identifier, for: indexPath) as! BoxOfficeTableViewCell
        
        let movie = sortedMovies[indexPath.row]
        let rank = indexPath.row + 1
        
        //cell.boxOfficeRankLabel.text = movie.jack
        
        cell.configureCell(rankLabel: "\(rank)", name: movie.title, date: movie.releaseDate.customDateFormat)
        
       
        return cell
    }
    
    
}


// MARK: - UITableViewDelegate
extension BoxOfficeViewController: UITableViewDelegate {
    
}
