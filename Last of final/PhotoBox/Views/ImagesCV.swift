//
//  ImagesCollectionV.swift
//  PhotoBox
//
//  Created by Sana Alshahrani on 20/04/1443 AH.
//

import CHTCollectionViewWaterfallLayout
import UIKit
import FirebaseAuth
import FirebaseDatabase

class ImagesCV: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , CHTCollectionViewDelegateWaterfallLayout {
    
    var filterPhotos: [Model] = []
    var photos: [Model] = []
    var adsImages: [String] = []
    
    public func setupSearchBar() {
        
        search.loadViewIfNeeded()
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.returnKeyType = .done
        search.searchBar.sizeToFit()
        search.searchBar.placeholder = "Search for a photo".localized
        search.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = true
        search.searchBar.delegate = self
    }
    
    
    
    let search = UISearchController()
    
    lazy var collectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.itemRenderDirection = .leftToRight
        layout.columnCount = 2
        
        
        let collectionV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionV.register(ImageCVCell.self,forCellWithReuseIdentifier: ImageCVCell.identifier)
        collectionV.register(adsSliderCVCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: adsSliderCVCell.identifier)
        
        collectionV.translatesAutoresizingMaskIntoConstraints = false
        collectionV.delegate = self
        collectionV.dataSource = self
        return collectionV
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "PhotoBox"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView.backgroundColor = .backGround
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        setupSearchBar()
        
