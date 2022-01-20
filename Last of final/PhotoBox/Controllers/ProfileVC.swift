//
//  ProfileVC.swift
//  PhotoBox
//Created by Sana Alshahrani on 19/04/1443 AH.

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ProfileVC: UITableViewController {
    
    
    var curentUser : User!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        navigationItem.title = "Settings".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        self.tableView.backgroundColor = UIColor.systemGray6
        self.tableView.register(ChatsCell.self, forCellReuseIdentifier: ChatsCell.identifier)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
                    let instagramLink = dataDescription?["instagramLink"] as? String ?? ""
                    
                    self.curentUser = User(id: user_id, name: name , instagramLink: instagramLink, email: email, avatar: avatar)
                    self.tableView.reloadData()
                    
                }
            }
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if curentUser != nil {
            return 5
        }else{
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 2
        case 3:
            return 3
            
        case 4:
            return 1
        default:
            print("default")
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatsCell", for: indexPath) as! ChatsCell
            cell.senderImageView.backgroundColor = UIColor.systemGray3
            
            if curentUser.avatar != ""
            {
                let url = URL(string: curentUser.avatar!)
                cell.senderImageView.sd_setImage(with: url, placeholderImage: UIImage(), options: .refreshCached, completed: nil)
            }
            cell.senderNameLbl.text = curentUser.name
            
            cell.descLbl.text = curentUser.email
            cell.timeLbl.text = ""
            
            cell.senderImageView.setRounded()
            cell.backgroundColor = UIColor.init(named: "witeColor")!
            cell.contentView.backgroundColor = UIColor.init(named: "witeColor")!
            return cell
            
            
            
        case 1:
            
            let cell = UITableViewCell()
            cell.textLabel?.text = "Edit Profile".localized
            cell.imageView?.image = UIImage(systemName: "square.and.pencil")!
            cell.accessoryType = .disclosureIndicator
            cell.tintColor = .red
            cell.backgroundColor = UIColor.init(named: "witeColor")!
            cell.contentView.backgroundColor = UIColor.init(named: "witeColor")!
            return cell
            
        case 2:
            switch indexPath.row {
            case 0:
                let cell = UITableViewCell()
                cell.textLabel?.text = "Change Language".localized
                cell.imageView?.image = UIImage(systemName: "e.square")!
                cell.accessoryType = .disclosureIndicator
                cell.tintColor = .blue
                cell.backgroundColor = UIColor.init(named: "witeColor")!
                cell.contentView.backgroundColor = UIColor.init(named: "witeColor")!
                return cell
                
            case 1:
                let cell = UITableViewCell()
                cell.textLabel?.text = "Applicaiton Mode".localized
                cell.imageView?.image = UIImage(systemName: "rectangle.leadinghalf.inset.filled")!
                cell.accessoryType = .disclosureIndicator
                cell.tintColor = .photoBox
                cell.backgroundColor = UIColor.init(named: "witeColor")!
                cell.contentView.backgroundColor = UIColor.init(named: "witeColor")!
                return cell
                
            default:
                print("default")
                return UITableViewCell()
            }
        case 3:
            switch indexPath.row {
            case 0:
                let cell = UITableViewCell()
                cell.textLabel?.text = "Favorite images".localized
                cell.imageView?.image = UIImage(systemName: "heart.circle")!
                cell.accessoryType = .disclosureIndicator
                cell.tintColor = .red
                cell.backgroundColor = UIColor.init(named: "witeColor")!
                cell.contentView.backgroundColor = UIColor.init(named: "witeColor")!
                return cell
                
            case 1:
                let cell = UITableViewCell()
                cell.textLabel?.text = "Commented images".localized
                cell.imageView?.image = UIImage(systemName: "text.bubble")!
                cell.accessoryType = .disclosureIndicator
                cell.tintColor = .systemYellow
                cell.backgroundColor = UIColor.init(named: "witeColor")!
                cell.contentView.backgroundColor = UIColor.init(named: "witeColor")!
                return cell
                
            case 2:
                let cell = UITableViewCell()
                cell.textLabel?.text = "Chats".localized
                cell.imageView?.image = UIImage(systemName: "message.circle")!
                cell.accessoryType = .disclosureIndicator
                cell.tintColor = .systemGreen
                cell.backgroundColor = UIColor.init(named: "witeColor")!
                cell.contentView.backgroundColor = UIColor.init(named: "witeColor")!
                
                return cell
                
            default:
                print("default")
                return UITableViewCell()
            }
            
        case 4:
            let cell = UITableViewCell()
            cell.textLabel?.text = "Log Out".localized
            cell.imageView?.image = UIImage(systemName: "person.crop.circle.badge.moon")!
            cell.accessoryType = .disclosureIndicator
            cell.tintColor = .systemRed
            cell.backgroundColor = .systemRed
            cell.contentView.backgroundColor = UIColor.init(named: "witeColor")!
            return cell
        default:
            print("default")
            return UITableViewCell()
        }
        
    }
    private func changeLanguage() {
        let alert = UIAlertController(title: "Change Language".localized, message: "Select app language".localized, preferredStyle: .actionSheet)
        
        if Language.current == .arabic {
            alert.addAction(.init(title: "English", style: .default, handler: { (_) in
                Language.current = .english
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                
                sceneDelegate!.window = UIWindow(frame: UIScreen.main.bounds)
                let viewController = TabBar()
                sceneDelegate!.window?.rootViewController = UINavigationController(rootViewController: viewController)
                sceneDelegate!.window?.makeKeyAndVisible()
                sceneDelegate!.window?.windowScene = windowScene
                if Language.current == .arabic {
                    UIView.appearance().semanticContentAttribute = .forceRightToLeft
                    UIImageView.appearance().semanticContentAttribute = .forceRightToLeft

                }else if Language.current == .english{
                    UIView.appearance().semanticContentAttribute = .forceLeftToRight
                    UIImageView.appearance().semanticContentAttribute = .forceLeftToRight

                }
            }))
        }
        
        if Language.current == .english {
            alert.addAction(.init(title: "عربي", style: .default, handler: { (_) in
                Language.current = .arabic
                
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                
                sceneDelegate!.window = UIWindow(frame: UIScreen.main.bounds)
                let viewController = TabBar()
                sceneDelegate!.window?.rootViewController = UINavigationController(rootViewController: viewController)
                sceneDelegate!.window?.makeKeyAndVisible()
                sceneDelegate!.window?.windowScene = windowScene
                if Language.current == .arabic {
                    UIView.appearance().semanticContentAttribute = .forceRightToLeft
                    UIImageView.appearance().semanticContentAttribute = .forceRightToLeft

                }else if Language.current == .english{
                    UIView.appearance().semanticContentAttribute = .forceLeftToRight
                    UIImageView.appearance().semanticContentAttribute = .forceLeftToRight

                }
            }))
        }
        
        alert.addAction(.init(title: "System Default".localized, style: .default, handler: { (_) in
            Language.current = .default
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            
            
            sceneDelegate!.window = UIWindow(frame: UIScreen.main.bounds)
            let viewController = TabBar()
            sceneDelegate!.window?.rootViewController = UINavigationController(rootViewController: viewController)
            sceneDelegate!.window?.makeKeyAndVisible()
            sceneDelegate!.window?.windowScene = windowScene
            if Language.current == .arabic {
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                UIImageView.appearance().semanticContentAttribute = .forceRightToLeft

            }else if Language.current == .english{
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                UIImageView.appearance().semanticContentAttribute = .forceLeftToRight

            }
        }))
        
        alert.addAction(.init(title: "Cancel".localized, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
            
            
        case 1:
            
            navigationController?.pushViewController(EditProfileVC(), animated: true)
            
            
        case 2:
            switch indexPath.row {
            case 0:
                changeLanguage()
                
                
            case 1:
                
                if self.traitCollection.userInterfaceStyle == .light {
                    overrideUserInterfaceStyle = .dark
                    UIApplication.shared.windows.forEach { window in
                        window.overrideUserInterfaceStyle = .dark
                    }
                }else{
                    overrideUserInterfaceStyle = .light
                    UIApplication.shared.windows.forEach { window in
                        window.overrideUserInterfaceStyle = .light
                    }
                }
                
            default:
                print("default")
            }
        case 3:
            switch indexPath.row {
            case 0:
                navigationController?.pushViewController(ImagesFavoritCV(), animated: true)
                
                
            case 1:
                navigationController?.pushViewController(ImagesCommentVC(), animated: true)
                
                
            case 2:
                navigationController?.pushViewController(ChatsTableVC(), animated: true)
                
                
                
            default:
                print("default")
            }
            
        case 4:
            do{
                try Auth.auth().signOut()
                let viewController = StartVC()
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                
                sceneDelegate!.window = UIWindow(frame: UIScreen.main.bounds)
               
                sceneDelegate!.window?.rootViewController = UINavigationController(rootViewController: viewController)
                sceneDelegate!.window?.makeKeyAndVisible()
                sceneDelegate!.window?.windowScene = windowScene
                
            }catch{
                print("Error while signing out!")
            }
        default:
            print("default")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? UITableView.automaticDimension : 25
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return nil
        } else {
            let view = UIView(frame: CGRect.zero)
            view.backgroundColor = UIColor.systemGray6
            let separator = UIView(frame: CGRect(x: tableView.separatorInset.left, y: 0, width: 0, height: 1))
            separator.autoresizingMask = .flexibleWidth
            separator.backgroundColor = tableView.separatorColor
            view.addSubview(separator)
            return view
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 110
        default:
            return 54
        }
    }
    
   
}
