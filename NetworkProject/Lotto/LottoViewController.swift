//
//  LottoViewController.swift
//  NetworkProject
//
//  Created by Reimos on 7/23/25.
//

import UIKit
import SnapKit
import Alamofire

final class LottoViewController: UIViewController {
    
    let picker = UIPickerView()
    
    var selectedPicker = ""
    
    var bonusBall = 0
    
    // ReversedCollection을 타입 [Int] 타입 캐스팅
    private let numbers: [Int] = Array(1...1181).reversed()
    
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
        tf.textAlignment = .center
        tf.inputView = picker
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
        label.text = ""
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }()
    
    private let lineView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    
    private let lottoRoundLabel = {
        let label = UILabel()
        label.text = "1181회"
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
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()

//    private let bonusLottoBall = {
//        let view = UIView()
//        view.backgroundColor = .systemGray2
//        view.layer.cornerRadius = 20
//        
//        let label = UILabel()
//        label.text = "40"
//        label.textAlignment = .center
//        label.font = .systemFont(ofSize: 16, weight: .bold)
//        label.textColor = .white
//                
//        view.addSubview(label)
//        
//        label.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//        }
//        
//        return view 
//    }()
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureView()
        
        
        // 피커뷰 내리는 용도
        setTapGesture()
        
        lottoRequest(lottoDate: "1181")
        
        
    }
    
    // 보너스 제외 번호 6개 세팅
    private func setupLotto(data: Lotto) {
        lottoDrawDate.text = data.drwNoDate
                
        // 스택뷰 비워줌
        for view in lottoBallStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        let numers = [data.drwtNo1, data.drwtNo2 ,data.drwtNo3 ,data.drwtNo4, data.drwtNo5, data.drwtNo6]
        let bonusNum = data.bnusNo
        
        //bonusBall = data.bnusNo
        
        let colors: [UIColor] = [.systemYellow, .systemBlue, .systemBlue, .systemRed, .systemRed, .systemGray2]
        // 보너스는 색상 랜덤으로
        let bonusColors: UIColor = colors.randomElement() ?? UIColor.systemGray2
        
        // 로또 구조체 - 숫자, 색상
        var lottoBalls: [LottoBall] = []
        
        for index in 0..<numers.count {
            let ball = LottoBall(number: numers[index], color: colors[index])
            lottoBalls.append(ball)
            
        }
        let bonusBall = LottoBall(number: bonusNum, color: bonusColors)
        //lottoBalls.append(bonusBall)
        
        print(lottoBalls)
        createLotto(lottos: lottoBalls, bonusBall: bonusBall)
        
       
    }
    
    // 구조체에 있는걸 스택뷰에 추가해줌
    private func createLotto(lottos: [LottoBall], bonusBall: LottoBall) {
        
        for ball in lottos {
            
            let lottoBall = createBall(number: ball.number, color: ball.color)
            // 스택뷰에 각각의 공 추가
            lottoBallStackView.addArrangedSubview(lottoBall)
        }
        let lottoBonusBall = createBall(number: bonusBall.number, color: bonusBall.color)
        
        lottoBallStackView.addArrangedSubview(plusLabel)
        lottoBallStackView.addArrangedSubview(lottoBonusBall)
        
        
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
    
    private func lottoRequest(lottoDate: String) {
        // 로또 주소를 입력받은 로또 날짜로 get 하기
        var url = APIKey.lottoURL
        url += lottoDate
        dump(url)
        
        
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Lotto.self) { response in
                switch response.result {
                case .success(let value):
                    
                    self.setupLotto(data: value)
                    
                    print("sucess", value)
                case .failure(let value):
                    print("failure", value)
                }
            }
        
        
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
   
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
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
        //lottoView.addSubview(plusLabel)
        //lottoView.addSubview(bonusLottoBall)
        
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
            make.trailing.equalTo(view.safeAreaLayoutGuide)
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
            make.leading.equalTo(lottoRoundLabel.snp.trailing).offset(10)
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
            make.trailing.equalTo(lineView.snp.trailing).offset(-4)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }
        
//        plusLabel.snp.makeConstraints { make in
//            make.leading.equalTo(lottoBallStackView.snp.trailing).offset(10)
//            make.centerY.equalToSuperview()
//            make.width.equalTo(20)
//        }
        
//        bonusLottoBall.snp.makeConstraints { make in
//            make.leading.equalTo(plusLabel.snp.trailing).offset(10)
//            make.centerY.equalToSuperview()
//            make.size.equalTo(40)
//            
//        }
        
    }
    
    func configureView() {
        view.backgroundColor = .white
        
        picker.dataSource = self
        picker.delegate = self
        
        
    }
    
    func setPicker() {
        
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
    
    
    // MARK: - pickerView가 선택하면 값 넘겨주기
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        selectedPicker = String (numbers[row])        //selectedPicker = numbers[row]
        lottoRoundLabel.text = "\(selectedPicker) 회"
    
        textField.text = "\(selectedPicker) 회"
        print("----")
        print(selectedPicker)
        print(lottoRequest(lottoDate: selectedPicker))
    }
    
}
