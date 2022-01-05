//
//  ChatRoom.swift
//Created by Sana Alshahrani on 19/04/1443 AH.


import Foundation
import FirebaseDatabase


struct ChatRoom {
    
    var ChatRoomId: String!
    var Message: NSMutableArray
    //    var userId: String!
    //    var other_UserId: String!
    //    var members: [String]!
    //    var chatRoomId: String!
    //    var key: String = ""
    //    var lastMessage: String!
    //    var ref: FIRDatabaseReference!
    //    var userPhotoUrl: String!
    //    var other_UserPhotoUrl: String!
    //    var date: NSNumber!
    
    init(snapshot: DataSnapshot)
    {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.ChatRoomId = snapshot.key
        self.Message =  snapshotValue["messages"] as! NSMutableArray
    }
    
    
    init(ChatRoomId: String, Message: NSMutableArray)
    {
        self.ChatRoomId = ChatRoomId
        self.Message = Message
    }
    
    func toAnyObject() -> [String: AnyObject]
    {
        return ["TypeIndicator": ChatRoomId as AnyObject, "messages": Message as AnyObject]
    }
}
