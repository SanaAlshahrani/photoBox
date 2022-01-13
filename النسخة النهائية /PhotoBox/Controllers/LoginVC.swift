//
//  LoginVC.swift
//  PhotoBox
//
//  Created by Sana Alshahrani on 19/04/1443 AH.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginVC: UIViewController {
    
    let db = Firestore.firestore().collection("users")
    
      let containerV: UIView = {
        let view = UIView()
          view.backgroundColor = .photoBox
          view.layer.borderWidth = 0.25
          view.layer.borderColor = UIColor.init(named: "witeColor")!.cgColor
          view.layer.cornerRadius = 40
          view.clipsToBounds = true
          return view
    }()
        let designImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "signup")
        image.layer.cornerRadius = 40
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
        
        let emailTF: UITextField = {
        let tF = UITextField()
            tF.text = "saa22@gmail.com"
        tF.setupTF(with: NSAttributedString(string: "Email",
                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(named: "witeColor")!]))
        return tF
    }()
    
    let passTF: UITextField = {
        let tF1 = UITextField()
        tF1.text = "1234567890"
        tF1.setupTF(with: NSAttributedString(string: "Password",
                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(named: "witeColor")!]))
        tF1.isSecureTextEntry = true
        return tF1
    }()
    
        let Button: UIButton = {
        let btn = UIButton(type: .system)
            btn.setupButton(with: "Log in".localized)
        return btn
    }()
    
        override func viewDidLoad() {
        super.viewDidLoad()
            
        view.backgroundColor = .backGround
        setupViews()
            
        self.navigationController?.navigationBar.isHidden = true
    }
        private func setupViews() {
        
        view.addSubview(containerV)
        containerV.translatesAutoresizingMaskIntoConstraints = false
        containerV.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerV.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerV.widthAnchor.constraint(equalToConstant: 325).isActive = true
        containerV.heightAnchor.constraint(equalToConstant: 415).isActive = true
        
        containerV.addSubview(Button)
        Button.translatesAutoresizingMaskIntoConstraints = false
        Button.addTarget(self, action: #selector(loginUserTapped), for: .touchUpInside)
        Button.bottomAnchor.constraint(equalTo: containerV.bottomAnchor, constant: -20).isActive = true
        Button.leadingAnchor.constraint(equalTo: containerV.leadingAnchor, constant: 80).isActive = true
        Button.trailingAnchor.constraint(equalTo: containerV.trailingAnchor, constant: -80).isActive = true
        Button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        containerV.addSubview(passTF)
        passTF.translatesAutoresizingMaskIntoConstraints = false
        passTF.delegate = self
        passTF.bottomAnchor.constraint(equalTo: Button.topAnchor, constant: -15).isActive = true
        passTF.leadingAnchor.constraint(equalTo: containerV.leadingAnchor, constant: 30).isActive = true
        passTF.trailingAnchor.constraint(equalTo: containerV.trailingAnchor, constant: -30).isActive = true
        passTF.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        containerV.addSubview(emailTF)
        emailTF.translatesAutoresizingMaskIntoConstraints = false
        emailTF.delegate = self
        emailTF.bottomAnchor.constraint(equalTo: passTF.topAnchor, constant: -20).isActive = true
        emailTF.leadingAnchor.constraint(equalTo: containerV.leadingAnchor, constant: 30).isActive = true
        emailTF.trailingAnchor.constraint(equalTo: containerV.trailingAnchor, constant: -30).isActive = true
        emailTF.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        containerV.addSubview(designImage)
        designImage.translatesAutoresizingMaskIntoConstraints = false
        designImage.bottomAnchor.constraint(equalTo: emailTF.topAnchor, constant: -30).isActive  = true
        designImage.leadingAnchor.constraint(equalTo: containerV.leadingAnchor, constant: 30).isActive     = true
        designImage.trailingAnchor.constraint(equalTo: containerV.trailingAnchor, constant: -30).isActive  = true
        designImage.topAnchor.constraint(equalTo: containerV.topAnchor, constant: 30).isActive             = true
        
    }
    @objc private func loginUserTapped() {
        
    
        guard let email = emailTF.text else {return}
        guard let password = passTF.text else {return}
        
        if !email.isEmpty && !password.isEmpty {
            loginUsing(email: email, password: password)
        }else{
            let alert = UIAlertController(title: "Oops!", message: "please make sure email and password are not empty.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            present(alert, animated: true)
            
        }
        
    }
    private func loginUsing(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { results, error in
            
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .wrongPassword:
                    
                    let alert = UIAlertController(title: "Oops!", message: "you entered a wrong password", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    
                case .invalidEmail:
                    
                    let alert = UIAlertController(title: "Oops!", message: "are sure you typed the email correctly?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    
                case .weakPassword:
                    
                    let alert = UIAlertController(title: "Oops!", message: "Your password is weak, please make sure it's strong.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    
                default:
                    
                    let alert = UIAlertController(title: "Oops!", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    
                }
            }else{
               
                guard let user = results?.user else {return}
                
                self.db.document(user.uid).setData([
                    "email": String(user.email!),
                    "userID": user.uid,
                    "status": "yes"
                ], merge: true) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
                

             
                                let vc = CategoryVC()
                                let nav = UINavigationController()
                                nav.viewControllers = [vc]
                                nav.modalPresentationStyle = .fullScreen
                                nav.modalTransitionStyle = .flipHorizontal
                                self.present(nav, animated: true, completion: nil)
                             

            }
            
        }
    }

}
extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        emailTF.resignFirstResponder()
        passTF.resignFirstResponder()
        
        return true
    }
}
