//
//  UserCell.swift
//  PhotoBox
//
//  Created by Sana Alshahrani on 20/04/1443 AH.
//

import Foundation
import UIKit
import SDWebImage

class UserCell: UICollectionViewCell {
    static let identifier = "UserCell"
    
    private let imageV: UIImageView = {
        let imagev = UIImageView.init(frame: CGRect.init(x: 10, y: 0, width: 90, height: 90))
        imagev.contentMode = .scaleAspectFill
        imagev.translatesAutoresizingMaskIntoConstraints = false
        imagev.layer.borderWidth = 0.25
        imagev.layer.borderColor = UIColor.init(named: "BlackColor")!.cgColor
        imagev.clipsToBounds = true
      
        return imagev
    }()

     let buttonChat: UIButton = {
        let buttonChat = UIButton.init(frame: CGRect.init(x: 110, y: 0, width: 200, height: 30))
     
        buttonChat.setImage(UIImage(named: "checklist"), for: .normal)
        buttonChat.tintColor = UIColor.init(named: "BlackColor")!
     
        buttonChat.translatesAutoresizingMaskIntoConstraints = false

        return buttonChat
    }()

    
    private let labelV: UILabel = {
        let labelV = UILabel.init(frame: CGRect.init(x: 110, y: 0, width: 200, height: 30))
     
            labelV.textColor = UIColor.init(named: "BlackColor")!

     
        labelV.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        labelV.translatesAutoresizingMaskIntoConstraints = false

        return labelV
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(imageV)
       
      
        contentView.addSubview(labelV)
        contentView.addSubview(buttonChat)

        labelV.center = contentView.center

        contentView.clipsToBounds = true
       
        
        NSLayoutConstraint.activate([
            imageV.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageV.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 100),

            imageV.widthAnchor.constraint(equalToConstant: 90.0),
            imageV.heightAnchor.constraint(equalToConstant: 90.0),

            labelV.leadingAnchor.constraint(equalTo: imageV.trailingAnchor, constant: 10),
            labelV.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            labelV.centerYAnchor.constraint(equalTo: imageV.centerYAnchor),
            
            buttonChat.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            buttonChat.topAnchor.constraint(equalTo: self.labelV.topAnchor, constant: -10),
            buttonChat.widthAnchor.constraint(equalToConstant: 40.0),
            buttonChat.heightAnchor.constraint(equalToConstant: 40.0),

            
        ])
       }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func configure(image: String , titel : String) {
        imageV.layer.cornerRadius = 45
        imageV.sd_setImage(with: URL.init(string: image), placeholderImage: UIImage.init(named: "AppIcon"))
        labelV.text = titel
    }
    
 
}
