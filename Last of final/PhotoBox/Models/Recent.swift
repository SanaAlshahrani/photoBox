//
//  Recent.swift
//Created by Sana Alshahrani on 19/04/1443 AH.


import UIKit
import Foundation
import Firebase
import FirebaseDatabase

struct Recent
{
    
    var RecentId : String
    var GroupId : String
    var Message : String
    var ReceiverImage   : String
    var ReceiverName : String
    var ReceiverUid : String
    var SenderImage : String
    var SenderName: String
    var SenderUid :String
    var Timestamp : TimeInterval
    var mediaType: String
    var mediaUrl: String
    
    
    
    init(RecentId:String, GroupId:String, Message:String, ReceiverImage: String, ReceiverName: String , ReceiverUid: String , SenderImage :String , SenderName :String ,SenderUid:String,Timestamp:TimeInterval , mediaType: String , mediaUrl: String )
    {
        self.RecentId = RecentId
        self.GroupId = GroupId
        self.Message = Message
        self.ReceiverImage = ReceiverImage
        self.ReceiverName = ReceiverName
        self.ReceiverUid = ReceiverUid
        self.SenderImage = SenderImage
        self.SenderName = SenderName
        self.SenderUid = SenderUid
        self.Timestamp  = Timestamp
        self.mediaType  = mediaType
        self.mediaUrl  = mediaUrl
    }
    
    
    init(snapshot: DataSnapshot)
    {
        RecentId = snapshot.key
        let valueData = snapshot.value as! NSDictionary
        GroupId = valueData.value(forKey: "groupId")  as? String ?? ""
        Message = valueData.value(forKey: "message")  as? String ?? ""
        ReceiverImage = valueData.value(forKey: "receiverImage")  as? String ?? ""
        ReceiverName = valueData.value(forKey: "receiverName")  as? String ?? ""
        ReceiverUid = valueData.value(forKey: "receiverUid")  as? String ?? ""
        SenderImage = valueData.value(forKey: "senderImage")  as? String ?? ""
        SenderName = valueData.value(forKey: "senderName")  as? String ?? ""
        SenderUid = valueData.value(forKey: "senderUid")  as? String ?? ""
        Timestamp = valueData.value(forKey: "timestamp") as? TimeInterval ?? Date().timeIntervalSince1970
        mediaType = valueData.value(forKey: "mediaType")  as? String ?? ""
        mediaUrl = valueData.value(forKey: "mediaUrl")  as? String ?? ""
    }
    
    

    
}

