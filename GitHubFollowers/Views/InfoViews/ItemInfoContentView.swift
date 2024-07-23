//
//  ItemInfoContentView.swift
//  GitHubFollowers
//
//  Created by Aldrei Glenn Nuqui on 6/27/24.
//

import UIKit

class ItemInfoContentView: UIView {
    
    let padding: CGFloat = 20

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        layer.cornerRadius = 18
        backgroundColor    = .secondarySystemBackground
        
        addSubviews(stackView, actionButton)
        
//        setAutoLayoutConstraints()
        setSnpConstraints()
    }
    
    @objc func actionButtonTapped() {}
    
    func setAutoLayoutConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func setSnpConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.leading.equalTo(self).offset(padding)
            make.trailing.equalTo(self).offset(-padding)
            make.height.equalTo(50)
        }
        
        actionButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(self).offset(-padding)
            make.leading.equalTo(self).offset(padding)
            make.height.equalTo(44)
        }
    }
    
    lazy var stackView: UIStackView = {
        let stackV          = UIStackView()
        stackV.axis         = .horizontal
        stackV.distribution = .equalSpacing
        stackV.addArrangedSubview(itemInfoViewOne)
        stackV.addArrangedSubview(itemInfoViewTwo)
        stackV.translatesAutoresizingMaskIntoConstraints = false
        return stackV
    }()
    
    lazy var itemInfoViewOne: ItemInfoView = {
        let itemInfo = ItemInfoView()
        return itemInfo
    }()
    
    lazy var itemInfoViewTwo: ItemInfoView = {
        let itemInfo = ItemInfoView()
        return itemInfo
    }()
    
    lazy var actionButton: GHFButton = {
        let button = GHFButton()
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
}
