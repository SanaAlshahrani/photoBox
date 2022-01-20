//
//  DetailsTV.swift
//  PhotoBox
//
//  Created by Sana Alshahrani on 20/04/1443 AH.
//


import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseDatabase
class DetailsTV: UIViewController {
    
    var curentModel : Model!
    
    let dImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "signup")
        image.layer.cornerRadius = 40
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    private let nameOf: UILabel = {
        let nam = UILabel()
        nam.textColor     =  UIColor.label
        nam.font          = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 20, weight: .bold))
        return nam
    }()
    private let bDescription: UILabel = {
        let description             = UILabel()
        description.textColor       =  UIColor.init(named: "witeColor")!
        description.font            = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 20, weight: .regular))
        description.numberOfLines   = 0
        description.textAlignment   = .left
        return description
    }()
    
    private let lCommint: UILabel = {
        let comment = UILabel()
        comment.textColor       =  UIColor.init(named: "BlackColor")!
        comment.backgroundColor = .photoBox
        comment.font            = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 18, weight: .regular))
        comment.numberOfLines   = 0
        comment.textAlignment   = .center
        comment.layer.cornerRadius = 20
        comment.clipsToBounds = true
        return comment
    }()
    let likeButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "heart.circle.fill"), for: .normal)
        button.tintColor = UIColor.init(named: "witeColor")!
        button.addTarget(self, action: #selector(likeButtonAction), for: .touchUpInside)
        return button
    }()
    @objc func likeButtonAction() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                let id_user =  user?.uid ?? ""
                
                if self.likeButton.tintColor == .red {
                    self.likeButton.setBackgroundImage(UIImage(systemName: "heart.circle.fill"), for: .normal)
                    self.likeButton.tintColor = UIColor.init(named: "witeColor")!
                    //remove image like
                    let ref = Database.database().reference()
                    ref.child("Public").child(self.curentModel.categoryID).child(self.curentModel.id).child("Like").child(id_user).removeValue()
                    
                    ref.child("Like").child(id_user).child(self.curentModel.id).removeValue()
                }else{
                    self.likeButton.setBackgroundImage(UIImage(systemName: "heart.circle.fill"), for: .normal)
                    self.likeButton.tintColor = .red
                    // add image like
                    let ref = Database.database().reference()
                    ref.child("Public").child(self.curentModel.categoryID).child(self.curentModel.id).child("Like").child(id_user).setValue(["id" : id_user])
                    
                    ref.child("Like").child(id_user).child(self.curentModel.id).setValue(["imageId" : self.curentModel.id ,"categoryId" : self.curentModel.categoryID])
                }
            }else{
                let alert = UIAlertController(title: "Login needed", message: "This feature requires login, please login to your account.", preferredStyle: .alert)
                
                alert.addAction(.init(title: "Login / Signup", style: .default, handler: { (action) in
                    UserDefaults.standard.set(false, forKey: "isShowLoginPrompt")
                    let vc = StartVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                }))
                
                alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
                UserDefaults.standard.set(true, forKey: "isShowLoginPrompt")
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
    }
    lazy var shareButton: UIButton = {
        let button = UIButton (type: .system)
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.up.circle"), for: .normal)
        button.setTitleColor(UIColor.init(named: "witeColor")!, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(sharePressed), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.tintColor = UIColor.init(named: "witeColor")!
        
        return button
    }()
    @objc func sharePressed (_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: [self.dImage.image], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    let commitButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "text.bubble"), for: .normal)
        button.tintColor = UIColor.init(named: "witeColor")!
        button.addTarget(self, action: #selector(commitButtonAction), for: .touchUpInside)
        return button
    }()
    @objc func commitButtonAction() {
        openAlert()
    }
    
    func openAlert(){
        let alertController = UIAlertController(title: "add comment to photo", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter comment".localized
        }
        
        let saveAction = UIAlertAction(title: "save".localized, style: .default, handler: { alert -> Void in
            if let textField = alertController.textFields?[0] {
                if textField.text!.count > 0 {
                    print("Text :: \(textField.text ?? "")")
                  
                    self.lCommint.text =  textField.text ?? ""
                    // save comment
                    Auth.auth().addStateDidChangeListener { (auth, user) in
                        if user != nil {
                            let id_user =  user?.uid ?? ""
                            
                            // add image like
                            let ref = Database.database().reference()
                            ref.child("Public").child(self.curentModel.categoryID).child(self.curentModel.id).child("Comment").child(id_user).setValue(["id" : id_user , "text" : textField.text ?? ""])
                            
                            ref.child("Comment").child(id_user).child(self.curentModel.id).setValue(["imageId" : self.curentModel.id ,"categoryId" : self.curentModel.categoryID])

                            
                        }
                    }
                }
            }})
        
        
        let cancelAction = UIAlertAction(title: "cancel".localized, style: .default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        alertController.preferredAction = saveAction
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backGround
        self.navigationItem.largeTitleDisplayMode = .never
        setupViews()
    }
    private func setupViews() {
        
        
        view.addSubview(dImage)
        dImage.translatesAutoresizingMaskIntoConstraints = false
        dImage.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 400).isActive  = true
        dImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive     = true
        dImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive  = true
        dImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive             = true
        
        view.addSubview(nameOf)
        nameOf.translatesAutoresizingMaskIntoConstraints = false
        nameOf.topAnchor.constraint(equalTo: dImage.bottomAnchor, constant: 100).isActive        = true
        nameOf.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45).isActive     = true
        nameOf.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -19).isActive  = true
        nameOf.heightAnchor.constraint(equalToConstant: 40).isActive                            = true
        
        view.addSubview(bDescription)
        bDescription.translatesAutoresizingMaskIntoConstraints                                 = false
        bDescription.topAnchor.constraint(equalTo: dImage.bottomAnchor, constant: 70).isActive          = true
        bDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45).isActive       = true
        bDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive    = true
        bDescription.heightAnchor.constraint(equalToConstant: 240).isActive                             = true
        
        
        view.addSubview(lCommint)
        lCommint.translatesAutoresizingMaskIntoConstraints                                 = false
        lCommint.topAnchor.constraint(equalTo: bDescription.bottomAnchor, constant: -50).isActive          = true
        lCommint.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive       = true
        lCommint.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive    = true
        lCommint.heightAnchor.constraint(equalToConstant: 60).isActive                             = true
        
        
        view.addSubview(likeButton)
        likeButton.topAnchor.constraint(equalTo: dImage.bottomAnchor, constant: 25).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 50).isActive                             = true
        likeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 280).isActive       = true
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                let id_user =  user?.uid ?? ""
                
                let ref = Database.database().reference()
                ref.child("Public").child(self.curentModel.categoryID).child(self.curentModel.id).child("Like").child(id_user).observeSingleEvent(of: .value, with: { snap in
                    if snap.exists()  {
                        self.likeButton.setBackgroundImage(UIImage(systemName: "heart.circle.fill"), for: .normal)
                        self.likeButton.tintColor = .red
                    }else{
                        self.likeButton.setBackgroundImage(UIImage(systemName: "heart.circle.fill"), for: .normal)
                        self.likeButton.tintColor = UIColor.init(named: "witeColor")!
                    }
                })
                
                ref.child("Public").child(self.curentModel.categoryID).child(self.curentModel.id).child("Comment").child(id_user).observeSingleEvent(of: .value) { snap in
                    if snap.exists()  {
                        //have comment
                        let valuu = snap.value as! NSDictionary
                        self.lCommint.text = valuu["text"] as? String ?? ""
                      
                    }else{
                        // dont have comment
                        self.lCommint.text = ""
                    }
                }

            }
        }
        
        view.addSubview(commitButton)
        commitButton.topAnchor.constraint(equalTo: dImage.bottomAnchor, constant: 25).isActive = true
        commitButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        commitButton.heightAnchor.constraint(equalToConstant: 50).isActive                             = true
        commitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 180).isActive       = true
        
        
        view.addSubview(shareButton)
        shareButton.topAnchor.constraint(equalTo: dImage.bottomAnchor, constant: 25).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 50).isActive                             = true
        shareButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80).isActive       = true
        
        dImage.sd_setImage(with: URL.init(string: curentModel.image), placeholderImage: UIImage.init(named: "AppIcon"))
        
        if Language.current.rawValue == "ar"{
        nameOf.text         = curentModel.name_ar
        bDescription.text   = curentModel.descripe_ar
        }else{
            nameOf.text         = curentModel.name
            bDescription.text   = curentModel.descripe
        }
        
    }
}
