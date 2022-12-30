//
//  ActivityStatusEntity.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 30/12/22.
//

enum ActivityStatus: String {
    case ongoing, done, skipped, none
}

struct ActivityStatusEntity {
    var status: ActivityStatus
    var timeSpent: String
}
