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
        if collectionView == placesCollectionView {
            return places.count
        }else{
            return vedios.count

        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == placesCollectionView {
            guard let number = URL(string: "tel://" + places[indexPath.row].phone) else { return }
            UIApplication.shared.open(number)
            
        }else{
            let url = URL(string:  vedios[indexPath.row].vedioUrl)!
                
                playVideo(url: url)
            }
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
        
        if collectionView == placesCollectionView {
            cell.configure(image: places[indexPath.row].image, titel: places[indexPath.row].name, descreption: places[indexPath.row].price + "SAR".localized)
        }else{
            cell.configure(image: vedios[indexPath.row].image, titel: vedios[indexPath.row].name, descreption: vedios[indexPath.row].desc)

        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        return CGSize(
            width: 200,
            height: 280
        )
    }

    override func viewDidLoad() {
        self.view.backgroundColor =  UIColor.init(named: "witeColor")!
        self.view.addSubview(placeslabel)
        self.view.addSubview(placesCollectionView)
        self.view.addSubview(videoslabel)
        self.view.addSubview(videosCollectionView)

        super.viewDidLoad()
        
        places.append(Place.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/IMG_1116.jpg?alt=media", name: "pallete cafe", price: "free ", phone: ""))
        places.append(Place.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/IMG_1110.jpg?alt=media", name: "lapis", price: "2500", phone: ""))
        places.append(Place.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/IMG_1111.jpg?alt=media", name: "lecce_shalih", price: "3000", phone: "+966505695588"))
        places.append(Place.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/IMG_1112.jpg?alt=media", name: "levanzo.shalih", price: "2000", phone: "+966505758866"))
        places.append(Place.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/IMG_1111.jpg?alt=media", name: "lecce_shalih", price: "3000", phone: "+966505695588"))
        places.append(Place.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/IMG_1113.jpg?alt=media", name: "bluewave", price: "1500", phone: "+966539666685"))
        places.append(Place.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/IMG_1114.jpg?alt=media", name: "ajdan.resot", price: "3000", phone: "+966506458607"))
        places.append(Place.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/IMG_1115.jpg?alt=media", name: "kandles.km", price: "3000", phone: "+966535062894"))


        
        
        vedios.append(Video.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/videos%2FIMG_1294.jpg?alt=media", name: "video", desc:  "video desc11", vedioUrl: "https://scontent-ssn1-1.cdninstagram.com/v/t50.2886-16/259647992_133827462350001_5707919355434925884_n.mp4?_nc_ht=scontent-ssn1-1.cdninstagram.com&_nc_cat=109&_nc_ohc=dD9dUQHOIukAX-8pEzz&edm=APfKNqwBAAAA&ccb=7-4&oe=61E62735&oh=00_AT_hR1fxByUcST6c1D5wrI1jLiX8yUMGVeNBr7crp_xCig&_nc_sid=74f7ba&dl=1"))
        vedios.append(Video.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/videos%2FIMG_1297.jpg?alt=media", name: "video", desc:  "video desc11", vedioUrl: "https://scontent-amt2-1.cdninstagram.com/v/t50.2886-16/257139681_1189961958079746_9130747027862207146_n.mp4?_nc_ht=scontent-amt2-1.cdninstagram.com&_nc_cat=106&_nc_ohc=frh31HfCbpUAX_aiV3K&edm=AJBgZrYBAAAA&ccb=7-4&oe=61E6A8CC&oh=00_AT8NGVotAvb60hn8hd44hpHdX2-KFXWJ1i23oYkCYBKFAA&_nc_sid=78c662&dl=1"))
        vedios.append(Video.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/videos%2FIMG_1298.jpg?alt=media", name: "video", desc:  "video desc11", vedioUrl: "https://scontent-ams4-1.cdninstagram.com/v/t50.2886-16/245216052_306875231248709_7923575202891473050_n.mp4?efg=eyJ2ZW5jb2RlX3RhZyI6InZ0c192b2RfdXJsZ2VuLjcyMC5jbGlwcy5iYXNlbGluZSIsInFlX2dyb3VwcyI6IltcImlnX3dlYl9kZWxpdmVyeV92dHNfb3RmXCJdIn0&_nc_ht=scontent-ams4-1.cdninstagram.com&_nc_cat=105&_nc_ohc=7es7A-ZULNoAX-IiWH_&edm=AJBgZrYBAAAA&vs=218546717009984_730253670&_nc_vs=HBksFQAYJEdEU3puUTVGSVNiMUdSY0JBSnFnY0llcU1mWnRicV9FQUFBRhUAAsgBABUAGCRHQW9qcFE3N1JqbEozaUlCQUZJVGlZY1JOMXNtYnFfRUFBQUYVAgLIAQAoABgAGwAVAAAmoNeIkq%2Bfsj8VAigCQzMsF0A25mZmZmZmGBJkYXNoX2Jhc2VsaW5lXzFfdjERAHX%2BBwA%3D&ccb=7-4&oe=61E69C5D&oh=00_AT_0BLrae9sZv2y9NPu_IKF7YPu_tVh7vyGeHuDwYQogwg&_nc_sid=78c662&dl=1"))
        vedios.append(Video.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/videos%2FIMG_1300.jpg?alt=media", name: "video", desc:  "video desc11", vedioUrl: "https://instagram.fhkg10-1.fna.fbcdn.net/v/t50.2886-16/179341696_115083037358910_4793463274800763933_n.mp4?efg=eyJ2ZW5jb2RlX3RhZyI6InZ0c192b2RfdXJsZ2VuLjcyMC5jbGlwcy5kZWZhdWx0IiwicWVfZ3JvdXBzIjoiW1wiaWdfd2ViX2RlbGl2ZXJ5X3Z0c19vdGZcIl0ifQ&_nc_ht=instagram.fhkg10-1.fna.fbcdn.net&_nc_cat=106&_nc_ohc=WmxhMeC651oAX_V7oTj&edm=APfKNqwBAAAA&vs=17874627911368906_3077763141&_nc_vs=HBksFQAYJEdJQ0pzQW9fdTQtYnFtZ0FBQjFVWVpwenpZVkNicV9FQUFBRhUAAsgBABUAGCRHRmQtcGdybk5vNUZDbndPQUhMMHN1NExNb0ljYnFfRUFBQUYVAgLIAQAoABgAGwAVAAAmlLCL%2FaK4wD8VAigCQzMsF0A5CHKwIMScGBJkYXNoX2Jhc2VsaW5lXzFfdjERAHX%2BBwA%3D&ccb=7-4&oe=61E6570F&oh=00_AT-nHDUNxWD-pTij9JMf_3mz1JIkcTtIScdYVM1teiRmdA&_nc_sid=74f7ba&dl=1"))
        vedios.append(Video.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/videos%2FIMG_1301.jpg?alt=media", name: "video", desc:  "video desc11", vedioUrl: "https://scontent-ssn1-1.cdninstagram.com/v/t50.2886-16/174440155_1129896154088427_5562944553891732001_n.mp4?efg=eyJ2ZW5jb2RlX3RhZyI6InZ0c192b2RfdXJsZ2VuLjcyMC5jbGlwcy5kZWZhdWx0IiwicWVfZ3JvdXBzIjoiW1wiaWdfd2ViX2RlbGl2ZXJ5X3Z0c19vdGZcIl0ifQ&_nc_ht=scontent-ssn1-1.cdninstagram.com&_nc_cat=103&_nc_ohc=0VlWMncuiNgAX8k63sI&edm=APfKNqwBAAAA&vs=17881967738307708_2493262943&_nc_vs=HBksFQAYJEdOdV9aUXJyd19WeW9nTUVBQ0VhNlJlWmpETk5icV9FQUFBRhUAAsgBABUAGCRHQTBPWEFvaHZkWUFLUWtCQUIzSGNYRTIyenh1YnFfRUFBQUYVAgLIAQAoABgAGwAVAAAm%2BLGjk8Hjwz8VAigCQzMsF0AwmZmZmZmaGBJkYXNoX2Jhc2VsaW5lXzJfdjERAHX%2BBwA%3D&ccb=7-4&oe=61E69DA5&oh=00_AT89DF25AKW0H1NJOT4_aRyTlpgdTAn7EemkFdMctI6WkA&_nc_sid=74f7ba&dl=1"))
        vedios.append(Video.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/videos%2FIMG_1302.jpg?alt=media", name: "video", desc:  "video desc11", vedioUrl: "https://scontent-yyz1-1.cdninstagram.com/v/t50.2886-16/165217131_277919283842298_5351656390822690290_n.mp4?efg=eyJ2ZW5jb2RlX3RhZyI6InZ0c192b2RfdXJsZ2VuLjcyMC5jbGlwcy5kZWZhdWx0IiwicWVfZ3JvdXBzIjoiW1wiaWdfd2ViX2RlbGl2ZXJ5X3Z0c19vdGZcIl0ifQ&_nc_ht=scontent-yyz1-1.cdninstagram.com&_nc_cat=106&_nc_ohc=GE6mbMgKWF0AX9fCt7W&edm=AJBgZrYBAAAA&vs=17992590103332703_2353739110&_nc_vs=HBksFQAYJEdHc0QyUW42akRBZ3hQd0FBUEo5N3hZaTUwUkticV9FQUFBRhUAAsgBABUAGCRHR2lsQlFyWlBIYU1ualVOQUdVbXNYUGhXc3RsYnFfRUFBQUYVAgLIAQAoABgAGwAVAAAmvr3P%2F8mK9j8VAigCQzMsF0A0IgxJul41GBJkYXNoX2Jhc2VsaW5lXzJfdjERAHX%2BBwA%3D&ccb=7-4&oe=61E689E7&oh=00_AT--AWfVPhWj94MfBtc7Hu4C98UW4di6xw88elSAejST2Q&_nc_sid=78c662&dl=1"))

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
        vedios.count
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
                let newModels =  Video.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/videos%2FIMG_1294.jpg?alt=media", name: "video", desc:  "video desc11", vedioUrl: "https://scontent-ssn1-1.cdninstagram.com/v/t50.2886-16/259647992_133827462350001_5707919355434925884_n.mp4?_nc_ht=scontent-ssn1-1.cdninstagram.com&_nc_cat=109&_nc_ohc=dD9dUQHOIukAX-8pEzz&edm=APfKNqwBAAAA&ccb=7-4&oe=61E62735&oh=00_AT_hR1fxByUcST6c1D5wrI1jLiX8yUMGVeNBr7crp_xCig&_nc_sid=74f7ba&dl=1")
                
               
                let indexes = IndexPath(item: self.vedios.count, section: 0)
                self.vedios.append(newModels)
                cardView.insertCells(atIndexPath: [indexes])
            }
            updateCallback?($0)
        })
    }
    
}

