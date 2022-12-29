//
//  ActivityListingViewModel.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 29/12/22.
//

import UIKit

protocol ActivityListingViewModelProtocol {
    var input: ActivityListingViewModelInput { get }
    var output: ActivityListingViewModelOutput { get }
}

protocol ActivityListingViewModelInput {

}

protocol ActivityListingViewModelOutput {

}

extension ActivityListingViewModelProtocol where Self: ActivityListingViewModelInput & ActivityListingViewModelOutput {
    var input: ActivityListingViewModelInput { return self }
    var output: ActivityListingViewModelOutput { return self }
}

final class ActivityListingViewModel:
    ActivityListingViewModelProtocol,
    ActivityListingViewModelInput,
    ActivityListingViewModelOutput {


}
