//
//  ActivityView.swift
//  ActivityTip
//
//  Created by Ruyther Costa on 30/12/22.
//

import UIKit

final class ActivityView: UIView {

    // MARK: - Private Properties

    private let activityTipLabel = UILabel(translateMask: false).apply {
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        $0.textAlignment = .left
    }

    private let activityNameValueLabel = UILabel(translateMask: false).apply {
        $0.font = UIFont.boldSystemFont(ofSize: 13)
        $0.textAlignment = .center
    }

    private let activityAccessibilityLabel = UILabel(translateMask: false).apply {
        $0.font = UIFont.boldSystemFont(ofSize: 11)
        $0.textAlignment = .left
    }

    private let activityAccessibilityValueLabel = UILabel(translateMask: false).apply {
        $0.font = UIFont.systemFont(ofSize: 11)
        $0.textAlignment = .left
    }

    private let activityTypeLabel = UILabel(translateMask: false).apply {
        $0.font = UIFont.boldSystemFont(ofSize: 11)
        $0.textAlignment = .left
    }

    private let activityTypeValueLabel = UILabel(translateMask: false).apply {
        $0.font = UIFont.systemFont(ofSize: 11)
        $0.textAlignment = .left
    }

    private let activityPriceLabel = UILabel(translateMask: false).apply {
        $0.font = UIFont.boldSystemFont(ofSize: 11)
        $0.textAlignment = .left
    }

    private let activityPriceValueLabel = UILabel(translateMask: false).apply {
        $0.font = UIFont.systemFont(ofSize: 11)
        $0.textAlignment = .left
    }

    private let activityParticipantsLabel = UILabel(translateMask: false).apply {
        $0.font = UIFont.boldSystemFont(ofSize: 11)
        $0.textAlignment = .left
    }

    private let activityParticipantsValueLabel = UILabel(translateMask: false).apply {
        $0.font = UIFont.systemFont(ofSize: 11)
        $0.textAlignment = .left
    }

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewCode Extension

extension ActivityView: ViewCode {
    func buildViewHierarchy() {
        addSubview(activityTipLabel)
        addSubview(activityNameValueLabel)
        addSubview(activityAccessibilityLabel)
        addSubview(activityAccessibilityValueLabel)
        addSubview(activityTypeLabel)
        addSubview(activityTypeValueLabel)
        addSubview(activityPriceLabel)
        addSubview(activityPriceValueLabel)
        addSubview(activityParticipantsLabel)
        addSubview(activityParticipantsValueLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            activityTipLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            activityTipLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            activityTipLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 15),

            activityNameValueLabel.topAnchor.constraint(equalTo: activityTipLabel.bottomAnchor, constant: 10),
            activityNameValueLabel.leadingAnchor.constraint(equalTo: activityTipLabel.leadingAnchor),
            activityNameValueLabel.trailingAnchor.constraint(equalTo: activityTipLabel.trailingAnchor),

            activityAccessibilityLabel.topAnchor.constraint(equalTo: activityNameValueLabel.bottomAnchor, constant: 20),
            activityAccessibilityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            activityAccessibilityLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 15),

            activityAccessibilityValueLabel.topAnchor.constraint(
                equalTo: activityAccessibilityLabel.bottomAnchor,
                constant: 10
            ),
            activityAccessibilityValueLabel.leadingAnchor.constraint(
                equalTo: activityAccessibilityLabel.leadingAnchor
            ),
            activityAccessibilityValueLabel.trailingAnchor.constraint(
                equalTo: activityAccessibilityLabel.trailingAnchor
            ),

            activityTypeLabel.topAnchor.constraint(equalTo: activityAccessibilityValueLabel.bottomAnchor, constant: 20),
            activityTypeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            activityTypeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 15),

            activityTypeValueLabel.topAnchor.constraint(equalTo: activityTypeLabel.bottomAnchor, constant: 10),
            activityTypeValueLabel.leadingAnchor.constraint(equalTo: activityTypeLabel.leadingAnchor),
            activityTypeValueLabel.trailingAnchor.constraint(equalTo: activityTypeLabel.trailingAnchor),

            activityPriceLabel.topAnchor.constraint(equalTo: activityTypeValueLabel.bottomAnchor, constant: 20),
            activityPriceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            activityPriceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 15),

            activityPriceValueLabel.topAnchor.constraint(equalTo: activityPriceLabel.bottomAnchor, constant: 10),
            activityPriceValueLabel.leadingAnchor.constraint(equalTo: activityPriceLabel.leadingAnchor),
            activityPriceValueLabel.trailingAnchor.constraint(equalTo: activityPriceLabel.trailingAnchor),

            activityParticipantsLabel.topAnchor.constraint(equalTo: activityPriceValueLabel.bottomAnchor, constant: 20),
            activityParticipantsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            activityParticipantsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 15),

            activityParticipantsValueLabel.topAnchor.constraint(
                equalTo: activityParticipantsLabel.bottomAnchor,
                constant: 10
            ),
            activityParticipantsValueLabel.leadingAnchor.constraint(
                equalTo: activityParticipantsLabel.leadingAnchor
            ),
            activityParticipantsValueLabel.trailingAnchor.constraint(
                equalTo: activityParticipantsLabel.trailingAnchor
            ),
            activityParticipantsValueLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// MARK: - Configurable Extension

extension ActivityView: Configurable {
    typealias Configuration = ActivityInfoEntity

    func configure(content: Configuration) {
        activityTipLabel.text = content.activityTipTitleText
        activityNameValueLabel.text = content.activityInfo.activity
        activityAccessibilityLabel.text = content.activityAccessibilityTitleText
        activityAccessibilityValueLabel.text = content.activityInfo.accessibility
        activityTypeLabel.text = content.activityTypeTitleText
        activityTypeValueLabel.text = content.activityInfo.type.rawValue
        activityPriceLabel.text = content.activityPriceTitleText
        activityPriceValueLabel.text = content.activityInfo.price.rawValue
        activityParticipantsLabel.text = content.activityParticipantsTitleText
        activityParticipantsValueLabel.text = content.activityInfo.participants?.description
    }
}
