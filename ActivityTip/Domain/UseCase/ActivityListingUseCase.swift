//
//  ActivityListingUseCase.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 29/12/22.
//

import RxSwift

protocol ActivityListingUseCaseProtocol {
    func getActivityList() -> Single<ActivityResponse>
}

final class ActivityListingUseCase: ActivityListingUseCaseProtocol {

    // MARK: Private Property

    private let activityListingRepository: ActivityListingRepositoryProtocol

    // MARK: Initializer

    init(activityListingRepository: ActivityListingRepositoryProtocol) {
        self.activityListingRepository = activityListingRepository
    }

    // MARK: Internal Methods

    func getActivityList() -> Single<ActivityResponse> {
        return activityListingRepository.getActivityList()
    }
}
