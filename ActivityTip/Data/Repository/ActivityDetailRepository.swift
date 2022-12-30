//
//  ActivityDetailRepository.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 30/12/22.
//

protocol ActivityDetailRepositoryProtocol {
    func saveData(data: (ActivityEntity, ActivityStatusEntity))
}

final class ActivityDetailRepository: ActivityDetailRepositoryProtocol {

    // MARK: Private Property

    private let coreDataAPIService: CoreDataAPIServiceProtocol

    // MARK: Initializer

    init(coreDataAPIService: CoreDataAPIServiceProtocol) {
        self.coreDataAPIService = coreDataAPIService
    }

    // MARK: Internal Methods

    func saveData(data: (ActivityEntity, ActivityStatusEntity)) {
        coreDataAPIService.saveData(data: data)
    }
}
