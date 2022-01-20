//
//  ImageInformationVC.swift
//  PhotoBox
//
//  Created by Sana Alshahrani on 20/04/1443 AH.
//


import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseDatabase
import IQKeyboardManagerSwift

class ImageInformationVC: UIViewController {
    
    var image : UIImage!
    var imgType = "Public"
    let dImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "signup")
        image.layer.cornerRadius = 5
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let nameOf: UITextField = {
        let nam = UITextField()
        nam.textColor       =  UIColor.init(named: "BlackColor")!
        nam.font          = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 20, weight: .bold))
        nam.backgroundColor = UIColor.init(named: "witeColor")!
        nam.placeholder = "english image name"
        nam.layer.cornerRadius = 5
        nam.clipsToBounds = true
        return nam
    }()
    
    private let nameOf_ar: UITextField = {
        let nam_ar = UITextField()
        nam_ar.textColor       =  UIColor.init(named: "BlackColor")!
        nam_ar.font          = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 20, weight: .bold))
        nam_ar.backgroundColor = UIColor.init(named: "witeColor")!
        nam_ar.placeholder = "arabic image name"
        nam_ar.layer.cornerRadius = 5
        nam_ar.clipsToBounds = true
        return nam_ar
    }()
    
    private let bDescription: IQTextView = {
        let description             = IQTextView()
        description.textColor       =  UIColor.init(named: "BlackColor")!
        description.font            = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 20, weight: .regular))
        description.textAlignment   = .left
        description.layer.cornerRadius = 5
        description.placeholder = "english description"
        description.clipsToBounds = true
        return description
    }()
    
    private let bDescription_ar: IQTextView = {
        let description_ar             = IQTextView()
        description_ar.textColor       =  UIColor.init(named: "BlackColor")!
        description_ar.font            = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 20, weight: .regular))
        description_ar.textAlignment   = .left
        description_ar.layer.cornerRadius = 5
        description_ar.placeholder = "arabic description"
        description_ar.clipsToBounds = true
        return description_ar
    }()
    
    private let labelPrivacy: UILabel = {
        let description             = UILabel()
        description.textColor       =  UIColor.init(named: "BlackColor")!
        description.font            = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 20, weight: .regular))
        description.textAlignment   = .left
        description.layer.cornerRadius = 5
        description.clipsToBounds = true
        return description
    }()

 
    private let lCommint: UIButton = {
        let comment = UIButton()
        comment.setTitleColor(UIColor.init(named: "witeColor")!, for: .normal)
        comment.backgroundColor = .photoBox
        comment.setTitle( "Save image", for: .normal)
        comment.layer.cornerRadius = 5
        comment.clipsToBounds = true
        comment.addTarget(self, action: #selector(saveImage(_:)), for: .touchUpInside)
        return comment
    }()
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backGround
        self.navigationItem.largeTitleDisplayMode = .never
        setupViews()
    }
    
    private func setupViews() {
        
        
        view.addSubview(dImage)
        dImage.translatesAutoresizingMaskIntoConstraints = false
        dImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive  = true
        dImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive     = true
        dImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive  = true
        dImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height / 2.8).isActive             = true
        
       
  
        
        
        view.addSubview(lCommint)
        lCommint.translatesAutoresizingMaskIntoConstraints                                 = false
        lCommint.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90).isActive          = true
        lCommint.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive       = true
        lCommint.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive    = true
        lCommint.heightAnchor.constraint(equalToConstant: 50).isActive                             = true
        
        view.addSubview(bDescription)
        view.addSubview(bDescription_ar)

        bDescription.translatesAutoresizingMaskIntoConstraints                                 = false
        bDescription.bottomAnchor.constraint(equalTo: bDescription_ar.topAnchor, constant: -10).isActive          = true
        bDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive       = true
        bDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive    = true
        bDescription.heightAnchor.constraint(equalToConstant: 100).isActive                             = true
        //
        bDescription_ar.translatesAutoresizingMaskIntoConstraints                                 = false
        bDescription_ar.bottomAnchor.constraint(equalTo: lCommint.topAnchor, constant: -10).isActive          = true
        bDescription_ar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive       = true
        bDescription_ar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive    = true
        bDescription_ar.heightAnchor.constraint(equalToConstant: 100).isActive  = true
        //
        view.addSubview(nameOf)
        view.addSubview(nameOf_ar)

        nameOf.translatesAutoresizingMaskIntoConstraints = false
        nameOf.bottomAnchor.constraint(equalTo: nameOf_ar.topAnchor , constant: -10).isActive        = true
        nameOf.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive     = true
        nameOf.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive  = true
        nameOf.heightAnchor.constraint(equalToConstant: 40).isActive                            = true
        //
        nameOf_ar.translatesAutoresizingMaskIntoConstraints = false
        nameOf_ar.bottomAnchor.constraint(equalTo: bDescription.topAnchor , constant: -10).isActive        = true
        nameOf_ar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive     = true
        nameOf_ar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive  = true
        nameOf_ar.heightAnchor.constraint(equalToConstant: 40).isActive  = true
        
        let nam = UILabel(frame:CGRect(x: 5, y: 20, width: 150, height: 30))
        nam.textColor     =  UIColor.label
        nam.font          = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 20, weight: .bold))
        nam.text = "Privacy"

        view.addSubview(nam)
        nam.translatesAutoresizingMaskIntoConstraints = false
        nam.topAnchor.constraint(equalTo: dImage.bottomAnchor, constant: 5).isActive  = true
        nam.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive     = true
        nam.heightAnchor.constraint(equalToConstant: 30).isActive             = true
        
        
        let switchDemo = UISwitch.init()
        switchDemo.isOn = true
        switchDemo.setOn(true, animated: false)
        imgType = "Public"
        labelPrivacy.text = imgType
        
        
        switchDemo.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)

        view.addSubview(switchDemo)
        switchDemo.translatesAutoresizingMaskIntoConstraints = false
        switchDemo.topAnchor.constraint(equalTo: nam.topAnchor, constant: 3).isActive  = true
        switchDemo.leadingAnchor.constraint(equalTo: nam.trailingAnchor, constant: 10).isActive     = true
        switchDemo.heightAnchor.constraint(equalToConstant: 30).isActive             = true
        
      
        
        view.addSubview(labelPrivacy)
        labelPrivacy.translatesAutoresizingMaskIntoConstraints = false
        labelPrivacy.topAnchor.constraint(equalTo: nam.topAnchor, constant: 5).isActive  = true
        labelPrivacy.bottomAnchor.constraint(equalTo: nam.bottomAnchor, constant: 0).isActive  = true
        labelPrivacy.leadingAnchor.constraint(equalTo: switchDemo.trailingAnchor, constant: 10).isActive     = true
        

        
        dImage.image = image
     

    }
@objc func switchValueDidChange(_ sender: UISwitch!) {
    if (sender.isOn){
        print("on")
        imgType = "Public"
        labelPrivacy.text = imgType

        
    }
    else{
        print("off")
        imgType = "Private"
        labelPrivacy.text = imgType
       

    }
    
    
}
    
    @objc func saveImage(_ sender : UIButton){
        let vc = ImageCategoryVC()
        
        vc.imagePrivacy = self.imgType
        vc.name = nameOf.text ?? ""
        vc.descreptionImg = bDescription.text ?? ""
        vc.name_ar = nameOf_ar.text ?? ""
        vc.descreptionImg_ar = bDescription_ar.text ?? ""

        vc.image = self.dImage.image
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
