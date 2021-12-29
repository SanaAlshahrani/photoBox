//
//  adsSliderCVCell.swift
//  PhotoBox
//
//  Created by Sana Alshahrani on 20/04/1443 AH.
//

import Foundation
import UIKit
import SDWebImage
import FSPagerView

class adsSliderCVCell: UICollectionReusableView , FSPagerViewDataSource{
    static let identifier = "adsSliderCVCell"

    var imagesArray = [String]()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.clipsToBounds = true
        setupView()
        
   
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func reloadContent(){
        if imagesArray.count > 0 {
            pageControl.numberOfPages = imagesArray.count
            pagerView.reloadData()
            pagerView.reloadInputViews()
    }
    }
   

   
        
        let pagerView: FSPagerView =  {
            let pagerView = FSPagerView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400))
            
            pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            pagerView.automaticSlidingInterval = 3.0
            pagerView.isInfinite = true
            return pagerView
            
            
            
        }()
        let pageControl: FSPageControl =  {
            let pageControl = FSPageControl(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
            pageControl.contentHorizontalAlignment = .center
            pageControl.hidesForSinglePage = true
            pageControl.setFillColor(UIColor.lightGray, for: .normal)
            pageControl.setFillColor(UIColor.init(named: "witeColor")!, for: .selected)
            //        pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            return pageControl
        }()
        
        
            
      
        
        private func setupView() {
            pagerView.dataSource = self
             
            pagerView.translatesAutoresizingMaskIntoConstraints = false
            pageControl.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(pagerView)
            
           
            self.addSubview(pageControl)
            
            NSLayoutConstraint.activate([
                
                
                pagerView.topAnchor.constraint(equalTo: self.topAnchor),
                pagerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                pagerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                pagerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                pageControl.bottomAnchor.constraint(equalTo: pagerView.bottomAnchor, constant: -10),
                pageControl.trailingAnchor.constraint(equalTo: pagerView.trailingAnchor),
                pageControl.leadingAnchor.constraint(equalTo: pagerView.leadingAnchor),
               
            ])
        }
    
       
        public func numberOfItems(in pagerView: FSPagerView) -> Int {
            return imagesArray.count
        }
        
        public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
            cell.imageView?.sd_setImage(with: URL.init(string: imagesArray[index]) , completed: nil)
            cell.textLabel?.text = ""
            return cell
        }
    }
