//
//  PlacesVideosVC.swift
//  PhotoBox
//
//  Created by Sana Alshahrani on 20/04/1443 AH.
//
//

import UIKit
import AVFoundation
import AVKit
class PlacesVideosVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    var places = [Place]()
    var vedios = [Video]()

    private let videoslabel: UILabel = {
        let videoslabel = UILabel.init(frame: CGRect.init(x: 110, y: 0, width: 200, height: 30))
        videoslabel.textColor = UIColor.init(named: "BlackColor")!
        videoslabel.text = "Vedios".localized
        videoslabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        videoslabel.translatesAutoresizingMaskIntoConstraints = false
        
        return videoslabel
    }()
    
    private let placeslabel: UILabel = {
        let placeslabel = UILabel.init(frame: CGRect.init(x: 110, y: 0, width: 200, height: 30))
        
        placeslabel.textColor = UIColor.init(named: "BlackColor")!
        placeslabel.text = "Places".localized
        placeslabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        placeslabel.translatesAutoresizingMaskIntoConstraints = false
        return placeslabel
    }()
 
    lazy var videosCollectionView: JYCardView = {
        videosCollectionView = JYCardView(frame: CGRect(origin: .zero, size: CGSize(width: 280, height: 380)))
        videosCollectionView.register(cellClass: CardViewCell.self, forCellWithReuseIdentifier: CardViewCell.cellID)
        videosCollectionView.cardViewDataSource = self
        videosCollectionView.cardViewDelegate = self
        videosCollectionView.backgroundColor = view.backgroundColor
        
        videosCollectionView.translatesAutoresizingMaskIntoConstraints = false

        return videosCollectionView
    }()
    
    
    lazy var placesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        
        
        let placesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        placesCollectionView.register(PlacesVediosCell.self,forCellWithReuseIdentifier: PlacesVediosCell.identifier)
        
        placesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        placesCollectionView.delegate = self
        placesCollectionView.dataSource = self
        return placesCollectionView
    }()
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
            return places.count
      
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
            guard let number = URL(string: "tel://" + places[indexPath.row].phone) else { return }
            UIApplication.shared.open(number)
            
       
    }
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        
        let vc = AVPlayerViewController()
        vc.player = player
        
        self.present(vc, animated: true) { vc.player?.play() }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PlacesVediosCell.identifier,
            for: indexPath
        ) as? PlacesVediosCell else { fatalError() }
        
       
            cell.configure(image: places[indexPath.row].image, titel: places[indexPath.row].name, descreption: places[indexPath.row].price + "SAR".localized)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        return CGSize(
            width: 200,
            height: 280
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor =  UIColor.init(named: "witeColor")!
        self.view.addSubview(placeslabel)
        self.view.addSubview(placesCollectionView)
        self.view.addSubview(videoslabel)
        self.view.addSubview(videosCollectionView)

       
        places.append(Place.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/IMG_1116.jpg?alt=media", name: "pallete cafe", price: "free ", phone: ""))
               places.append(Place.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/IMG_1110.jpg?alt=media", name: "lapis", price: "2500", phone: ""))
               places.append(Place.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/IMG_1111.jpg?alt=media", name: "lecce_shalih", price: "3000", phone: "+966505695588"))
               places.append(Place.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/IMG_1112.jpg?alt=media", name: "levanzo.shalih", price: "2000", phone: "+966505758866"))
               places.append(Place.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/IMG_1111.jpg?alt=media", name: "lecce_shalih", price: "3000", phone: "+966505695588"))
               places.append(Place.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/IMG_1113.jpg?alt=media", name: "bluewave", price: "1500", phone: "+966539666685"))
               places.append(Place.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/IMG_1114.jpg?alt=media", name: "ajdan.resot", price: "3000", phone: "+966506458607"))
               places.append(Place.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/IMG_1115.jpg?alt=media", name: "kandles.km", price: "3000", phone: "+966535062894"))


               
               
               vedios.append(Video.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/videos%2FIMG_1294.jpg?alt=media", name: "video", desc:  "video desc11", vedioUrl: "https://scontent.cdninstagram.com/v/t50.2886-16/259647992_133827462350001_5707919355434925884_n.mp4?_nc_ht=scontent-nrt1-1.cdninstagram.com&_nc_cat=109&_nc_ohc=undaIqjm7oUAX9kJV4J&edm=APfKNqwBAAAA&ccb=7-4&oe=61E0E135&oh=00_AT8Hle65k0mFs4U86PwAxZzBIqLHo4riRJZa9bPV908MBw&_nc_sid=74f7ba&dl=1"))
               
               vedios.append(Video.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/videos%2FIMG_1297.jpg?alt=media", name: "video", desc:  "video desc11", vedioUrl: "https://scontent.cdninstagram.com/v/t50.2886-16/257139681_1189961958079746_9130747027862207146_n.mp4?_nc_ht=instagram.fsbz3-1.fna.fbcdn.net&_nc_cat=106&_nc_ohc=qdx91oD6VAkAX8xz6cT&edm=AJBgZrYBAAAA&ccb=7-4&oe=61E0BA0C&oh=00_AT_-KJN8aTAgY_7V91eKApeL_iQHvRRlEdby61WcUnIVow&_nc_sid=78c662&dl=1"))

               vedios.append(Video.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/videos%2FIMG_1300.jpg?alt=media", name: "video", desc:  "video desc11", vedioUrl: "https://scontent-nrt1-1.cdninstagram.com/v/t50.2886-16/179341696_115083037358910_4793463274800763933_n.mp4?efg=eyJ2ZW5jb2RlX3RhZyI6InZ0c192b2RfdXJsZ2VuLjcyMC5jbGlwcy5kZWZhdWx0IiwicWVfZ3JvdXBzIjoiW1wiaWdfd2ViX2RlbGl2ZXJ5X3Z0c19vdGZcIl0ifQ&_nc_ht=scontent-nrt1-1.cdninstagram.com&_nc_cat=106&_nc_ohc=GAyYHySiRTIAX83_2mV&edm=APfKNqwBAAAA&vs=17874627911368906_3077763141&_nc_vs=HBksFQAYJEdJQ0pzQW9fdTQtYnFtZ0FBQjFVWVpwenpZVkNicV9FQUFBRhUAAsgBABUAGCRHRmQtcGdybk5vNUZDbndPQUhMMHN1NExNb0ljYnFfRUFBQUYVAgLIAQAoABgAGwAVAAAmlLCL%2FaK4wD8VAigCQzMsF0A5CHKwIMScGBJkYXNoX2Jhc2VsaW5lXzFfdjERAHX%2BBwA%3D&ccb=7-4&oe=61E1110F&oh=00_AT8-1S8GERpP5WBF67qLrxXITjboYKxTnmj5UQFHc6nncQ&_nc_sid=74f7ba&dl=1"))
               
               vedios.append(Video.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/videos%2FIMG_1301.jpg?alt=media", name: "video", desc:  "video desc11", vedioUrl: "https://scontent-gmp1-1.cdninstagram.com/v/t50.2886-16/174440155_1129896154088427_5562944553891732001_n.mp4?efg=eyJ2ZW5jb2RlX3RhZyI6InZ0c192b2RfdXJsZ2VuLjcyMC5jbGlwcy5kZWZhdWx0IiwicWVfZ3JvdXBzIjoiW1wiaWdfd2ViX2RlbGl2ZXJ5X3Z0c19vdGZcIl0ifQ&_nc_ht=scontent-gmp1-1.cdninstagram.com&_nc_cat=103&_nc_ohc=glEV9_vBcoMAX9doWt7&edm=APfKNqwBAAAA&vs=17881967738307708_2493262943&_nc_vs=HBksFQAYJEdOdV9aUXJyd19WeW9nTUVBQ0VhNlJlWmpETk5icV9FQUFBRhUAAsgBABUAGCRHQTBPWEFvaHZkWUFLUWtCQUIzSGNYRTIyenh1YnFfRUFBQUYVAgLIAQAoABgAGwAVAAAm%2BLGjk8Hjwz8VAigCQzMsF0AwmZmZmZmaGBJkYXNoX2Jhc2VsaW5lXzJfdjERAHX%2BBwA%3D&ccb=7-4&oe=61E0AEE5&oh=00_AT_E1WZVZjOhQgNKvayhbqvoZGKya9wJ6__Z3u0riZYYww&_nc_sid=74f7ba&dl=1"))
               
               vedios.append(Video.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/videos%2FIMG_1302.jpg?alt=media", name: "video", desc:  "video desc11", vedioUrl: "https://scontent-cdt1-1.cdninstagram.com/v/t50.2886-16/165217131_277919283842298_5351656390822690290_n.mp4?efg=eyJ2ZW5jb2RlX3RhZyI6InZ0c192b2RfdXJsZ2VuLjcyMC5jbGlwcy5kZWZhdWx0IiwicWVfZ3JvdXBzIjoiW1wiaWdfd2ViX2RlbGl2ZXJ5X3Z0c19vdGZcIl0ifQ&_nc_ht=scontent-cdt1-1.cdninstagram.com&_nc_cat=106&_nc_ohc=ATMfViZMcgAAX-wluK3&edm=AJBgZrYBAAAA&vs=17992590103332703_2353739110&_nc_vs=HBksFQAYJEdHc0QyUW42akRBZ3hQd0FBUEo5N3hZaTUwUkticV9FQUFBRhUAAsgBABUAGCRHR2lsQlFyWlBIYU1ualVOQUdVbXNYUGhXc3RsYnFfRUFBQUYVAgLIAQAoABgAGwAVAAAmvr3P%2F8mK9j8VAigCQzMsF0A0IgxJul41GBJkYXNoX2Jhc2VsaW5lXzJfdjERAHX%2BBwA%3D&ccb=7-4&oe=61E143E7&oh=00_AT-zePgTA_xzr8NlFjzTXXMUdkibupm6Bu4SoEFVR7N_Kg&_nc_sid=78c662&dl=1"))

        self.videosCollectionView.reloadData()
        self.placesCollectionView.reloadData()

        NSLayoutConstraint.activate([
            
            videoslabel.topAnchor.constraint(equalTo: view.topAnchor ,constant: 80),
            videoslabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            videosCollectionView.topAnchor.constraint(equalTo: videoslabel.bottomAnchor ,constant: 16),
            videosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            videosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            videosCollectionView.heightAnchor.constraint(equalToConstant: 300),
            
            placeslabel.topAnchor.constraint(equalTo: videosCollectionView.bottomAnchor ,constant: 70),
            placeslabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            
            placesCollectionView.topAnchor.constraint(equalTo: placeslabel.bottomAnchor ,constant: 16),
            placesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            placesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            placesCollectionView.heightAnchor.constraint(equalToConstant: 300)
            
        ])
    }
}

extension PlacesVideosVC: JYCardViewDataSource , JYCardViewDelegate{
    
    func cardView(cardView: JYCardView, indexPath: IndexPath) {
        let url = URL(string:  vedios[indexPath.row].vedioUrl)!
            
            playVideo(url: url)
    }
    
    func numberOfItems(in cardView: JYCardView) -> Int {
       return vedios.count
    }
    
    func cardView(cardView: JYCardView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = cardView.dequeueReusableCell(withReuseIdentifier: CardViewCell.cellID, forIndex: index) as! CardViewCell
        cell.cardViewModel = vedios[index]
        return cell
    }
    
    func cardView(cardView: JYCardView, didRemoveCell cell: UICollectionViewCell, updateCallback:((Bool)->Void)?) {
        vedios.removeFirst()
        
        cardView.performBatchUpdates(updates: {
            cardView.collectionView.deleteItems(at: [IndexPath(item: 0, section: 0)])
        }, completion: {
            
            if self.vedios.count < 2 { //
                
                
                let indexes = IndexPath(item: self.vedios.count, section: 0)
                if self.vedios.count > 0 {
                self.vedios.append(self.vedios[0])
                }else{
                    self.vedios.append(Video.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/EK7kGv6W4AAulFC.jpg?alt=media", name: "video", desc:  "video desc", vedioUrl: "https://scontent.cdninstagram.com/v/t50.2886-16/179341696_115083037358910_4793463274800763933_n.mp4?efg=eyJ2ZW5jb2RlX3RhZyI6InZ0c192b2RfdXJsZ2VuLjcyMC5jbGlwcy5kZWZhdWx0IiwicWVfZ3JvdXBzIjoiW1wiaWdfd2ViX2RlbGl2ZXJ5X3Z0c19vdGZcIl0ifQ&_nc_ht=instagram.fbep1-1.fna.fbcdn.net&_nc_cat=106&_nc_ohc=bViDhw_IUekAX-6MsAQ&edm=APfKNqwBAAAA&vs=17874627911368906_3077763141&_nc_vs=HBksFQAYJEdJQ0pzQW9fdTQtYnFtZ0FBQjFVWVpwenpZVkNicV9FQUFBRhUAAsgBABUAGCRHRmQtcGdybk5vNUZDbndPQUhMMHN1NExNb0ljYnFfRUFBQUYVAgLIAQAoABgAGwAVAAAmlLCL%2FaK4wD8VAigCQzMsF0A5CHKwIMScGBJkYXNoX2Jhc2VsaW5lXzFfdjERAHX%2BBwA%3D&ccb=7-4&oe=61DE6E0F&oh=00_AT_R8fRVneRuUmL_J7M6w_syjcQ3QvwGP8_9g1ewwpTP-g&_nc_sid=74f7ba&dl=1"))
                }
                cardView.insertCells(atIndexPath: [indexes])
            }
            updateCallback?($0)
        })
    }
    
}

