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

class ImagesCommentVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , CHTCollectionViewDelegateWaterfallLayout {
    
    var filterUsers: [Model] = []
    var users: [Model] = []
    var photos: [Model] = []
    
    public func setupSearchBar() {
        
        search.loadViewIfNeeded()
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.returnKeyType = .done
        search.searchBar.sizeToFit()
        search.searchBar.placeholder = "Search for a images"
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
        collectionV.translatesAutoresizingMaskIntoConstraints = false
        collectionV.delegate = self
        collectionV.dataSource = self
        return collectionV
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comment Images"
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
        photos.removeAll()
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                let id_user =  user?.uid ?? ""
                let ref = Database.database().reference()
                // get
                ref.child("Comment").child(id_user).observeSingleEvent(of: .value) { snapshot in
                    let value = (snapshot.value as? NSDictionary)?.allValues
                    if value != nil {
                        for curentCategory in value!{
                            
                            let value = (curentCategory as? NSDictionary)
                            let imageId = value?["imageId"] as? String ?? ""
                            let categoryId = value?["categoryId"] as? String ?? ""
                            
                            ref.child("Public").child(categoryId).child(imageId).observeSingleEvent(of: .value, with: { (snapshot) in
                                // Get Category value
                                let value = (snapshot.value as? NSDictionary)
                                if value != nil {
                                    let name = value?["name"] as? String ?? ""
                                    let id = value?["id"] as? String ?? ""
                                    let image = value?["image"] as? String ?? ""
                                    let descripe = value?["descripe"] as? String ?? ""
                                    let userID = value?["userID"] as? String ?? ""
                                    let name_ar = value?["name_ar"] as? String ?? ""
                                    let descripe_ar  = value?["descripe_ar"] as? String ?? ""
                                    
                                    self.photos.append(Model.init(image: image, name: name, descripe: descripe, name_ar: name_ar , descripe_ar: descripe_ar, id: id, categoryID: categoryId, userID: userID))
                                    
                                    
                                    
                                }
                                self.collectionView.reloadData()

                            })

                            
                            
                            
                        }
                        
                    }
                    
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if filterUsers.count != 0 {
            return filterUsers.count
        }else {
            return photos.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageCVCell.identifier,
            for: indexPath
        ) as? ImageCVCell else { fatalError() }
        if filterUsers.count != 0 {
            cell.configure(image:  filterUsers[indexPath.row].image)
        }else {
            cell.configure(image: photos[indexPath.row].image)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: view.frame.size.width/2,
            height: CGFloat.random(in: 200...600)
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if filterUsers.count != 0 {
            let vc = DetailsTV()
            vc.curentModel = filterUsers[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            
            
        }else {
            let vc = DetailsTV()
            
            vc.curentModel = photos[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
    
}




extension ImagesCommentVC: UISearchResultsUpdating, UISearchBarDelegate {
    
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
        filterUsers.removeAll()
        if !text.isEmpty {
            filterUsers = photos.filter{$0.image.lowercased().contains(text.lowercased()) }
            collectionView.reloadData()
        }else{
            collectionView.reloadData()
        }
    }
    
}

