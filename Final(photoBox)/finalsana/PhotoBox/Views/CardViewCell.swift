//
//  CardViewCell.swift
//  JYCardView
//
//  Created by Sana Alshahrani on 20/04/1443 AH.
//
//

import UIKit
import SDWebImage

class CardViewCell: UICollectionViewCell {
    static let cellID = "CardViewCellID"
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    
    var cardViewModel: Video? {
        didSet {
            guard let cardViewModel = cardViewModel else { return }
            imageView.sd_setImage(with: URL(string: cardViewModel.image), completed: nil)
            titleLabel.text = cardViewModel.name
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func setupSubviews() {
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
        
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        let constraints = [
        
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    

}
