//
//  AppCoordinator.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 29/12/22.
//

import XCoordinator

enum AppRouter: Route {
    case start
}

final class AppCoordinator: NavigationCoordinator<AppRouter> {

    // MARK: - Initializer

    init() {
        super.init(initialRoute: .start)
    }

    // MARK: - Override Method

    override func prepareTransition(for route: AppRouter) -> NavigationTransition {
        switch route {
        case .start:
            let coordinator = ActivityListingCoordinator()
            coordinator.viewController.modalPresentationStyle = .fullScreen
            return .presentOnRoot(coordinator, animation: nil)
        }
    }
}
