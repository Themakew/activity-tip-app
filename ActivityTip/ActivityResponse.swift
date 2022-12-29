//
//  ActivityResponse.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 29/12/22.
//

import Foundation

struct ActivityResponse: Decodable {
    let activity: String?
    let accessibility: Double?
    let type: String?
    let participants: Int?
    let price: Double?
    let link: String?
    let key: String?
}
