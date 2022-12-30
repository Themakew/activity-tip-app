//
//  ActivityDetailUseCase.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 30/12/22.
//

protocol ActivityDetailUseCaseProtocol {
    func saveData(data: (ActivityEntity, ActivityStatusEntity))
    func getActivityStatusEntity(basedOn status: String, and time: String) -> ActivityStatusEntity
}

final class ActivityDetailUseCase: ActivityDetailUseCaseProtocol {

    // MARK: Private Property

    private let activityDetailRepository: ActivityDetailRepositoryProtocol

    // MARK: Initializer

    init(activityDetailRepository: ActivityDetailRepositoryProtocol) {
        self.activityDetailRepository = activityDetailRepository
    }

    // MARK: Internal Methods

    func saveData(data: (ActivityEntity, ActivityStatusEntity)) {
        activityDetailRepository.saveData(data: data)
    }

    func getActivityStatusEntity(basedOn status: String, and time: String) -> ActivityStatusEntity {
        return ActivityStatusEntity(status: ActivityStatus(rawValue: status) ?? .none, timeSpent: time)
    }
}
