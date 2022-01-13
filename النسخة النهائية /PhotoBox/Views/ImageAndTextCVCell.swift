//
//  ImageAndTextCVCell.swift
//  PhotoBox
//
//  Created by Sana Alshahrani on 20/04/1443 AH.
//

import Foundation
import UIKit
import SDWebImage
class ImageAndTextCVCell: UICollectionViewCell {
    static let identifier = "ImageAndTextCVCell"
    
    private let imageV: UIImageView = {
        let imagev = UIImageView()
        imagev.contentMode = .scaleAspectFill
        imagev.translatesAutoresizingMaskIntoConstraints = false
        imagev.layer.borderWidth = 0.25
        imagev.layer.borderColor = UIColor.init(named: "witeColor")!.cgColor
        imagev.clipsToBounds = true
      
        return imagev
    }()
     let imageChecklist: UIImageView = {
        let imagev = UIImageView.init(frame: CGRect.init(x: 5, y: 5, width: 30, height: 30))
        imagev.contentMode = .scaleAspectFit
        imagev.clipsToBounds = true
        imagev.image = UIImage.init(named: "checklist")
      
        return imagev
    }()
    
    private let tintView: UIView = {
        let tintView = UIView()
        tintView.backgroundColor = UIColor(white: 0, alpha: 0.5) //change to your liking
        
        
        tintView.frame = CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.size.width / 2), height: 100)

        return tintView
    }()
    
    private let labelV: UILabel = {
        let labelV = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 150, height: 30))
        labelV.textColor = UIColor.init(named: "witeColor")!
        labelV.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return labelV
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(imageV)
       
        imageV.addSubview(tintView)
        imageV.addSubview(imageChecklist)

        contentView.addSubview(labelV)
        labelV.center = contentView.center

        contentView.clipsToBounds = true
       
        
        NSLayoutConstraint.activate([
            imageV.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageV.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            labelV.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            labelV.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
       }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func configure(image: String , titel : String) {
        imageV.layer.cornerRadius = 20
        imageV.sd_setImage(with: URL.init(string: image), placeholderImage: UIImage.init(named: "AppIcon"))
        labelV.text = titel
    }
    
 
}
