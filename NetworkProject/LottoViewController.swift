//
//  LottoViewController.swift
//  NetworkProject
//
//  Created by Reimos on 7/23/25.
//

import UIKit
import SnapKit

final class LottoViewController: UIViewController {
    
    let pickerView = UIPickerView()
    
    private let numbers = Array(1...1181)
    
    lazy var textField = {
        let tf = UITextField()
        tf.placeholder = "로또 번호를 입력해주세요"
        tf.keyboardType = .numberPad
        tf.borderStyle = .none
        tf.font = .boldSystemFont(ofSize: 15)
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.cornerRadius = 8
        tf.backgroundColor = .white
        tf.tintColor = .purple
        tf.inputView = pickerView
        return tf
    }()
    
  
    private let lottoNumbersInfoLabel = {
        let label = UILabel()
        label.text = "당첨번호 안내"
        label.textAlignment = .center
        return label
    }()
    
    private let lottoDrawDate = {
        let label = UILabel()
        label.text = "2020-05-30 추첨"
        label.textColor = .darkGray
        return label
    }()
    
    private let lineView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        //;;view.tintColor = .red
        return view
    }()
    
    
    private let lottoRoundLabel = {
        let label = UILabel()
        label.text = "913회"
        label.textColor = .systemYellow
        label.font = .boldSystemFont(ofSize: 28)
        //label.backgroundColor = .blue
        label.textAlignment = .center
        return label
    }()

    private let lottoResultLabel = {
        let label = UILabel()
        label.text = "당첨결과"
        label.font = .boldSystemFont(ofSize: 28)
        return label
    }()
    
    private let lottoView = {
        let view = UIView()
        return view
    }()
    
    lazy var lottoBallStackView: UIStackView = {
    
       // arrangedSubviews 생성자의 스택뷰에 올리고 싶은걸 올리기
       let st = UIStackView()
       //let st = UIStackView(arrangedSubviews: [membershipButton,paymentButton,cuponButton])
       st.spacing = 8 // 스택뷰 내부의 간격을 18만큼 띄어주기
       st.axis = .horizontal // 스택뷰의 축 vertical = 세로, horizontal = 가로
       st.distribution = .fillEqually  // 분배를 어떻게 할래? fillEqually = 높이 간격을 동일하게 채움
       st.alignment = .fill    // 스택뷰 정렬에서는 완전히 채우는 fill이 있다
           
       return st
       }()
    
    private let plusLabel = {
        let label = UILabel()
        label.text = "+"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    private let bonusLottoBall = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        view.layer.cornerRadius = 20
        
        let label = UILabel()
        label.text = "40"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
                
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        return view 
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureView()
        
        setupLotto()
        
    }
    
    // 보너스 제외 번호 6개 세팅
    private func setupLotto() {
        let numers = [6, 14 ,16 ,21, 27, 37]
        let colors: [UIColor] = [.systemYellow, .systemBlue, .systemBlue, .systemRed, .systemRed, .systemGray2]
        // 로또 구조체 - 숫자, 색상
        var lottoBalls: [Lotto] = []
        
        for index in 0..<numers.count {
            let ball = Lotto(number: numers[index], color: colors[index])
            lottoBalls.append(ball)
            
        }
        print(lottoBalls)
        createLotto(lottos: lottoBalls)
        
    }
    
    // 구조체에 있는걸 스택뷰에 추가해줌
    private func createLotto(lottos: [Lotto]) {
        
        for ball in lottos {
            
            let lottoBall = createBall(number: ball.number, color: ball.color)
            // 스택뷰에 각각의 공 추가
            lottoBallStackView.addArrangedSubview(lottoBall)
        }
        
    }
    
    // 로또 공 한개씩 ui , addSubview, layout 설정
    private func createBall(number: Int, color: UIColor) -> UIView {
        
        let backgroundView = UIView()
        
        let ballView = {
            let view = UIView()
            view.layer.cornerRadius = 20
            view.backgroundColor = color
            return view
        }()
        
        let numberLabel = {
            let label = UILabel()
            label.text = "\(number)"
            label.textAlignment = .center
            label.textColor = .white
            label.font = .systemFont(ofSize: 16, weight: .bold)
            return label
        }()
        
        backgroundView.addSubview(ballView)
        backgroundView.addSubview(numberLabel)
        
        // ball layout
        ballView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            // width + height 
            make.size.equalTo(40)
        }
        
        numberLabel.snp.makeConstraints { make in
            // ball view 기준으로 x축
            //make.centerX.equalTo(ballView)
            // 가운데로
            make.center.equalTo(ballView)
        }
        
        return backgroundView
    }
   
}

extension LottoViewController: ViewDesignProtocol {
    func configureHierarchy() {
        view.addSubview(textField)
        view.addSubview(lottoNumbersInfoLabel)
        view.addSubview(lottoDrawDate)
        view.addSubview(lineView)
        view.addSubview(lottoRoundLabel)
        view.addSubview(lottoResultLabel)
        view.addSubview(lottoView)
        
        lottoView.addSubview(lottoBallStackView)
        lottoView.addSubview(plusLabel)
        lottoView.addSubview(bonusLottoBall)
        
    }
    
    func configureLayout() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        
        lottoNumbersInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.height.equalTo(24)
            make.width.equalTo(100)
        }
        
        lottoDrawDate.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(40)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(24)
            make.width.equalTo(150)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(lottoNumbersInfoLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(1)
        }
        
        lottoRoundLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(50)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(110)
            //make.trailing.equalTo(view.safeAreaLayoutGuide).inset(150)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        
        lottoResultLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(50)
            make.leading.equalTo(lottoRoundLabel.snp.trailing)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(50)
            
            //make.width.equalTo(150)
        }
        
        lottoView.snp.makeConstraints { make in
            make.top.equalTo(lottoRoundLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(60)
        }
        
        lottoBallStackView.snp.makeConstraints { make in
            //make.top.equalToSuperview()
            make.leading.equalTo(lottoView.snp.leading).offset(4)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }
        
        plusLabel.snp.makeConstraints { make in
            make.leading.equalTo(lottoBallStackView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
        }
        
        bonusLottoBall.snp.makeConstraints { make in
            make.leading.equalTo(plusLabel.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
            
        }
        
    }
    
    func configureView() {
        view.backgroundColor = .white
        
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    
}


// MARK: - UIPickerViewDataSource
extension LottoViewController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
    }
    
    // 숫자 1개씩
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
}


// MARK: - UIPickerViewDelegate
extension LottoViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numbers[row])"
    }
}