        //
        self.adsImages.removeAll()
        Database.database().reference().child("Ads").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get Category value
            let value = (snapshot.value as? NSDictionary)?.allValues
            if value != nil {
                for curentAds in value!{
                    let value = (curentAds as? NSDictionary)
                    let image = value?["image"] as? String ?? ""
                    self.adsImages.append(image)
                    
                }
            }
            
        })
        
        //
        photos.removeAll()
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                let id_user =  user?.uid ?? ""
                let ref = Database.database().reference()
                // get category
                ref.child("User").child(id_user).child("Category").observeSingleEvent(of: .value) { snapshot in
                    let value = (snapshot.value as? NSDictionary)?.allValues
                    var categoriesCount = (snapshot.value as? NSDictionary)?.allValues.count ?? 0
                    var loopCategoriesCount = 0
                    if value != nil {
                        for curentCategory in value!{
                            loopCategoriesCount = loopCategoriesCount + 1
                            
                            let itemID = (curentCategory as? NSDictionary)
                            // get images
                            let item_id = itemID?["id"] as? String ?? ""
                            
                            ref.child("Public").child(item_id).observeSingleEvent(of: .value, with: { (snapshot) in
                                // Get Category value
                                let value = (snapshot.value as? NSDictionary)?.allValues
                                if value != nil {
                                    for curentCategory in value!{
                                        let value = (curentCategory as? NSDictionary)
                                        let name = value?["name"] as? String ?? ""
                                        let id = value?["id"] as? String ?? ""
                                        let image = value?["image"] as? String ?? ""
                                        let descripe = value?["descripe"] as? String ?? ""
                                        let userID = value?["userID"] as? String ?? ""
                                        let name_ar = value?["name_ar"] as? String ?? ""
                                        let descripe_ar  = value?["descripe_ar"] as? String ?? ""
                                        
                                        let mm = Model.init(image: image, name: name, descripe: descripe, name_ar: name_ar , descripe_ar: descripe_ar, id: id, categoryID: item_id, userID: userID)
                                        
                                        if !self.photos.contains(where: { m1 in
                                            return mm.userID == m1.userID && mm.name == m1.name && mm.name_ar == m1.name_ar && mm.descripe == m1.descripe && mm.descripe_ar == m1.descripe_ar
                                        }) {
                                            self.photos.append(mm)
                                        }
                                       
                                        
                                    }
                                }
                                // after add all images in category check if this last category reload content
                                   
                                    if loopCategoriesCount == (categoriesCount){
                                        self.collectionView.reloadData()
                                       

                                    }
                                
                            })
                            
                        }
                    }
                }
                
                
                
            }else{
                
                // get categories from User Defaults
                let defaults = UserDefaults.standard
                var myarray: [ModelCategory] {
                    let defaultObject = ModelCategory.init(image: "", name: "", id: "", name_ar: "")
                    if let objects = UserDefaults.standard.value(forKey: "SavedCategoryArray") as? Data {
                        let decoder = JSONDecoder()
                        if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [ModelCategory] {
                            return objectsDecoded
                        } else {
                            return [defaultObject]
                        }
                    } else {
                        return [defaultObject]
                    }
                }
                
                let categoriesCount = myarray.count
                var loopCategoriesCount = 0
                //
                
                for item in myarray{
                    // get images
                    let itemID = (item as! ModelCategory)
                    let item_id = itemID.id
                    
                    if item_id.count > 0 {
                        // if have categories from User Defaults
                        // get all images at this category
                        let ref = Database.database().reference()
                        ref.child("Public").child(item_id).observeSingleEvent(of: .value, with: { (snapshot) in
                            // Get Category value
                            loopCategoriesCount = loopCategoriesCount + 1
                            
                            let allImagesInCategory = (snapshot.value as? NSDictionary)?.allValues
                            if allImagesInCategory != nil {
                                for curentImage in allImagesInCategory!{
                                    let value = (curentImage as? NSDictionary)
                                    let name = value?["name"] as? String ?? ""
                                    let id = value?["id"] as? String ?? ""
                                    let image = value?["image"] as? String ?? ""
                                    let descripe = value?["descripe"] as? String ?? ""
                                    let userID = value?["userID"] as? String ?? ""
                                    let name_ar = value?["name_ar"] as? String ?? ""
                                    let descripe_ar  = value?["descripe_ar"] as? String ?? ""
                                    
                                    
                                    let mm = Model.init(image: image, name: name, descripe: descripe, name_ar: name_ar , descripe_ar: descripe_ar, id: id, categoryID: item_id, userID: userID)
                                    
                                    // check if this image add pefore
                                    if !self.photos.contains(where: { m1 in
                                        return mm.userID == m1.userID && mm.name == m1.name && mm.name_ar == m1.name_ar && mm.descripe == m1.descripe && mm.descripe_ar == m1.descripe_ar
                                    }) {
                                        self.photos.append(mm)
                                    }
                                 
                                }
                            }
                            // after add all images in category check if this last category reload content
                               
                                if loopCategoriesCount == (categoriesCount){
                                    self.collectionView.reloadData()
                                   

                                }
                            
                            
                        })
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filterPhotos.count != 0 {
            return filterPhotos.count
        }else {
            return photos.count
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, heightForHeaderIn section: Int) -> CGFloat {
        return 200
    }
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
            // 1
        case UICollectionView.elementKindSectionHeader:
            // 2
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "\(adsSliderCVCell.self)",
                for: indexPath)
            
            // 3
            guard let typedHeaderView = headerView as? adsSliderCVCell
            else { return headerView }
            
            // 4
            
            typedHeaderView.imagesArray = self.adsImages
            typedHeaderView.reloadContent()
            return typedHeaderView
        default:
            // 5
            assert(false, "Invalid element type")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCVCell.identifier,
                                                      for: indexPath) as! ImageCVCell
        

        cell.imageV.image = UIImage.init(named: "AppIcon")

        if filterPhotos.count != 0 {
            cell.configure(image:  filterPhotos[indexPath.row].image)
        }else {
            print(photos[indexPath.row].image)
            cell.configure(image: photos[indexPath.row].image)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(
            width: view.frame.size.width/2,
            height: CGFloat.random(in: 200...400)
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if filterPhotos.count != 0 {
            let vc = DetailsTV()
            vc.curentModel = filterPhotos[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            
            
        }else {
            let vc = DetailsTV()
            
            vc.curentModel = photos[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
    
}




extension ImagesCV: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.isActive {
            return
        }
        
        let searchBar = search.searchBar
        
        if let userEnteredSearchText = searchBar.text {
            findResultsBasedOnSearch(with: userEnteredSearchText)
        }
    }
    
    private func findResultsBasedOnSearch(with text: String)  {
        filterPhotos.removeAll()
        if !text.isEmpty {
            filterPhotos = photos.filter{$0.image.lowercased().contains(text.lowercased()) }
            collectionView.reloadData()
        }else{
            collectionView.reloadData()
        }
    }
    
}

