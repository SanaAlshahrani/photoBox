//
//  SignupVC.swift
//  PhotoBox
//
//  Created by Sana Alshahrani on 19/04/1443 AH.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignupVC: UIViewController {
    
    let db = Firestore.firestore().collection("users")
            let containerV: UIView = {
            let view = UIView()
            view.backgroundColor = .photoBox
            view.layer.borderWidth = 0.45
            view.layer.borderColor = UIColor.init(named: "witeColor")!.cgColor
            view.layer.cornerRadius = 40
             return view
        }()
        let titlelabel: UILabel = {
            let title = UILabel()
            title.backgroundColor = .clear
            title.text = "Creating an account to use PhotoBox App 📷 ".localized
            title.font = UIFont.systemFont(ofSize: 25,weight: .bold)
            title.textColor = UIColor.init(named: "witeColor")!
            title.textAlignment = .center
            title.numberOfLines = 0
            return title
        }()
        let emailTF: UITextField = {
            let tF = UITextField()
//            tF.text = "saa22@gmail.com"
            tF.setupTF(with: NSAttributedString(string: "Email".localized,
                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(named: "witeColor")!]))
            return tF
        }()
        let passTF: UITextField = {
         let tF2 = UITextField()
//            tF2.text = "1234567890"
            tF2.setupTF(with: NSAttributedString(string: "Password".localized,
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(named: "witeColor")!]))
            tF2.isSecureTextEntry = true
            return tF2
       }()
       let nameTF: UITextField = {
       let tf3 = UITextField()
//           tf3.text = "Sana Alshahrani"
           tf3.setupTF(with: NSAttributedString(string: "Name".localized,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(named: "witeColor")!]))
           return tf3
       }()
       let button: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = UIColor(#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 0.7583557533))
           btn.setupButton(with: "Create Acount".localized)
        return btn
       }()
        override func viewDidLoad() {
        super.viewDidLoad()
            view.backgroundColor = .backGround
        setupViews()
        }
        private func setupViews() {
        
        view.addSubview(containerV)
        containerV.translatesAutoresizingMaskIntoConstraints = false
        containerV.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerV.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerV.widthAnchor.constraint(equalToConstant: 325).isActive = true
        containerV.heightAnchor.constraint(equalToConstant: 395).isActive = true
        
        containerV.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.bottomAnchor.constraint(equalTo: containerV.bottomAnchor, constant: -20).isActive = true
        button.leadingAnchor.constraint(equalTo: containerV.leadingAnchor, constant: 100).isActive = true
        button.trailingAnchor.constraint(equalTo: containerV.trailingAnchor, constant: -100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        containerV.addSubview(passTF)
        passTF.translatesAutoresizingMaskIntoConstraints = false
        passTF.delegate = self
        passTF.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -20).isActive = true
        passTF.leadingAnchor.constraint(equalTo: containerV.leadingAnchor, constant: 20).isActive = true
        passTF.trailingAnchor.constraint(equalTo: containerV.trailingAnchor, constant: -20).isActive = true
        passTF.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        containerV.addSubview(emailTF)
        emailTF.translatesAutoresizingMaskIntoConstraints = false
        emailTF.delegate = self
        emailTF.bottomAnchor.constraint(equalTo: passTF.topAnchor, constant: -10).isActive = true
        emailTF.leadingAnchor.constraint(equalTo: containerV.leadingAnchor, constant: 20).isActive = true
        emailTF.trailingAnchor.constraint(equalTo: containerV.trailingAnchor, constant: -20).isActive = true
        emailTF.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        containerV.addSubview(nameTF)
        nameTF.translatesAutoresizingMaskIntoConstraints = false
        nameTF.delegate = self
        nameTF.bottomAnchor.constraint(equalTo: emailTF.topAnchor, constant: -10).isActive = true
        nameTF.leadingAnchor.constraint(equalTo: containerV.leadingAnchor, constant: 20).isActive = true
        nameTF.trailingAnchor.constraint(equalTo: containerV.trailingAnchor, constant: -20).isActive = true
        nameTF.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        containerV.addSubview(titlelabel)
        titlelabel.translatesAutoresizingMaskIntoConstraints = false
        titlelabel.bottomAnchor.constraint(equalTo: nameTF.topAnchor, constant: -5).isActive = true
        titlelabel.leadingAnchor.constraint(equalTo: containerV.leadingAnchor, constant: 20).isActive = true
        titlelabel.topAnchor.constraint(equalTo: containerV.topAnchor, constant: 20).isActive = true
        titlelabel.trailingAnchor.constraint(equalTo: containerV.trailingAnchor, constant: -20).isActive = true
    }
    @objc private func buttonTapped() {
        guard let email = emailTF.text else {return}
        guard let password = passTF.text else {return}
        guard let name = nameTF.text else {return}
        
        if !email.isEmpty && !password.isEmpty && !name.isEmpty{
            signupUserUsing(email: email, password: password, name: name)
        }else{
            let alert = UIAlertController(title: "Oops!", message: "please make sure name, email and password are not empty.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            present(alert, animated: true)
        }
    }
       private func signupUserUsing(email: String, password: String, name: String) {
            Auth.auth().createUser(withEmail: email, password: password) { results, error in
                
                if let error = error as NSError? {
                    switch AuthErrorCode(rawValue: error.code) {
                    case .emailAlreadyInUse:
                        
                        let alert = UIAlertController(title: "Oops!", message: "email Already in use", preferredStyle: .alert)
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
                        "name": name,
                        "email": String(user.email!),
                        "userID": user.uid,
                    ], merge: true) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                    
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
                
            }
        }
       
    }
extension SignupVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        emailTF.resignFirstResponder()
        passTF.resignFirstResponder()
        nameTF.resignFirstResponder()
        return true
    }
}

