//
//  ImagesCollectionV.swift
//  PhotoBox
//
//  Created by Sana Alshahrani on 20/04/1443 AH.
//

import CHTCollectionViewWaterfallLayout
import UIKit
import FirebaseDatabase
import FirebaseAuth
class CategoryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , CHTCollectionViewDelegateWaterfallLayout {

     var filterCategories: [ModelCategory] = []
     var categories: [ModelCategory] = []
    var SelectedCategories: [ModelCategory] = []

    
    public func setupSearchBar() {
    
      search.loadViewIfNeeded()
      search.searchResultsUpdater = self
      search.obscuresBackgroundDuringPresentation = false
      search.searchBar.returnKeyType = .done
      search.searchBar.sizeToFit()
        search.searchBar.placeholder = "Search for a Category".localized
      search.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true

       navigationItem.searchController = search
       navigationItem.hidesSearchBarWhenScrolling = true
        search.searchBar.delegate = self
    }

    
    
   let search = UISearchController()
    let subTitelLabel = UILabel()

    lazy var collectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.itemRenderDirection = .leftToRight
        layout.columnCount = 2
     
        
        let collectionV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionV.register(ImageAndTextCVCell.self,forCellWithReuseIdentifier: ImageAndTextCVCell.identifier)
        collectionV.translatesAutoresizingMaskIntoConstraints = false
        collectionV.delegate = self
        collectionV.dataSource = self
        
        return collectionV
    }()
    
    lazy var selectCategoryButton: UIButton = {
      
        let selectCategoryButton = UIButton.init(frame: CGRect.init(x: 20, y: self.view.frame.height - 70, width: self.view.frame.width - 40, height: 50))
        
        
        selectCategoryButton.setTitleColor(UIColor.init(named: "BlackColor")!, for: .normal)

        selectCategoryButton.backgroundColor = UIColor.init(named: "witeColor")!
        selectCategoryButton.setupButton(with:"Select Categories".localized)
        selectCategoryButton.translatesAutoresizingMaskIntoConstraints = false

        return selectCategoryButton
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        //
        selectCategoryButton.addTarget(self, action: #selector(CategoryVC.selectCategoriesAction(_:)), for:.touchUpInside)


        
        categories.removeAll()
        SelectedCategories.removeAll()
        let ref = Database.database().reference()

        ref.child("Category").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get Category value
                let value = (snapshot.value as? NSDictionary)?.allValues
            if value != nil {
            for curentCategory in value!{
                let value = (curentCategory as? NSDictionary)
                let name = value?["name"] as? String ?? ""
                let id = value?["id"] as? String ?? ""
                let image = value?["image"] as? String ?? ""
                let name_ar = value?["name_ar"] as? String ?? ""

                self.categories.append(ModelCategory(image: image, name: name, id: id, name_ar: name_ar))
            }
            self.collectionView.reloadData()
              
            }
                // ...
            }) { (error) in
                    print(error.localizedDescription)
        }
        //
        navigationItem.title = "What interests you ?"
        subTitelLabel.text = "Get better PHoto recommendations"
        navigationItem.titleView?.addSubview(subTitelLabel)

        navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView.backgroundColor = UIColor.init(named: "witeColor")!
        view.addSubview(collectionView)
        view.addSubview(selectCategoryButton)
        view.backgroundColor = UIColor.init(named: "witeColor")!
        selectCategoryButton.backgroundColor = .photoBox

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: selectCategoryButton.topAnchor, constant: -20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            selectCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
            selectCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            selectCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            selectCategoryButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
          setupSearchBar()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if filterCategories.count != 0 {
            return filterCategories.count
        }else {
            return categories.count
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageAndTextCVCell.identifier,
            for: indexPath
        ) as? ImageAndTextCVCell else { fatalError() }
        if filterCategories.count != 0 {
            if Language.current.rawValue == "ar"{
                cell.configure(image: filterCategories[indexPath.row].image, titel: filterCategories[indexPath.row].name_ar)

            }else{
                cell.configure(image: filterCategories[indexPath.row].image, titel: filterCategories[indexPath.row].name)

            }

            if SelectedCategories.contains(where: { item in
               return item.id == filterCategories[indexPath.row].id
            }){
                cell.imageChecklist.isHidden = false
                }else{
                    cell.imageChecklist.isHidden = true

            }
                
        }else {
            if Language.current.rawValue == "ar"{
                cell.configure(image: categories[indexPath.row].image, titel: categories[indexPath.row].name_ar)

            }else{
                cell.configure(image: categories[indexPath.row].image, titel: categories[indexPath.row].name)

            }
            if SelectedCategories.contains(where: { item in
               return item.id == categories[indexPath.row].id
            }){
                cell.imageChecklist.isHidden = false

            }else{
                cell.imageChecklist.isHidden = true

            }
        }
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: view.frame.size.width/2,
            height: 100
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if filterCategories.count != 0 {
            if SelectedCategories.contains(where: { item in
               return item.id == filterCategories[indexPath.row].id
            }){
                SelectedCategories.removeAll(where: { item in
                    item.id == filterCategories[indexPath.row].id
                })
            }else{
                SelectedCategories.append(filterCategories[indexPath.row])
                

            }
        }else {
            if SelectedCategories.contains(where: { item in
               return item.id == categories[indexPath.row].id
            }){
                SelectedCategories.removeAll(where: { item in
                    item.id == categories[indexPath.row].id
                })
            }else{
                SelectedCategories.append(categories[indexPath.row])

            }

        }
        self.collectionView.reloadData()

    }
    
   
@IBAction func selectCategoriesAction(_ sender : UIButton){
    
    UserDefaults.standard.set(true, forKey: "SelectCategory")
            Auth.auth().addStateDidChangeListener { (auth, user) in
                   if user != nil {
                      let id_user =  user?.uid ?? ""
                       let ref = Database.database().reference()
                       for item in self.SelectedCategories {
                           ref.child("User").child(id_user).child("Category").child(item.id).setValue(["id" : item.id])
                       }
                       let vc = TabBar()
                       vc.modalTransitionStyle = .crossDissolve
                       vc.modalPresentationStyle = .fullScreen
                       self.navigationController?.present(vc, animated: true, completion: nil)
                   }else{
                       let encoder = JSONEncoder()
                       if let encoded = try? encoder.encode(self.SelectedCategories){
                          UserDefaults.standard.set(encoded, forKey: "SavedCategoryArray")
                       }
                       let vc = TabBar()
                       vc.modalTransitionStyle = .crossDissolve
                       vc.modalPresentationStyle = .fullScreen
                       self.navigationController?.present(vc, animated: true, completion: nil)
                   }
            }
    sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)

      UIView.animate(withDuration: 2.0,
                                 delay: 0,
                                 usingSpringWithDamping: CGFloat(0.20),
                                 initialSpringVelocity: CGFloat(6.0),
                                 options: UIView.AnimationOptions.allowUserInteraction,
                                 animations: {
                                  sender.transform = CGAffineTransform.identity
          },
                                 completion: { Void in()  }
      )
  }
    
    

}



extension CategoryVC: UISearchResultsUpdating, UISearchBarDelegate {
    
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
        filterCategories.removeAll()
     if !text.isEmpty {
         filterCategories = categories.filter{$0.image.lowercased().contains(text.lowercased()) }
         collectionView.reloadData()
     }else{
         collectionView.reloadData()
      }
    }

}

