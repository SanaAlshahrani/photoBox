//
//  EditProfileVC.swift
//  PhotoBox
//
//  Created by Sana Alshahrani on 20/04/1443 AH.
//


import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

class EditProfileVC: UIViewController {
    
    var curentUser : User!
    let dImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor.systemGray6
        image.layer.cornerRadius = 20
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

    lazy var editImage: UIButton = {
        let button = UIButton (type: .system)
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.up.circle"), for: .normal)
        button.setTitleColor(UIColor.init(named: "witeColor")!, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(editImageAction(_:)), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.tintColor = UIColor.init(named: "witeColor")!
        
        return button
    }()
    
    @objc func editImageAction (_ sender: UIButton) {
        // print("user image is selected")
        
        func openCameraRoll() {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary //a.photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            
            OperationQueue.main.addOperation {
                self.present(picker, animated: true, completion: nil)
            }
            
        }
        
        func openCamera() {
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                openCameraRoll()
                return
            }
            let picker = UIImagePickerController()
            picker.sourceType = .camera //a.camera //a
            picker.delegate = self
            picker.allowsEditing = true
            
            OperationQueue.main.addOperation {
                self.present(picker, animated: true, completion: nil)
            }
        }
  
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(.init(title: "Camera".localized, style: .default, handler: { (_) in
                openCamera()
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(.init(title: "Photo Library".localized, style: .default, handler: { (_) in
                openCameraRoll()
            }))
        }
    
      
        
        alert.addAction(.init(title: "Cancel".localized, style: .cancel, handler: nil))
        
        // iPad Support
        alert.popoverPresentationController?.sourceView = sender
        alert.popoverPresentationController?.sourceRect = sender.frame
        
        present(alert, animated: true, completion: nil)
    }
    

    private let lCommint: UITextField = {
        let comment = UITextField()
        comment.textColor       =  UIColor.init(named: "BlackColor")!
        comment.placeholder = "user name"

        comment.backgroundColor = .photoBox
        comment.font            = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 18, weight: .regular))
        comment.textAlignment   = .center
        comment.layer.cornerRadius = 20
        comment.clipsToBounds = true
        return comment
    }()
    private let lCommintInstgram: UITextField = {
        let comment = UITextField()
        comment.textColor       =  UIColor.init(named: "BlackColor")!
        comment.placeholder = "instagram Link"
        comment.backgroundColor = .photoBox
        comment.font            = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 18, weight: .regular))
        comment.textAlignment   = .center
        comment.layer.cornerRadius = 20
        comment.clipsToBounds = true
        return comment
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backGround
        self.navigationItem.largeTitleDisplayMode = .never
        Auth.auth().addStateDidChangeListener { [self] (auth, user) in
            if user != nil {
                let userId =  user?.uid ?? ""
                
                //Get specific document from current user
                let docRef = Firestore.firestore()
                    .collection("users")
                    .document(userId)
                
                // Get data
                docRef.getDocument { (document, error) in
                    guard let document = document, document.exists else {
                        print("Document does not exist")
                        return
                    }
                    
                    let dataDescription = document.data()
                    let user_id = dataDescription?["userID"] as? String ?? ""
                    let name = dataDescription?["name"] as? String ?? ""
                    let email = dataDescription?["email"] as? String ?? ""
                    let avatar = dataDescription?["avatar"] as? String ?? ""
                    let instagramLink = dataDescription?["instagramLink"] as? String ?? ""

                    self.curentUser = User(id: user_id, name: name, instagramLink: instagramLink , email: email, avatar: avatar)
                    self.setupViews()

                    
                }
            }
        }
    }
    private func setupViews() {
        
        
        view.addSubview(dImage)
        dImage.translatesAutoresizingMaskIntoConstraints = false
        dImage.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 400).isActive  = true
        dImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive     = true
        dImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive  = true
        dImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive             = true
        
     
        view.addSubview(lCommint)
        view.addSubview(lCommintInstgram)

        
        view.addSubview(editImage)
      
        editImage.centerXAnchor.constraint(equalTo: dImage.centerXAnchor).isActive  = true
        editImage.centerYAnchor.constraint(equalTo: dImage.centerYAnchor).isActive  = true
        editImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        editImage.heightAnchor.constraint(equalToConstant: 40).isActive = true

        view.addSubview(nameOf)
        nameOf.translatesAutoresizingMaskIntoConstraints = false
        nameOf.topAnchor.constraint(equalTo: dImage.bottomAnchor, constant: 10).isActive        = true
        nameOf.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive     = true
        nameOf.heightAnchor.constraint(equalToConstant: 40).isActive                            = true
        
        
        
        lCommint.translatesAutoresizingMaskIntoConstraints                                 = false
        lCommint.topAnchor.constraint(equalTo: nameOf.bottomAnchor, constant: 10).isActive          = true
        lCommint.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive       = true
        lCommint.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive    = true
        lCommint.heightAnchor.constraint(equalToConstant: 60).isActive                             = true
        
        lCommint.text = self.curentUser.name
        
        //
        lCommintInstgram.translatesAutoresizingMaskIntoConstraints                                 = false
        lCommintInstgram.topAnchor.constraint(equalTo: lCommint.bottomAnchor, constant: 10).isActive          = true
        lCommintInstgram.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive       = true
        lCommintInstgram.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive    = true
        lCommintInstgram.heightAnchor.constraint(equalToConstant: 60).isActive                             = true
        
        lCommintInstgram.text = self.curentUser.instagramLink ?? ""
        
        
        nameOf.text = self.curentUser.email
        if self.curentUser.avatar != ""
        {
            let url = URL(string: self.curentUser.avatar ?? "")
            self.dImage.sd_setImage(with: url, placeholderImage: UIImage(), options: .refreshCached, completed: nil)
        }


    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Get specific document from current user
        Firestore.firestore()
            .collection("users")
            .document(self.curentUser.id).setData([
            "name": self.lCommint.text ?? "",
            "instagramLink": self.lCommintInstgram.text ?? ""
        ], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
}

extension EditProfileVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
        let uuid = UUID().uuidString
        
        let storageRef = Storage.storage().reference().child("\(uuid).png")
        if let uploadData = dImage.image?.pngData() {
            
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    storageRef.downloadURL(completion: { (url, error) in
                        
                        print(url?.absoluteString)
                        completion(url?.absoluteString ?? "")
                    })
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage {
            
            self.dImage.image = image
            
     
            self.uploadMedia { imgUrl in
                
                //Get specific document from current user
                Firestore.firestore()
                    .collection("users")
                    .document(self.curentUser.id).setData([
                    "avatar": imgUrl ?? "",
                ], merge: true) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
                
            }
         
            
            
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}
