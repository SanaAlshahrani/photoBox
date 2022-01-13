//
//  ChatFunctions.swift
//Created by Sana Alshahrani on 19/04/1443 AH.

import Foundation
import FirebaseDatabase
import FirebaseAuth

struct ChatFunctions{
    
    var chatRoom_id =  String()
    var reciverUid =  String()
    var reciverName =  String()
    var reciverImage =  String()
    
    fileprivate var databaseRef: DatabaseReference! {
        return Database.database().reference()
    }
    
    mutating func startChat(_ user1: User, user2: User){
        
        let userId1 = user1.id
        let userId2 = user2.id
        var chatRoomId = ""
        
        let comparison = userId1.compare(userId2).rawValue
        
        if comparison < 0 {
            chatRoomId = userId1 + "_" + userId2
        } else {
            chatRoomId = userId2 + "_" + userId1
        }
        
        
        self.reciverUid   = user2.id
        self.reciverImage = user2.avatar ?? ""
        self.reciverName  = user2.name
        self.chatRoom_id  = chatRoomId

        //        self.createChatRoomId(user1, user2: user2, members:members, chatRoomId: chatRoomId)
        
    }
    
    fileprivate func createChatRoomId(_ user1: User, user2: User, members:[String], chatRoomId: String)
    {
        let chatRoomRef = databaseRef.child("chat_rooms").queryOrdered(byChild: chatRoom_id).queryEqual(toValue: chatRoom_id)
        chatRoomRef.observe(.value, with: { (snapshot) in
            
            var createChatRoom = true
            
            if snapshot.exists()
            {
                for chatRoom in ((snapshot.value! as! [String: AnyObject]))
                {
                    if (chatRoom.value["groupId"] as! String) == self.chatRoom_id
                    {
                        createChatRoom = false
                    }
                }
            }
            
            if createChatRoom
            {
                self.createNewChatRoomId(user1.name, other_Username: user2.name, userId: user1.id, other_UserId: user2.id, members: members, chatRoomId: self.chatRoom_id, lastMessage: "", userPhotoUrl: user1.avatar ?? "", other_UserPhotoUrl: user2.avatar ?? "",date:  Date().timeIntervalSince1970)
            }
        })
      
        //        { (error) in
        //
        //            DispatchQueue.main.async(execute: {
        //            })        }
        
        
    }
    
    
    fileprivate func createNewChatRoomId(_ username: String, other_Username: String,userId: String,other_UserId: String,members: [String],chatRoomId: String,lastMessage: String,userPhotoUrl: String,other_UserPhotoUrl: String, date: TimeInterval)
    {
        //let newChatRoom = ChatRoom(username: username, other_Username: other_Username, userId: userId, other_UserId: other_UserId, members: members, chatRoomId: chatRoomId, lastMessage: lastMessage, userPhotoUrl: userPhotoUrl, other_UserPhotoUrl: other_UserPhotoUrl,date:date)
        
        //let chatRoomRef = databaseRef.child("chat_rooms").child(chatRoomId)
        //chatRoomRef.setValue(newChatRoom.toAnyObject())
        
    }
    
    
    
    
}
