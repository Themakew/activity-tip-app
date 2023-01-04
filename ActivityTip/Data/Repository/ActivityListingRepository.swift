//
//  ActivityListingRepository.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 29/12/22.
//

import RxSwift

protocol ActivityListingRepositoryProtocol {
    func getActivityTip(parameters: ActivityFilter?) -> Single<Result<ActivityResponse, NetworkError>>
}

final class ActivityListingRepository: ActivityListingRepositoryProtocol {

    // MARK: Private Property

    private let activityAPIService: ActivityAPIServiceProtocol

    // MARK: Initializer

    init(activityAPIService: ActivityAPIServiceProtocol) {
        self.activityAPIService = activityAPIService
    }

    // MARK: Internal Methods

    func getActivityTip(parameters: ActivityFilter?) -> Single<Result<ActivityResponse, NetworkError>> {
        guard let parameters else {
            return activityAPIService.getResponseFromActivityEndPoint(parameters: nil)
        }

        let dictParams = getDictParams(parameters: parameters)
        return activityAPIService.getResponseFromActivityEndPoint(parameters: dictParams)
    }

    private func getDictParams(parameters: ActivityFilter) -> [String: Any] {
        let dict = [
            "participant": parameters.numberOfParticipants?.description ?? "1",
            "price": parameters.budgetNumber?.description ?? "0.5",
            "type": parameters.type?.rawValue ?? "education"
        ]
        return dict
    }
}
