//
//  ChatViewController.swift
//Created by Sana Alshahrani on 19/04/1443 AH.

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import FirebaseAuth
import Firebase
import FirebaseStorage
import FirebaseDatabase
import AVKit
import AMPopTip

class ChatViewController: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate   {
    
    var chatRoomId: String!
    var recever: User!
    var sender: User!
    
    var messages = [JSQMessage]()
    var pageSize = 20
    let preloadMargin = 5
    var lastLoadedPage = 0
    var insertCounter = 0
    var  popTip = PopTip()
    
    var  allMessagesId = [""]
    
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    var databaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    var storageRef: Storage!{
        return Storage.storage()
    }
    
    var userIsTypingRef: DatabaseReference!
    var isReciverActive : Bool = false
    var reciverAvatar :UIImage? = UIImage(named:"AppIcon")
    var senderAvatar :UIImage? = UIImage(named:"AppIcon")
    
    fileprivate var localTyping: Bool = false
    fileprivate var count = 0
    private var isActiveHandle: DatabaseHandle?
    private var isTypingHandle: DatabaseHandle?
    
    deinit
    {
        if  isActiveHandle != nil
        {
            databaseRef.removeObserver(withHandle: isActiveHandle!)
        }
        if  isTypingHandle != nil
        {
            databaseRef.removeObserver(withHandle: isTypingHandle!)
        }
        
        databaseRef.child("chat_rooms").child(chatRoomId).child("Active").child(senderId).setValue(["Active":false])
        
        
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if Language.current.rawValue == "ar"{
            self.inputToolbar.contentView.textView.placeHolder = "اكتب رسالتك هنا"
            
        }else{
            self.inputToolbar.contentView.textView.placeHolder = "write your message here"
            
        }
        self.inputToolbar.contentView.leftBarButtonItem.setTitle("Send".localized, for: .normal)
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold) , .foregroundColor: UIColor.systemBackground]
        navigationController?.navigationBar.titleTextAttributes = attributes
        
        
        self.showLoadEarlierMessagesHeader = self.count > 20
        self.downloadAvatrImage(url: self.recever.avatar ?? "")
        self.getMyAvatar()
       
        CountOfMessages()
        typingObserver()
        observeTypingUser()
        
        let factory = JSQMessagesBubbleImageFactory()
        incomingBubbleImageView = factory?.incomingMessagesBubbleImage(with: UIColor.systemGray6)
        outgoingBubbleImageView = factory?.outgoingMessagesBubbleImage(with:UIColor.systemGray)
        
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize(width:36,height:36)
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize(width:36,height:36)
        collectionView.backgroundColor = UIColor.systemBackground
        
        self.fetchMessages()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.inputToolbar.contentView.textView.becomeFirstResponder()
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
     
        self.inputToolbar.contentView.leftBarButtonItem.isHidden = true
       
        self.title = recever.name
        databaseRef.child("Seen").child(self.chatRoomId).child(senderId).setValue(["counter":0])
        databaseRef.child("chat_rooms").child(chatRoomId).child("Active").child(senderId).setValue(["Active":true])
        
        observeIsActive()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        databaseRef.child("chat_rooms").child(chatRoomId).child("Active").child(senderId).setValue(["Active":false])
        
        
    }
   
    fileprivate func observeIsActive()
    {
        let typingRef = databaseRef.child("chat_rooms").child(chatRoomId).child("TypeIndicator").child("\(recever.id)")
        isActiveHandle = typingRef.observe(.childChanged, with: { (snapshot) in
            
            if snapshot.value as! Bool
            {
                self.isReciverActive = true
            }
            else
            {
                self.isReciverActive = false
            }
        })
        
    }
    
    
    func LoadMore(Size:Int)
    {
        
        self.messages.removeAll()
        self.allMessagesId.removeAll()
        Auth.auth().addStateDidChangeListener { [self] (auth, user) in
            if user != nil {
                let id_user =  user?.uid ?? ""
                let messageQuery = databaseRef.child("chat_rooms").child(self.chatRoomId).child("messages"+"_"+(id_user)).queryLimited(toLast: UInt(Size))
                
                messageQuery.observeSingleEvent(of: .value, with: { (snapshot) in
                    for snap in snapshot.children
                    {
                        let snapshotValue = (snap as! DataSnapshot).value as! [String: AnyObject]
                        let senderId = snapshotValue["senderUid"] as! String
                        let text = snapshotValue["message"] as! String
                        let displayName = snapshotValue["senderName"] as! String
                        let mediaType = snapshotValue["mediaType"] as! String
                        let mediaUrl = snapshotValue["mediaUrl"] as! String
                        self.allMessagesId.append((snap as! DataSnapshot).key)
                        
                        switch mediaType
                        {
                        case "Text Message":
                            self.messages.append(JSQMessage(senderId: senderId, displayName: displayName, text: text))
                            
                        case "Photo Message":
                            
                            let picture = UIImage(data: try! Data(contentsOf: URL(string: mediaUrl)!))
                            let photo = JSQPhotoMediaItem(image: picture)
                            self.messages.append(JSQMessage(senderId: senderId, displayName: displayName, media:photo))
                            
                        case "Video Message":
                            if let url = URL(string: mediaUrl) {
                                let video = JSQVideoMediaItem(fileURL: url, isReadyToPlay: true)
                                self.messages.append(JSQMessage(senderId: senderId, displayName: displayName, media: video))
                            }
                        default: break
                        }
                    }
                    self.finishReceivingMessage()
                    self.collectionView.reloadData()
                    self.collectionView.setContentOffset(CGPoint.zero, animated: true)
                    self.showLoadEarlierMessagesHeader =  self.pageSize <= self.messages.count
                    self.collectionView.semanticContentAttribute = .forceLeftToRight
                    
                    
                })
               
                
            }
        }
    }
    func CountOfMessages()
    {
        Auth.auth().addStateDidChangeListener { [self] (auth, user) in
            if user != nil {
                let id_user =  user?.uid ?? ""
                
                let messageQuery = self.databaseRef.child("chat_rooms").child(self.chatRoomId).child("messages"+"_"+(id_user))
                messageQuery.observe(.value) { (snapshot) in
                    self.count =  Int(snapshot.childrenCount)
                }
                
            }
        }
    }
    
    func fetchMessages()
    {
        Auth.auth().addStateDidChangeListener { [self] (auth, user) in
            if user != nil {
                let id_user =  user?.uid ?? ""
                let messageQuery = databaseRef.child("chat_rooms").child(self.chatRoomId).child("messages"+"_"+(id_user)).queryLimited(toLast: 20)
                messageQuery.observe(.childAdded, with: { (snapshot) in
                    
                    let snapshotValue = snapshot.value as! [String: AnyObject]
                    let senderId = snapshotValue["senderUid"] as! String
                    let text = snapshotValue["message"] as! String
                    let displayName = snapshotValue["senderName"] as! String
                    let mediaType = snapshotValue["mediaType"] as! String
                    let mediaUrl = snapshotValue["mediaUrl"] as! String
                    self.allMessagesId.append((snapshot ).key)
                    
                    switch mediaType
                    {
                    case "Text Message":
                        self.messages.append(JSQMessage(senderId: senderId, displayName: displayName, text: text))
                        
                    case "Photo Message":
                        
                        let picture = UIImage(data: try! Data(contentsOf: URL(string: mediaUrl)!))
                        let photo = JSQPhotoMediaItem(image: picture)
                        self.messages.append(JSQMessage(senderId: senderId, displayName: displayName, media:photo))
                        
                    case "Video Message":
                        if let url = URL(string: mediaUrl) {
                            let video = JSQVideoMediaItem(fileURL: url, isReadyToPlay: true)
                            self.messages.append(JSQMessage(senderId: senderId, displayName: displayName, media: video))
                        }
                    default: break
                    }
                    self.finishReceivingMessage()
                    self.showLoadEarlierMessagesHeader =  self.pageSize <= self.messages.count
                    
                })
                
            }
        }
    }
    func typingObserver()
    {
        let typeRef = databaseRef.child("chat_rooms").child(chatRoomId).child("TypeIndicator").child("\(self.sender.id)")
        typeRef.setValue(["TypeStatus":false])
        
    }
    override func textViewDidChange(_ textView: UITextView)
    {
        super.textViewDidChange(textView)
        if textView.text.count > 0
        {
            databaseRef.child("chat_rooms").child(chatRoomId).child("TypeIndicator").child(senderId).child("TypeStatus").setValue(true)
        }else
        {
            databaseRef.child("chat_rooms").child(chatRoomId).child("TypeIndicator").child(senderId).child("TypeStatus").setValue(false)
        }
    }
    
    
    fileprivate func observeTypingUser()
    {
        let typingRef = databaseRef.child("chat_rooms").child(chatRoomId).child("TypeIndicator").child("\(recever.id)")
        
        isTypingHandle = typingRef.observe(.childChanged, with: { (snapshot) in
            
            if snapshot.value as! Bool
            {
                self.showTypingIndicator = true
                self.scrollToBottom(animated: true)
            }else
            {
                self.showTypingIndicator = false
            }
        })
        ///
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!)
    {
        //////////
        let message = messages[indexPath.item]
        
        
        
        popTip.shouldDismissOnTap = true
        popTip.shouldDismissOnTapOutside = true
        popTip.shouldDismissOnSwipeOutside = true
        
        
        let cell =  collectionView.cellForItem(at: indexPath) as! JSQMessagesCollectionViewCell
        if message.senderId == senderId
        {
            
            
            popTip.show(text: "Delete", direction: .down, maxWidth: 200, in: view, from: CGRect(x: cell.frame.origin.x+90, y: cell.frame.origin.y+60, width: cell.frame.size.width, height: cell.frame.size.height))
            
        }else{
            popTip.show(text: "Delete", direction: .down, maxWidth: 200, in: view, from: CGRect(x: cell.frame.origin.x-90, y: cell.frame.origin.y+60, width: cell.frame.size.width, height: cell.frame.size.height))
        }
        
        popTip.tapHandler = { popTip in
            Auth.auth().addStateDidChangeListener { [self] (auth, user) in
                if user != nil {
                    let id_user =  user?.uid ?? ""
                    let messageId = self.allMessagesId[indexPath.row + 1]
                    let messageQuery = self.databaseRef.child("chat_rooms").child(self.chatRoomId).child("messages"+"_"+(id_user)).child(messageId)
                    messageQuery.removeValue()
                    
                    self.popTip.hide()
                    self.messages.remove(at: indexPath.row)
                    self.collectionView.reloadData()
                }
            }}
        
        
        if message.isMediaMessage
        {
            if let media = message.media as? JSQVideoMediaItem
            {
                let player = AVPlayer(url:  media.fileURL!)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }   }
        }
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        
        
        
        
        let messageRefSender = databaseRef.child("chat_rooms").child(chatRoomId).child("messages"+"_"+senderId).childByAutoId()
        
        let messageRefResiver = databaseRef.child("chat_rooms").child(chatRoomId).child("messages"+"_"+"\(recever.id)").childByAutoId()
        
        
        
        
        let  message = Message(Message: text, SenderUid: "\(sender.id)" , Sendername: (sender.name ), SenderImage: (sender.avatar ?? "") , ReceiverUid: "\(recever.id)" , Receivername: recever.name, ReceiverImage: (recever.avatar ?? ""), Timestamp:Date().timeIntervalSince1970 , GroupId: chatRoomId, mediaType: "Text Message", mediaUrl: "")
        
        
        
        
        messageRefSender.setValue(message.toAnyObject()) { (error, ref) in
            if error == nil
            {
                
                JSQSystemSoundPlayer.jsq_playMessageSentSound()
                self.databaseRef.child("chat_rooms").child(self.chatRoomId).child("TypeIndicator").child(senderId).child("TypeStatus").setValue(false)
                self.databaseRef.child("Recent").child(self.chatRoomId).setValue(message.toAnyObject())
                ////
                if !self.isReciverActive
                {
                    let unSeenMessage = self.databaseRef.child("Seen").child(self.chatRoomId).child("\(self.recever.id)").child("counter")
                    unSeenMessage.observeSingleEvent(of: .value, with: { (snapshot) in
                        var countNum : Int = 1
                        if snapshot.exists()
                        {
                            countNum = 1 + (snapshot.value as! Int)
                        }
                        self.databaseRef.child("Seen").child(self.chatRoomId).child("\(self.recever.id)").setValue(["counter":countNum])
                        
                        
                    })
                    
                    
                    
                    let refUser = self.databaseRef.child("Notifications").child("\(self.recever.id)").childByAutoId()
                    refUser.observeSingleEvent(of: .value, with: { (snap) in
                        
                        
                    })
                    
                }
                
                self.finishSendingMessage()
                
            }
        }
        messageRefResiver.setValue(message.toAnyObject()) { (error, ref) in
            if error == nil
            {
                
                self.databaseRef.child("chat_rooms").child(self.chatRoomId).child("TypeIndicator").child(senderId).child("TypeStatus").setValue(false)
                self.databaseRef.child("Recent").child(self.chatRoomId).setValue(message.toAnyObject())
                
                
                
                if !self.isReciverActive
                {
                    let unSeenMessage = self.databaseRef.child("Seen").child(self.chatRoomId).child("\(self.recever.id)").child("counter")
                    
                    unSeenMessage.observeSingleEvent(of: .value, with: { (snapshot) in
                        var countNum : Int = 1
                        if snapshot.exists()
                        {
                            countNum = 1 + (snapshot.value as! Int)
                        }
                        self.databaseRef.child("Seen").child(self.chatRoomId).child("\(self.recever.id)").setValue(["counter":countNum])
                        
                    })
                    
                    
                    
                    
                    let refUser = self.databaseRef.child("Notifications").child("\(self.recever.id)").childByAutoId()
                    refUser.observeSingleEvent(of: .value, with: { (snap) in
                        
                        
                    })
                
                }
                self.finishSendingMessage()
            }
        }
        
        
    }
    
    
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
        let alertController = UIAlertController(title: "Medias", message: "Choose your media type", preferredStyle: UIAlertController.Style.actionSheet)
        
        
        let imageAction = UIAlertAction(title: "Image", style: UIAlertAction.Style.default) { (action) in
            self.getMedia(kUTTypeImage)
            
        }
        
        let videoAction = UIAlertAction(title: "Video", style: UIAlertAction.Style.default) { (action) in
            self.getMedia(kUTTypeMovie)
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addAction(imageAction)
        alertController.addAction(videoAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let picture = info[.originalImage] as? UIImage
        {
            self.saveMediaMessage(withImage: picture, withVideo: nil)
            
            
        }
        else if let videoUrl = info[.mediaURL] as? URL
        {
            self.saveMediaMessage(withImage: nil, withVideo: videoUrl)
        }
        
        self.dismiss(animated: true)
        {
            JSQSystemSoundPlayer.jsq_playMessageSentSound()
            self.finishSendingMessage()
        }
    }
   
    fileprivate func saveMediaMessage(withImage image: UIImage?, withVideo: URL?)
    {
        
        if let image = image
        {
            let imagePath = "messageWithMedia\(chatRoomId + UUID().uuidString)/photo.jpg"
            
            let imageRef = storageRef.reference().child(imagePath)
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let imageData = image.jpegData(compressionQuality: 0.5)!
            imageRef.putData(imageData, metadata: metadata, completion: { (newMetaData, error) in
                
                if error == nil
                {
                    
                    imageRef.downloadURL(completion: { (url, error) in
                        
                        let newMetaData = url?.description ?? ""
                        
                        let  message = Message(Message: "Photo Message", SenderUid: "\(self.sender.id)", Sendername: (self.sender.name ?? ""), SenderImage:"\(self.sender.avatar ?? "")" , ReceiverUid: "\(self.recever.id)", Receivername: self.recever.name, ReceiverImage: (self.recever.avatar ?? ""), Timestamp:Date().timeIntervalSince1970 , GroupId: self.chatRoomId, mediaType: "Photo Message", mediaUrl: newMetaData)
                        
                        
                        
                        
                        let messageRefSender = self.databaseRef.child("chat_rooms").child(self.chatRoomId).child("messages"+"_"+"\(self.sender.id)").childByAutoId()
                        
                        let messageRefResiver = self.databaseRef.child("chat_rooms").child(self.chatRoomId).child("messages"+"_"+"\(self.recever.id)").childByAutoId()
                        
                        
                        
                        
                        messageRefSender.setValue(message.toAnyObject(), withCompletionBlock: { (error, ref) in
                            if error == nil
                            {
                                
                                
                                self.databaseRef.child("chat_rooms").child(self.chatRoomId).child("TypeIndicator").child("\(self.sender.id)").child("TypeStatus").setValue(false)
                                self.databaseRef.child("Recent").child(self.chatRoomId).setValue(message.toAnyObject())
                                
                                if !self.isReciverActive
                                {
                                    let unSeenMessage = self.databaseRef.child("Seen").child(self.chatRoomId).child("\(self.recever.id)").child("counter")
                                    
                                    
                                    unSeenMessage.observeSingleEvent(of: .value, with: { (snapshot) in
                                        var countNum : Int = 1
                                        if snapshot.exists()
                                        {
                                            countNum =  1 + (snapshot.value as! Int)
                                        }
                                        self.databaseRef.child("Seen").child(self.chatRoomId).child("\(self.recever.id)").setValue(["counter":countNum])
                                        
                                    })
                                    
                                    
                                }
                            
                                JSQSystemSoundPlayer.jsq_playMessageSentSound()
                                self.finishSendingMessage()
                            }
                        })
                        messageRefResiver.setValue(message.toAnyObject(), withCompletionBlock: { (error, ref) in
                            if error == nil
                            {
                                
                                
                                self.databaseRef.child("chat_rooms").child(self.chatRoomId).child("TypeIndicator").child("\(self.sender.id)").child("TypeStatus").setValue(false)
                                self.databaseRef.child("Recent").child(self.chatRoomId).setValue(message.toAnyObject())
               
                                if !self.isReciverActive
                                {
                                    let unSeenMessage = self.databaseRef.child("Seen").child(self.chatRoomId).child("\(self.recever.id)").child("counter")
                                    unSeenMessage.observeSingleEvent(of: .value, with: { (snapshot) in
                                        var countNum : Int = 1
                                        if snapshot.exists()
                                        {
                                            countNum = 1 + (snapshot.value as! Int)
                                        }
                                        self.databaseRef.child("Seen").child(self.chatRoomId).child("\(self.recever.id)").setValue(["counter":countNum])
                                        
                                    })
                            
                                }
                           
                                self.finishSendingMessage()
                            }
                        })
                    })
                }
            })
            
        }
        else
        {
            let videoPath = "messageWithMedia\(chatRoomId + UUID().uuidString)/video.mp4"
            
            let videoRef = storageRef.reference().child(videoPath)
            
            let metadata = StorageMetadata()
            metadata.contentType = "video/mp4"
            let videoData = try! Data(contentsOf: withVideo!)
            videoRef.putData(videoData, metadata: metadata, completion: { (newMetaData, error) in
                if error == nil
                {
                    videoRef.downloadURL(completion: { (url, error) in
                        
                        let newMetaData = url?.description ?? ""
                        
                        let  message = Message(Message: "Video Message", SenderUid: "\(self.sender.id)", Sendername: (self.sender.name ?? ""), SenderImage:(self.sender.avatar ?? "") , ReceiverUid: "\(self.recever.id)", Receivername: self.recever.name, ReceiverImage: (self.recever.avatar ?? ""), Timestamp:Date().timeIntervalSince1970 , GroupId: self.chatRoomId, mediaType: "Video Message", mediaUrl: newMetaData)
                        
                        
                        
                        let messageRefSender = self.databaseRef.child("chat_rooms").child(self.chatRoomId).child("messages"+"_"+"\(self.sender.id)").childByAutoId()
                        
                        let messageRefResiver = self.databaseRef.child("chat_rooms").child(self.chatRoomId).child("messages"+"_"+"\(self.recever.id)").childByAutoId()
                        
                        
                        
                        
                        
                        
                        messageRefSender.setValue(message.toAnyObject(), withCompletionBlock: { (error, ref) in
                            if error == nil
                            {
                                JSQSystemSoundPlayer.jsq_playMessageSentSound()
                                self.finishSendingMessage()
                            }
                        })
                        messageRefResiver.setValue(message.toAnyObject(), withCompletionBlock: { (error, ref) in
                            if error == nil
                            {
                           
                                self.finishSendingMessage()
                            }
                        })
                    })
                }
            })
            
        }
    }
    
    
    fileprivate func getMedia(_ mediaType: CFString)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.isEditing = true
        
        if mediaType == kUTTypeImage
        {
            imagePicker.mediaTypes = [mediaType as String]
            
        }
        else if mediaType == kUTTypeMovie
        {
            imagePicker.mediaTypes = [mediaType as String]
        }
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId
        {
            return outgoingBubbleImageView
        }
        else
        {
            return incomingBubbleImageView
        }
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        let message = messages[indexPath.item]
        if message.senderId == senderId
        {
            return JSQMessagesAvatarImageFactory.avatarImage(with: senderAvatar, diameter: 18)
        }
        else
        {
            return JSQMessagesAvatarImageFactory.avatarImage(with: reciverAvatar, diameter: 18)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        if (indexPath.item % 5 == 0)
        {
            let message = self.messages[indexPath.item]
            
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
        }
        
        return nil
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        if !message.isMediaMessage
        {
            if message.senderId == senderId
            {
                cell.textView.textColor = UIColor.systemGray6
            }
            else
            {
                cell.textView.textColor = UIColor.systemGray
            }
        }
        return cell
    }
    
    func downloadAvatrImage(url: String)
    {
        let url2 = NSURL(string: url)! as URL
        getDataFromUrl(url: url2) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                if UIImage(data: data) != nil {
                    
                    self.reciverAvatar = UIImage(data: data)
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    func downloadAvatrImageSender(url: String)
    {
        let url2 = NSURL(string: url)! as URL
        getDataFromUrl(url: url2)
        { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                if UIImage(data: data) != nil {
                    self.senderAvatar = UIImage(data: data)
                }
                self.collectionView.reloadData()
            }
        }
    }
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
    
    func getMyAvatar(){
        self.downloadAvatrImageSender(url:sender.avatar ?? "")
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!)
    {
        self.pageSize = self.pageSize + 20
        self.LoadMore(Size: self.pageSize)
    }
    
    
}
