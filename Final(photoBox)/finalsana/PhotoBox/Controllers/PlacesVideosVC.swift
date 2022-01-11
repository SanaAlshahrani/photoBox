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


        
        
        vedios.append(Video.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/videos%2FIMG_1294.jpg?alt=media", name: "video", desc:  "video desc11", vedioUrl: "https://www.instagram.com/45yosf/reel/CNKwLqEHNCc/?utm_medium=copy_link"))
        vedios.append(Video.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/videos%2FIMG_1297.jpg?alt=media", name: "video", desc:  "video desc11", vedioUrl: "https://www.instagram.com/45yosf/reel/CYUUGpFq_PJ/?utm_medium=copy_link"))
        vedios.append(Video.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/videos%2FIMG_1298.jpg?alt=media", name: "video", desc:  "video desc11", vedioUrl: "https://www.instagram.com/45yosf/reel/CYUUGpFq_PJ/?utm_medium=copy_link"))
        vedios.append(Video.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/videos%2FIMG_1300.jpg?alt=media", name: "video", desc:  "video desc11", vedioUrl: "https://www.instagram.com/45yosf/reel/CYUUGpFq_PJ/?utm_medium=copy_link"))
        vedios.append(Video.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/videos%2FIMG_1301.jpg?alt=media", name: "video", desc:  "video desc11", vedioUrl: "https://www.instagram.com/45yosf/reel/CYUUGpFq_PJ/?utm_medium=copy_link"))
        vedios.append(Video.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/videos%2FIMG_1302.jpg?alt=media", name: "video", desc:  "video desc11", vedioUrl: "https://www.instagram.com/45yosf/reel/CYUUGpFq_PJ/?utm_medium=copy_link"))

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
                let newModels =  Video.init(image: "https://firebasestorage.googleapis.com/v0/b/photobox-f6c5e.appspot.com/o/EK7kGv6W4AAulFC.jpg?alt=media", name: "video \(self.vedios.count + 1)", desc:  "video desc\(self.vedios.count + 1)", vedioUrl: "https://rr2---sn-5hne6nzd.googlevideo.com/videoplayback?expire=1640764847&ei=T8HLYY_RAsC50_wPs--R6A0&ip=198.181.163.105&id=o-AFF_tHEsswz6iZIM3kRH53KNdJ8CrfXhk4V3tHaaES8o&itag=18&source=youtube&requiressl=yes&vprv=1&mime=video%2Fmp4&ns=ULe_5TnskCNm-W2oHRfZDuQG&gir=yes&clen=16692257&ratebypass=yes&dur=525.467&lmt=1605913787409198&fexp=24001373,24007246&c=WEB&txp=5316222&n=X-uqr2h0t_IoSA&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cns%2Cgir%2Cclen%2Cratebypass%2Cdur%2Clmt&sig=AOq0QJ8wRQIhAO8A77BPMhrhYquoUXq5wHGshW5_StIK01i1b_ITwuYFAiB2G98I3cexnC5tK69tx_umlW870OHsxmWkeiUiimxdfg%3D%3D&redirect_counter=1&cm2rm=sn-p5qe7l7l&req_id=ce8343c6126aa3ee&cms_redirect=yes&mh=1s&mip=82.205.12.239&mm=34&mn=sn-5hne6nzd&ms=ltu&mt=1640743124&mv=u&mvi=2&pl=17&lsparams=mh,mip,mm,mn,ms,mv,mvi,pl&lsig=AG3C_xAwRgIhAP2csfuuootGfqHToCxEJVPVoENyKidjleZH7iLZXAZCAiEA_XJRsaWlbMv6E-3wVEjnMvXK49Z4fpQDtLiBKisVMdE%3D")
                
               
                let indexes = IndexPath(item: self.vedios.count, section: 0)
                self.vedios.append(newModels)
                cardView.insertCells(atIndexPath: [indexes])
            }
            updateCallback?($0)
        })
    }
    
}

