//
//  BoxOfficeTableViewCell.swift
//  NetworkProject
//
//  Created by Reimos on 7/23/25.
//

import UIKit
import SnapKit

final class BoxOfficeTableViewCell: UITableViewCell {
    
    static let identifier = "BoxOfficeTableViewCell"
    
//    let boxOfficeRankView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        
//        let label = UILabel()
//        label.textAlignment = .center
//        label.text = "1"
//        label.font = .systemFont(ofSize: 16, weight: .bold)
//        
//        view.addSubview(label)
//        
//        label.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        
//        return label
//    }()
    let boxOfficeRankView = UIView()
    let boxOfficeRankLabel = UILabel()
    
//    let boxOfficeMovieName = {
//        let label = UILabel()
//        label.textColor = .white
//        label.textAlignment = .left
//        label.font = .systemFont(ofSize: 16, weight: .bold)
//        return label
//    }()
    let boxOfficeMovieName = UILabel()
    
//    let boxOfficeMovieDate = {
//        let label = UILabel()
//        label.textColor = .white
//        label.textAlignment = .center
//        return label
//    }()
    let boxOfficeMovieDate = UILabel()
    
    // 코드용
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
        configureView()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell( rankLabel: String, name: String, date: String) {
        boxOfficeRankLabel.text = rankLabel
        boxOfficeMovieName.text = name
        boxOfficeMovieDate.text = date
        
        //죄와 벌 | 2022-33-33일 개봉 | 1위
        
    }
}


extension BoxOfficeTableViewCell: ViewDesignProtocol {
    func configureHierarchy() {
        contentView.addSubview(boxOfficeRankView)
        boxOfficeRankView.addSubview(boxOfficeRankLabel)
        contentView.addSubview(boxOfficeMovieName)
        contentView.addSubview(boxOfficeMovieDate)
        
        
    }
    
    func configureLayout() {
        boxOfficeRankView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(30)
            make.centerY.equalTo(contentView)
            make.width.equalTo(40)
        }

        boxOfficeRankLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        boxOfficeMovieName.snp.makeConstraints { make in
            make.leading.equalTo(boxOfficeRankView.snp.trailing).offset(10)
            make.centerY.equalTo(contentView)
            make.height.equalTo(40)
        }
        
        // MARK: - MovieDate를 최고 우선순위로 설정 -> MovieName이 길면 MovieDate에 겹치지 않고 줄바꿈
        boxOfficeMovieDate.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        boxOfficeMovieDate.snp.makeConstraints { make in
            // 사이 최소 간격 설정
            make.leading.greaterThanOrEqualTo(boxOfficeMovieName.snp.trailing).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).inset(20)
            make.centerY.equalTo(contentView)
            //make.height.equalTo(40)
            
        }
        
    }
    
    func configureView() {
        contentView.backgroundColor = .clear
        
        boxOfficeRankView.backgroundColor = .white
        
        boxOfficeRankLabel.textAlignment = .center
        boxOfficeRankLabel.text = "1"
        boxOfficeRankLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        boxOfficeMovieName.text = "가나다"
        boxOfficeMovieName.numberOfLines = 0
        boxOfficeMovieName.textColor = .white
        boxOfficeMovieName.textAlignment = .left
        boxOfficeMovieName.font = .systemFont(ofSize: 16, weight: .bold)
        
        boxOfficeMovieDate.text = "2020-04-01"
        boxOfficeMovieDate.textColor = .white
        boxOfficeMovieDate.font = .systemFont(ofSize: 16, weight: .bold)
    
    }
    
    
}
