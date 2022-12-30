//
//  ActivityListingUseCase.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 29/12/22.
//

import RxSwift

protocol ActivityListingUseCaseProtocol {
    func getActivityTip() -> Single<Result<ActivityResponse, NetworkError>>
}

final class ActivityListingUseCase: ActivityListingUseCaseProtocol {

    // MARK: Private Property

    private let activityListingRepository: ActivityListingRepositoryProtocol

    // MARK: Initializer

    init(activityListingRepository: ActivityListingRepositoryProtocol) {
        self.activityListingRepository = activityListingRepository
    }

    // MARK: Internal Methods

    func getActivityTip() -> Single<Result<ActivityResponse, NetworkError>> {
        return activityListingRepository.getActivityTip()
    }
}
