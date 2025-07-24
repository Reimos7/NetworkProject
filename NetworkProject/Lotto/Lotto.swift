//
//  Lotto.swift
//  NetworkProject
//
//  Created by Reimos on 7/23/25.
//

import UIKit

// Decodable -> struct가 외부에서 오는 데이터를 담는다
struct Lotto: Decodable {
    let drwNoDate: String
    
    let drwtNo1: Int
    let drwtNo2: Int
    let drwtNo3: Int
    let drwtNo4: Int
    let drwtNo5: Int
    let drwtNo6: Int
    
    let bnusNo: Int
}

struct LottoBall {
    let number: Int
    let color: UIColor
}

