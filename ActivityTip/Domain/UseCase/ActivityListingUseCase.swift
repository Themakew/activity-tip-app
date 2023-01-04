//
//  ActivityListingUseCase.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 29/12/22.
//

import RxSwift

protocol ActivityListingUseCaseProtocol {
    func getActivityTip() -> Single<Result<ActivityInfoEntity, NetworkError>>
}

enum ActivityType: String, CaseIterable {
    case education, recreational, social, diy, charity, cooking, relaxation, music, busywork
}

enum BudgetType: String {
    case cheap, average, expensive, none
}

final class ActivityListingUseCase: ActivityListingUseCaseProtocol {

    // MARK: Private Property

    private let activityListingRepository: ActivityListingRepositoryProtocol

    // MARK: Initializer

    init(activityListingRepository: ActivityListingRepositoryProtocol) {
        self.activityListingRepository = activityListingRepository
    }

    // MARK: Internal Methods

    func getActivityTip() -> Single<Result<ActivityInfoEntity, NetworkError>> {
        return activityListingRepository.getActivityTip()
            .map { [weak self] result in
                switch result {
                case let .success(object):
                    let activityEntity = ActivityEntity(
                        activity: object.activity ?? "",
                        accessibility: self?.getAccessibilityPercentage(value: object.accessibility) ?? "",
                        type: self?.getType(type: object.type) ?? .education,
                        participants: object.participants,
                        price: self?.getBudgetType(price: object.price) ?? .none,
                        link: object.link,
                        key: object.key
                    )

                    let activityInfo = ActivityInfoEntity(
                        activityTipTitleText: "Activity Tip:",
                        activityAccessibilityTitleText: "Accessibility",
                        activityTypeTitleText: "Type",
                        activityPriceTitleText: "Price",
                        activityParticipantsTitleText: "Participants",
                        activityInfo: activityEntity
                    )
                    return .success(activityInfo)
                case let .failure(error):
                    return .failure(error)
                }
            }
    }

    // MARK: Private Methods

    private func getAccessibilityPercentage(value: Double?) -> String {
        guard let value = value else {
            return "0%"
        }

        let percentage = value * 100
        return String(format: "%.0f%%", percentage)
    }

    private func getType(type: String?) -> ActivityType {
        if let type = ActivityType(rawValue: type ?? "") {
            return type
        } else {
            return .education
        }
    }

    private func getBudgetType(price: Double?) -> BudgetType {
        if let price {
            if price <= 0.45 {
                return .cheap
            } else if price >= 0.45 && price <= 0.55 {
                return .average
            } else {
                return .expensive
            }
        } else {
            return .none
        }
    }
}
