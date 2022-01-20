//
//  ChatsCell.swift
//  PhotoBox
//
//  Created by Sana Alshahrani on 20/04/1443 AH.
//

import Foundation
import UIKit
import SDWebImage

class chats{
    
    var senderName: String
    var message: String
    var senderImage: String
    var time: String

    init(senderName: String, message:String, senderImage:String, time:String) {
        
        self.senderName = senderName
        self.message = message
        self.senderImage = senderImage
        self.time = time
        
    }
    
}


class ChatsCell: UITableViewCell {

  
        static let identifier = "ChatsCell"
        
         let senderImageView: UIImageView = {
            let imagev = UIImageView.init(frame: CGRect.init(x: 10, y: 0, width: 90, height: 90))
            imagev.contentMode = .scaleAspectFill
            imagev.translatesAutoresizingMaskIntoConstraints = false
            imagev.layer.borderWidth = 0.25
            imagev.layer.borderColor = UIColor.init(named: "witeColor")!.cgColor
            imagev.clipsToBounds = true
          
            return imagev
        }()

        
         let descLbl: UILabel = {
            let labelV = UILabel.init(frame: CGRect.init(x: 110, y: 0, width: 200, height: 30))
            labelV.textColor = UIColor.init(named: "BlackColor")!
            labelV.font = UIFont.systemFont(ofSize: 16, weight: .regular)
             labelV.translatesAutoresizingMaskIntoConstraints = false

            return labelV
        }()
        
         let timeLbl: UILabel = {
            let labelV = UILabel.init(frame: CGRect.init(x: 110, y: 90, width: 200, height: 30))
            labelV.textColor = UIColor.init(named: "BlackColor")!
            labelV.font = UIFont.systemFont(ofSize: 10, weight: .regular)
             labelV.translatesAutoresizingMaskIntoConstraints = false

            return labelV
        }()
        
         let senderNameLbl: UILabel = {
            let labelV = UILabel.init(frame: CGRect.init(x: 110, y: 0, width: 200, height: 30))
            labelV.textColor = UIColor.init(named: "BlackColor")!
            labelV.font = UIFont.systemFont(ofSize: 25, weight: .bold)
             labelV.translatesAutoresizingMaskIntoConstraints = false

            return labelV
        }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style , reuseIdentifier: reuseIdentifier )
            contentView.addSubview(senderImageView)
            contentView.addSubview(senderNameLbl)
            contentView.addSubview(timeLbl)
            contentView.addSubview(descLbl)
   

            contentView.clipsToBounds = true
           
            
            NSLayoutConstraint.activate([
                senderImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                senderImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                senderImageView.widthAnchor.constraint(equalToConstant: 90.0),
                senderImageView.heightAnchor.constraint(equalToConstant: 90.0),
                
                
                senderNameLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                senderNameLbl.leadingAnchor.constraint(equalTo: senderImageView.trailingAnchor, constant: 10),
                senderNameLbl.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
              
                descLbl.leadingAnchor.constraint(equalTo: senderImageView.trailingAnchor, constant: 10),
                descLbl.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                descLbl.topAnchor.constraint(equalTo: senderNameLbl.bottomAnchor, constant: 10),
                
                timeLbl.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
                timeLbl.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),

            ])
           }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
    
        
     
    }
