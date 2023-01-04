//
//  AlertEntity.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 04/01/23.
//

import UIKit

struct AlertEntity {
    let title: String
    let message: String
    var preferredStyle: UIAlertController.Style = .alert
    let actionTitle: String
    var actionStyle: UIAlertAction.Style = .default
}
