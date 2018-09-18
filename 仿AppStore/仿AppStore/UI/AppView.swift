//
//  AppView.swift
//  仿AppStore
//
//  Created by 谢汝 on 2018/9/15.
//  Copyright © 2018年 谢汝. All rights reserved.
//

import UIKit

class AppView: UIView {

    
    // MARK: Data
    private let appViewType: AppViewType
    var viewModel: AppViewModel
    
    var backgroundType: BackgroundType = .light {
        didSet {
            titleLabel.textColor = backgroundType.titleTextColor
            subtitleLabel.textColor = backgroundType.subtitleTextColor
            buttonSubtitleLabel.textColor = backgroundType.subtitleTextColor
        }
    }
    
    
    // MARK: UI
    fileprivate var iconImageView = UIImageView()
    fileprivate var titleLabel = UILabel()
    fileprivate var getButton = UIButton(type: UIButton.ButtonType.roundedRect)
    fileprivate var subtitleLabel = UILabel()
    fileprivate var buttonSubtitleLabel = UILabel()
    fileprivate var labelsView = UIView()
    fileprivate var detailsStackView = UIStackView()
    
    init?(_ viewModel: AppViewModel?) {
        guard let viewModel = viewModel else { return nil }
        self.viewModel = viewModel
        self.appViewType = viewModel.appViewType
        super.init(frame: .zero)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews() {
        configureViews()
        
        
        
    }
    
    
    private func configureViews() {
        iconImageView.configureAppIconView(forImage: viewModel.iconImage, size: appViewType.imageSize)
        
        titleLabel.configureAppHeaderLabel(withText: viewModel.name)
        titleLabel.textColor = backgroundType.titleTextColor
        
        subtitleLabel.configureAppSubHeaderLabel(withText: viewModel.category.description.uppercasedFirstLetter)
        subtitleLabel.textColor = backgroundType.subtitleTextColor
        
        buttonSubtitleLabel.configureTinyLabel(withText: "In-App Purchases")
        buttonSubtitleLabel.textColor = backgroundType.subtitleTextColor
    }
    
    private func configureLabelsView() {
        labelsView.addSubview(subtitleLabel)
        
    }
    
}
