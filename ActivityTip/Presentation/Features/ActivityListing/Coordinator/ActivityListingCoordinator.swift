//
//  ActivityListingCoordinator.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 29/12/22.
//

import XCoordinator

enum ActivityListingRouter: Route {
    case home
}

final class ActivityListingCoordinator: NavigationCoordinator<ActivityListingRouter> {

    // MARK: - Initializer

    init() {
        super.init(initialRoute: .home)
    }

    // MARK: - Override Method

    override func prepareTransition(for route: ActivityListingRouter) -> NavigationTransition {
        switch route {
        case .home:
            let service = ServiceAPICall()
            let serviceAPI = ActivityAPIService(serviceAPI: service)
            let eventListRepository = ActivityListingRepository(activityAPIService: serviceAPI)
            let eventListUseCase = ActivityListingUseCase(activityListingRepository: eventListRepository)
            let viewModel = ActivityListingViewModel()
            let viewController = ActivityListingViewController(viewModel: viewModel)
            return .push(viewController)
        }
    }

}
