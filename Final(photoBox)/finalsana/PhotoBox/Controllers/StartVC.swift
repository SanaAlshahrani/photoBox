//
//  StartVC.swift
//  PhotoBox
//
//  Created by Sana Alshahrani on 19/04/1443 AH.
//
import UIKit
import FirebaseAuth

class StartVC: UIViewController {
    
    let containerV: UIView = {
        let view = UIView()
        
        view.backgroundColor = .photoBox
        view.layer.borderWidth = 0.45
        view.layer.borderColor = UIColor.init(named: "witeColor")!.cgColor
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        return view
    }()
    let subTitleLabel: UILabel = {
        let title = UILabel()
        title.text = "Sana Alshahrani"
        title.textColor = .label
        title.font = UIFont.systemFont(ofSize: 20, weight: .light)
        title.textAlignment = .center
        title.textColor = UIColor.init(named: "witeColor")
        title.numberOfLines = 0
        return title
    }()
    let designImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "start1")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 40
        return image
    }()
    let titleLabel: UILabel = {
        let title = UILabel()
        title.backgroundColor = .clear
        title.text = "Welcome to PhotoBox App"
        title.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        title.textColor = UIColor.init(named: "witeColor")!
        title.textAlignment = .center
        title.numberOfLines = 0
        return title
    }()
    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setupButton(with:"Sign up")
        return button
    }()
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setupButton(with: "Log in")
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupViews()
        setupLabels()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if SignedIn() {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func setupViews() {
        view.addSubview(containerV)
        containerV.translatesAutoresizingMaskIntoConstraints = false
        containerV.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerV.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerV.widthAnchor.constraint(equalToConstant: 325).isActive = true
        containerV.heightAnchor.constraint(equalToConstant: 395).isActive = true
        
        let stack1 = UIStackView(arrangedSubviews: [signInButton,loginButton])
        
        containerV.addSubview(stack1)
        stack1.distribution = .fillEqually
        stack1.spacing = 10
        stack1.translatesAutoresizingMaskIntoConstraints = false
        stack1.bottomAnchor.constraint(equalTo: containerV.bottomAnchor, constant: -40).isActive = true
        stack1.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stack1.widthAnchor.constraint(equalToConstant: 250).isActive = true
        stack1.centerXAnchor.constraint(equalTo: containerV.centerXAnchor).isActive = true
        
        loginButton.addTarget(self, action: #selector(loginButtonTap), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signInButtonTap), for: .touchUpInside)
        
        containerV.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: containerV.topAnchor, constant: 190).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: containerV.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: containerV.widthAnchor).isActive = true
        
        containerV.addSubview(designImage)
        designImage.translatesAutoresizingMaskIntoConstraints = false
        designImage.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -30).isActive = true
        designImage.leadingAnchor.constraint(equalTo: containerV.leadingAnchor, constant: 30).isActive = true
        designImage.trailingAnchor.constraint(equalTo: containerV.trailingAnchor, constant: -30).isActive = true
        designImage.topAnchor.constraint(equalTo: containerV.topAnchor, constant: 30).isActive = true
    }
    private func setupLabels() {
        
        view.addSubview(subTitleLabel)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 750).isActive = true
        subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive
         = true
        subTitleLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    @objc private func loginButtonTap() {
        navigationController?.pushViewController(LoginVC(), animated: true)
    }
    @objc private func signInButtonTap() {
        navigationController?.pushViewController(SignupVC(), animated: true)
    }
    private func SignedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
}
