//
//  PlacesVediosCell.swift
//  PhotoBox
//
//  Created by Sana Alshahrani on 20/04/1443 AH.
//

import Foundation
import UIKit
import SDWebImage

class PlacesVediosCell: UICollectionViewCell {
    static let identifier = "PlacesVediosCell"
    
    private let imageV: UIImageView = {
        let imagev = UIImageView()
        imagev.contentMode = .scaleAspectFill
        imagev.translatesAutoresizingMaskIntoConstraints = false
        imagev.layer.borderWidth = 0.25
        imagev.layer.borderColor = UIColor.init(named: "witeColor")!.cgColor
        imagev.layer.cornerRadius = 8
        imagev.clipsToBounds = true
      
        return imagev
    }()
 
    private let labelV: UILabel = {
        let labelV = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 150, height: 30))
        labelV.textColor = UIColor.init(named: "BlackColor")!
        labelV.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        labelV.translatesAutoresizingMaskIntoConstraints = false
        labelV.numberOfLines = 0

        return labelV
    }()
    
    private let labelDes: UILabel = {
        let labelDes = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 150, height: 30))
        labelDes.textColor = UIColor.init(named: "BlackColor")!
        labelDes.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        labelDes.translatesAutoresizingMaskIntoConstraints = false
        labelDes.numberOfLines = 0
        return labelDes
    }()
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(imageV)
       
        contentView.addSubview(labelV)
        contentView.addSubview(labelDes)

        labelV.center = contentView.center

        contentView.clipsToBounds = true
       
        
        NSLayoutConstraint.activate([
            imageV.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageV.heightAnchor.constraint(equalTo: imageV.widthAnchor),

            labelV.topAnchor.constraint(equalTo: imageV.bottomAnchor , constant: 5),
            labelV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 5),
            labelV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor , constant: -5),
            
            labelDes.topAnchor.constraint(equalTo: labelV.bottomAnchor , constant: 5),
            labelDes.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 5),
            labelDes.trailingAnchor.constraint(equalTo: contentView.trailingAnchor , constant: -5)
        ])
       }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func configure(image: String , titel : String , descreption : String) {
        imageV.sd_setImage(with: URL.init(string: image), placeholderImage: UIImage.init(named: "AppIcon"))
        labelV.text = titel
        labelDes.text = descreption
    }
    
 
}
