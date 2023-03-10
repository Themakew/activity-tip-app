//
//  ActivityListingCoordinator.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 29/12/22.
//

import XCoordinator
import UIKit

enum ActivityListingRouter: Route {
    case home
    case detailScreen(object: ActivityInfoEntity)
    case filterScreen(viewModel: ActivityFilterViewModelProtocol)
    case dismiss
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
            let activityListingRepository = ActivityListingRepository(activityAPIService: serviceAPI)
            let activityListingUseCase = ActivityListingUseCase(activityListingRepository: activityListingRepository)
            let viewModel = ActivityListingViewModel(
                router: weakRouter,
                activityListingUseCase: activityListingUseCase
            )
            let viewController = ActivityListingViewController(viewModel: viewModel)
            return .push(viewController)
        case let .detailScreen(object):
            let coreDataAPIService = CoreDataAPIService()
            let activityDetailRepository = ActivityDetailRepository(coreDataAPIService: coreDataAPIService)
            let activityDetailUseCase = ActivityDetailUseCase(activityDetailRepository: activityDetailRepository)
            let viewModel = ActivityDetailViewModel(
                router: weakRouter,
                activityInfoEntity: object,
                activityDetailUseCase: activityDetailUseCase
            )
            let viewController = ActivityDetailViewController(viewModel: viewModel)
            return .push(viewController)
        case let .filterScreen(viewModel):
//            let viewModel = ActivityFilterViewModel(router: weakRouter)
            let viewController = ActivityFilterViewController(viewModel: viewModel)
            return .present(viewController)
        case .dismiss:
            return .dismiss()
        }
    }
}
