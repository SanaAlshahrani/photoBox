
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
import FirebaseFirestore
class UsersVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , CHTCollectionViewDelegateWaterfallLayout {
    
    let db = Firestore.firestore().collection("users")
    fileprivate var chatFunctions = ChatFunctions()
    
    var filterUsers: [User] = []
    var users: [User] = []
    
    
    public func setupSearchBar() {
        
        search.loadViewIfNeeded()
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.returnKeyType = .done
        search.searchBar.sizeToFit()
        search.searchBar.placeholder = "Search for a photographer".localized
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
        layout.columnCount = 1
        
        
        let collectionV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionV.register(UserCell.self,forCellWithReuseIdentifier: UserCell.identifier)
        collectionV.translatesAutoresizingMaskIntoConstraints = false
        collectionV.delegate = self
        collectionV.dataSource = self
        
        return collectionV
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        
        navigationItem.title = "Users"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        users.removeAll()
        
        Auth.auth().addStateDidChangeListener { [self] (auth, user) in
            if user != nil {
                let userId =  user?.uid ?? ""
                
                self.db.getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print(err.localizedDescription)
                    }  else {
                        
                        for document in  querySnapshot!.documents {
                            let dataDescription = document.data()
                            let user_id = dataDescription["userID"] as? String ?? ""
                            let name = dataDescription["name"] as? String ?? ""
                            let email = dataDescription["email"] as? String ?? ""
                            let avatar = dataDescription["avatar"] as? String ?? ""
                            let instagramLink = dataDescription["instagramLink"] as? String ?? ""

                            let curentUser = User.init(id: user_id, name: name, instagramLink : instagramLink, email: email, avatar: avatar)

                            if user_id != userId {
                                users.append(curentUser)
                                
                            }else{
                                print("curent user")
                            }
                        }
                        self.collectionView.reloadData()
                        
                    }
                }
            }
        }
        
        
        //
        navigationItem.title = "Contact with a photographer".localized
        subTitelLabel.text = "Get better PHoto recommendations"
        navigationItem.titleView?.addSubview(subTitelLabel)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        setupSearchBar()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if filterUsers.count != 0 {
            return filterUsers.count
        }else {
            return users.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UserCell.identifier,
            for: indexPath
        ) as? UserCell else { fatalError() }
        if filterUsers.count != 0 {
            cell.configure(image: filterUsers[indexPath.row].avatar ?? "", titel: filterUsers[indexPath.row].name)
            cell.buttonChat.addTarget(self, action: #selector(goToChat(_:)), for: .touchUpInside)
            cell.buttonChat.tag = indexPath.row
            
            
            
        }else {
            cell.configure(image: users[indexPath.row].avatar ?? "", titel: users[indexPath.row].name)
            cell.buttonChat.addTarget(self, action: #selector(goToChat(_:)), for: .touchUpInside)
            cell.buttonChat.tag = indexPath.row
        }
        
        return cell
    }
   @objc func goToChat(_ sender : UIButton){
       var item : User!
       if filterUsers.count != 0 {
           item = filterUsers[sender.tag]
       }else{
           item = users[sender.tag]

           
       }
       var currentUser : User!
       var otherUser: User!
       
       Auth.auth().addStateDidChangeListener { [self] (auth, user) in
           if user != nil {
               let userId =  user?.uid ?? ""
               
               
               //Get specific document from current user
               let docRef = Firestore.firestore()
                   .collection("users")
                   .document(userId)
               
               // Get data
               docRef.getDocument { (document, error) in
                   guard let document = document, document.exists else {
                       print("Document does not exist")
                       return
                   }
                   let dataDescription = document.data()
                   let user_id = dataDescription?["userID"] as? String ?? ""
                   let name = dataDescription?["name"] as? String ?? ""
                   let email = dataDescription?["email"] as? String ?? ""
                   let avatar = dataDescription?["avatar"] as? String ?? ""
                   
                   currentUser = User.init(id: user_id, name: name, instagramLink :"" , email: email, avatar: avatar)
                   
                   
                   
                   //Get specific document from current user
                   Firestore.firestore().collection("users")
                       .document(item.id).getDocument { (document, error) in
                       guard let document = document, document.exists else {
                           print("Document does not exist")
                           return
                       }
                       let dataDescription = document.data()
                       let user_id = dataDescription?["userID"] as? String ?? ""
                       let name = dataDescription?["name"] as? String ?? ""
                       let email = dataDescription?["email"] as? String ?? ""
                       let avatar = dataDescription?["avatar"] as? String ?? ""
                       
                           otherUser = User.init(id: user_id, name: name, instagramLink : "", email: email, avatar: avatar)
                       
                       
                       
                       
                       
                       chatFunctions.startChat(currentUser, user2: otherUser)
                       
                       let chatViewController =  ChatViewController()
                       chatViewController.senderId = userId
                       chatViewController.senderDisplayName = currentUser.name
                       chatViewController.chatRoomId = chatFunctions.chatRoom_id
                       
                       chatViewController.recever = otherUser
                       chatViewController.sender = currentUser
                       navigationController?.pushViewController(chatViewController, animated: true)
                       
                   }
               }
           }
       }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: view.frame.size.width,
            height: 110
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var item : User!
        if filterUsers.count != 0 {
            item = filterUsers[indexPath.row]
        }else{
            item = users[indexPath.row]

            
        }
        guard let url = URL(string: item.instagramLink ?? "")  else { return }
         if UIApplication.shared.canOpenURL(url) {
             if #available(iOS 10.0, *) {
                 UIApplication.shared.open(url, options: [:], completionHandler: nil)
             } else {
                 UIApplication.shared.openURL(url)
             }
         }
     
    }
    
    
    
    
}



extension UsersVC: UISearchResultsUpdating, UISearchBarDelegate {
    
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
            filterUsers = users.filter{$0.name.lowercased().contains(text.lowercased()) }
            collectionView.reloadData()
        }else{
            collectionView.reloadData()
        }
    }
    
}

