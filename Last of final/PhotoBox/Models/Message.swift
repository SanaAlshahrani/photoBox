//
//  Message.swift
//Created by Sana Alshahrani on 19/04/1443 AH.


import Foundation
import FirebaseDatabase

struct Message
{
    
    var Message: String
    var SenderUid: String
    var Sendername: String
    var SenderImage: String
    var ReceiverUid: String
    var Receivername: String
    var ReceiverImage: String
    var Timestamp: TimeInterval
    var GroupId: String
    var key: String
    var mediaType: String
    var mediaUrl: String
    
    
    init(snapshot: DataSnapshot)
    {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        Message =  snapshotValue["message"] as? String ?? ""
        SenderUid = snapshotValue["senderUid"]  as? String ?? ""
        Sendername = snapshotValue["senderName"]  as? String ?? ""
        SenderImage = snapshotValue["senderImage"]  as? String ?? ""
        ReceiverUid = snapshotValue["receiverUid"]  as? String ?? ""
        Receivername = snapshotValue["receiverName"]  as? String ?? ""
        ReceiverImage = snapshotValue["receiverImage"]  as? String ?? ""
        Timestamp = snapshotValue["timestamp"] as? TimeInterval ?? Date().timeIntervalSince1970
        GroupId = snapshotValue["groupId"]  as? String ?? ""
        mediaType = snapshotValue["mediaType"]  as? String ?? ""
        mediaUrl = snapshotValue["mediaUrl"]  as? String ?? ""
        
        self.key = snapshot.key
    }
    
    
    init(Message: String ,
         SenderUid: String,
         Sendername: String,
         SenderImage: String,
         ReceiverUid: String,
         Receivername: String,
         ReceiverImage: String,
         Timestamp: TimeInterval,
         GroupId: String,
         mediaType: String,
         mediaUrl: String)
    {
        self.Message = Message
        self.SenderUid = SenderUid
        self.Sendername = Sendername
        self.SenderImage = SenderImage
        self.ReceiverImage = ReceiverImage
        self.Receivername = Receivername
        self.ReceiverUid = ReceiverUid
        self.Timestamp = Timestamp
        self.GroupId = GroupId
        self.key = GroupId
        self.mediaType = mediaType
        self.mediaUrl = mediaUrl
    }
    
    
    func toAnyObject() -> Any
    {
        return ["message":self.Message,
                "senderUid":self.SenderUid,
                "senderName":self.Sendername,
                "senderImage":self.SenderImage,
                "receiverUid":self.ReceiverUid,
                "receiverName":self.Receivername,
                "receiverImage":self.ReceiverImage,
                "timestamp":self.Timestamp,
                "groupId":self.GroupId,
                "mediaType":self.mediaType,
                "mediaUrl":self.mediaUrl]
    }
}
