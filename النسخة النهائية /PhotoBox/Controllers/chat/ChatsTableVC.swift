//
//  ChatsTableVC.swift
//Created by Sana Alshahrani on 19/04/1443 AH.

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage
import FirebaseAuth
import FirebaseFirestore
class ChatsTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var tableView : UITableView!
    
    fileprivate var chatFunctions = ChatFunctions()
    private var RefHandle: DatabaseHandle?
    var allRecent : NSMutableArray = []
    var prevArray : NSMutableArray = []
    let db = Firestore.firestore().collection("users")
    var userId = ""
    var dataBaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    var storageRef: Storage {
        return Storage.storage()
    }
    
    deinit
    {
        if let Handler = RefHandle
        {
            dataBaseRef.removeObserver(withHandle: Handler)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chats".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView = UITableView.init(frame: self.view.frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        tableView.register(ChatsCell.self, forCellReuseIdentifier: ChatsCell.identifier)
        
        self.view.addSubview(tableView)
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
        self.allRecent.removeAllObjects()
        self.allRecent.removeAllObjects()
        
        
        
        
        getRecents()
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataBaseRef.removeObserver(withHandle: RefHandle!)
        prevArray.removeAllObjects()
        allRecent.removeAllObjects()
    }
    
    //MARK: Recents
    
    func getRecents()
    {
        let usersRef = dataBaseRef.child("Recent")
        RefHandle =  usersRef.observe(.value, with: { (snapshot) in
            var isMyChat = false
            let enumerator = snapshot.children
            
            for snapValue in enumerator
            {
                Auth.auth().addStateDidChangeListener { [self] (auth, user) in
                    if user != nil {
                        let userId =  user?.uid ?? ""
                        
                        let snapshotValue = Recent.init(snapshot: snapValue as! DataSnapshot)
                        if snapshotValue.ReceiverUid == userId || snapshotValue.SenderUid == userId
                        {
                            isMyChat = true
                        }
                        else
                        {
                            isMyChat = false
                        }
                        
                        if isMyChat
                        {
                            
                            
                            if self.prevArray.contains(snapshotValue.RecentId) == false {
                                
                                let messageQuery = self.dataBaseRef.child("chat_rooms").child(snapshotValue.RecentId).child("messages" + "_" + userId)
                                
                                messageQuery.observeSingleEvent(of: .value, with: { (snapshot) in
                                    
                                    if snapshot.childrenCount > 0{
                                        
                                        self.allRecent.add(snapshotValue)
                                        Auth.auth().addStateDidChangeListener { [self] (auth, user) in
                                            if user != nil {
                                                self.userId =  user?.uid ?? ""
                                                self.tableView.reloadData()

                                            }
                                            
                                        }
                                        
                                    }
                                })
                                
                                
                                
                            }
                            
                            self.prevArray.add(snapshotValue.RecentId)
                        }
                    }
                }}
            
            
            
        })
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allRecent.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let recent = allRecent[indexPath.row] as! Recent
        var userdata : User!
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatsCell", for: indexPath) as! ChatsCell

                if recent.SenderUid == userId
                {
                  
                    userdata = User.init(id: recent.ReceiverUid, name: recent.ReceiverName, instagramLink : "", email: "", avatar: recent.ReceiverImage)

                        cell.senderImageView.backgroundColor = UIColor.systemGray6
                        
                        if userdata.avatar != ""
                        {
                            let url = URL(string: userdata.avatar ?? "")
                            cell.senderImageView.sd_setImage(with: url, placeholderImage: UIImage(), options: .refreshCached, completed: nil)
                        }
                        cell.senderNameLbl.text = userdata.name
                        
                        cell.descLbl.text = recent.Message
                        let dateString = self.convertDateToString(Date.init(timeIntervalSince1970: recent.Timestamp))
                        cell.timeLbl.text = dateString
                        
                        cell.senderImageView.setRounded()
                        
                    }
                                            
                    
                    
                
                else
                {
                
                    userdata = User.init(id: recent.SenderUid, name: recent.SenderName, instagramLink : "", email: "", avatar: recent.SenderImage)

                        cell.senderImageView.backgroundColor = UIColor.systemGray6
                        
                        if userdata.avatar != ""
                        {
                            let url = URL(string: userdata.avatar ?? "")
                            cell.senderImageView.sd_setImage(with: url, placeholderImage: UIImage(), options: .refreshCached, completed: nil)
                        }
                        cell.senderNameLbl.text = userdata.name
                        
                        cell.descLbl.text = recent.Message
                        let dateString = self.convertDateToString(Date.init(timeIntervalSince1970: recent.Timestamp))
                        cell.timeLbl.text = dateString
                        
                        cell.senderImageView.setRounded()
                        
                        
                    }
                        
             
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func convertDateToString(_ date: Date) -> String {
        let formater = DateFormatter()
        formater.locale = NSLocale(localeIdentifier: "en") as Locale
        formater.dateFormat = "d' 'MMMM' 'yyyy'"
        return formater.string(from: date)
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // 5
        let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:IndexPath!) -> Void in
            
            Auth.auth().addStateDidChangeListener { [self] (auth, user) in
                if user != nil {
                    let userId =  user?.uid ?? ""
                    
                    // 6
                    let rectNode = (self.allRecent[indexPath.row] as! Recent).RecentId
                    
                    let messageQuery = self.dataBaseRef.child("chat_rooms").child(rectNode).child("messages" + "_" + userId)
                    messageQuery.removeValue()
                    self.allRecent.removeObject(at: indexPath.row)
                    self.tableView.reloadData()
                    
                }
            }
        })
        
        
        deleteAction.backgroundColor = UIColor.systemRed
        
        
        // 7
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        //
        let recent = allRecent[indexPath.row] as! Recent
                if recent.SenderUid == userId
                {
                    let  currentUser = User.init(id: recent.SenderUid, name: recent.SenderName, instagramLink : "", email: "", avatar: recent.SenderImage)
                    let  otherUser = User.init(id: recent.ReceiverUid, name: recent.ReceiverName, instagramLink : "", email: "", avatar: recent.ReceiverImage)

                            chatFunctions.startChat(currentUser, user2: otherUser)
                            
                            let chatViewController =  ChatViewController()
                            chatViewController.senderId = userId
                            chatViewController.senderDisplayName = currentUser.name
                            chatViewController.chatRoomId = chatFunctions.chatRoom_id
                            
                            chatViewController.recever = otherUser
                            chatViewController.sender = currentUser
                            navigationController?.pushViewController(chatViewController, animated: true)
                            
                        }
                        
                    else
                    {
                        let  otherUser = User.init(id: recent.SenderUid, name: recent.SenderName, instagramLink :"", email: "", avatar: recent.SenderImage)
                        let  currentUser = User.init(id: recent.ReceiverUid, name: recent.ReceiverName, instagramLink : "", email: "", avatar: recent.ReceiverImage)

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
extension UIView
{
    func setRounded() {
        let radius = self.frame.height / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
}
extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
