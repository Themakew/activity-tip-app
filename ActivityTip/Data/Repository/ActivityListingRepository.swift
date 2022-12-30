//
//  ActivityListingRepository.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 29/12/22.
//

import RxSwift

protocol ActivityListingRepositoryProtocol {
    func getActivityTip() -> Single<Result<ActivityResponse, NetworkError>>
}

final class ActivityListingRepository: ActivityListingRepositoryProtocol {

    // MARK: Private Property

    private let activityAPIService: ActivityAPIServiceProtocol

    // MARK: Initializer

    init(activityAPIService: ActivityAPIServiceProtocol) {
        self.activityAPIService = activityAPIService
    }

    // MARK: Internal Methods

    func getActivityTip() -> Single<Result<ActivityResponse, NetworkError>> {
        return activityAPIService.getResponseFromActivityEndPoint()
    }
}
