//
//  ActivityListingViewController.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 29/12/22.
//

import UIKit
import RxSwift
import RxCocoa

final class ActivityListingViewController: UIViewController {

    // MARK: - Private Properties

    private let viewModel: ActivityListingViewModelProtocol
    private let disposeBag = DisposeBag()
    private let titleLabel = UILabel(translateMask: false).apply {
        $0.text = "Are you bored?"
        $0.font = UIFont.boldSystemFont(ofSize: 30)
        $0.tintColor = .black
        $0.textAlignment = .left
    }

    private let subTitleLabel = UILabel(translateMask: false).apply {
        $0.text = "Here an exercise tip for you now"
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.tintColor = .black
        $0.textAlignment = .left
    }

    private let activityView = ActivityView(translateMask: false).apply {
        $0.backgroundColor = .white
    }

    private let addDetailsButton = UIButton(type: .system).apply {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .white
        $0.backgroundColor = .blue
        $0.setTitle("Add Details", for: .normal)
    }

    private let anotherTipButton = UIButton(type: .system).apply {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .white
        $0.backgroundColor = .blue
        $0.setTitle("New Activity Tip", for: .normal)
    }

    private let spinnerView = UIActivityIndicatorView(translateMask: false).apply {
        $0.style = .medium
        $0.startAnimating()
        $0.isHidden = true
    }

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
        setupView()
        bindRx()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        spinnerView.isHidden = false
        viewModel.input.getActivityTip.accept(())
    }

    // MARK: - Private Methods

    private func bindRx() {
        addDetailsButton.rx.tap
            .bind(to: viewModel.input.openDetailScreen)
            .disposed(by: disposeBag)

        anotherTipButton.rx.tap
            .do(onNext: { [weak self] _ in
                self?.spinnerView.isHidden = false
            })
            .bind(to: viewModel.input.getActivityTip)
            .disposed(by: disposeBag)

        viewModel.output.data
            .subscribe(onNext: { [weak self] data in
                self?.spinnerView.isHidden = true
                self?.activityView.configure(content: data)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - ViewCode Extension

extension ActivityListingViewController: ViewCode {
    func buildViewHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(activityView)
        view.addSubview(addDetailsButton)
        view.addSubview(anotherTipButton)

        activityView.addSubview(spinnerView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 15),

            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            subTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 15),

            activityView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 30),
            activityView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            addDetailsButton.topAnchor.constraint(equalTo: activityView.bottomAnchor, constant: 30),
            addDetailsButton.heightAnchor.constraint(equalToConstant: 30),
            addDetailsButton.widthAnchor.constraint(equalToConstant: 150),
            addDetailsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            anotherTipButton.topAnchor.constraint(equalTo: addDetailsButton.bottomAnchor, constant: 30),
            anotherTipButton.heightAnchor.constraint(equalToConstant: 30),
            anotherTipButton.widthAnchor.constraint(equalToConstant: 150),
            anotherTipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            spinnerView.centerXAnchor.constraint(equalTo: activityView.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: activityView.centerYAnchor)
        ])
    }

    func setupAdditionalConfiguration() {
        view.backgroundColor = .white
    }
}
