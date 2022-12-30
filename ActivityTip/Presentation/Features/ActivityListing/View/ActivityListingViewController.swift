//
//  ActivityListingViewController.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 29/12/22.
//

import UIKit

final class ActivityListingViewController: UIViewController {

    // MARK: - Private Properties

    let viewModel: ActivityListingViewModelProtocol

    // MARK: - Initializers

    init(viewModel: ActivityListingViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.getActivityTip.accept(())
    }
}
