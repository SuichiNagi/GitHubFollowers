//
//  GHFAlertVC.swift
//  GitHubFollowers
//
//  Created by Aldrei Glenn Nuqui on 6/20/24.
//

import UIKit

class GHFAlertVC: UIViewController {
    
    let padding: CGFloat = 20
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    init(alertTitle: String? = nil, message: String? = nil, buttonTitle: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = alertTitle
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    func setUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        
//        setAutoLayoutConstraint()
        setSnpConstraints()
    }
    
    func setAutoLayoutConstraint() {
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(actionButton)
        containerView.addSubview(bodyMessageLabel)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
            
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
            
            bodyMessageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bodyMessageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            bodyMessageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            bodyMessageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ])
    }
    
    func setSnpConstraints() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(view)
            make.width.equalTo(280)
            make.height.equalTo(220)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(containerView).offset(padding)
            make.trailing.equalTo(containerView).offset(-padding)
            make.height.equalTo(28)
        }
        
        containerView.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(containerView).offset(-padding)
            make.leading.equalTo(containerView).offset(padding)
            make.height.equalTo(44)
        }
        
        containerView.addSubview(bodyMessageLabel)
        bodyMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(containerView).offset(padding)
            make.trailing.equalTo(containerView).offset(-padding)
            make.bottom.equalTo(actionButton.snp.top).offset(-12)
        }
    }
    
    lazy var containerView: UIView = {
        let container = UIView()
        container.backgroundColor       = .systemBackground
        container.layer.cornerRadius    = 16
        container.layer.borderWidth     = 2
        container.layer.borderColor     = UIColor.white.cgColor
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    lazy var titleLabel: GHFTitleLabel = {
        let label  = GHFTitleLabel(textAlignment: .center, fontSize: 20)
        label.text = alertTitle ?? "Something went wrong"
        return label
    }()
    
    lazy var actionButton: GHFButton = {
        let button = GHFButton(backgroundColor: .systemPink, title: "Ok")
        button.setTitle(buttonTitle ?? "Ok", for: .normal)
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        return button
    }()
    
    lazy var bodyMessageLabel: GHFBodyLabel = {
        let messageLabel                = GHFBodyLabel(textAlignment: .center)
        messageLabel.text               = message ?? "Unable to complete request"
        messageLabel.numberOfLines      = 4
        return messageLabel
    }()
}
