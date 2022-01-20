
//  Created by Sana Alshahrani on 20/04/1443 AH.
//

import UIKit
import SwiftyOnboard

class OnboardVC: UIViewController{
    
    var swiftyOnboard: SwiftyOnboard!
//    #colorLiteral(red: 0.6911879182, green: 0.5587696433, blue: 0.6810679436, alpha: 1)
    let colors:[UIColor] = [ #colorLiteral(red: 0.9180842042, green: 0.5687887669, blue: 0.581851542, alpha: 1) , #colorLiteral(red: 0.6911879182, green: 0.5587696433, blue: 0.6810679436, alpha: 1), #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1) ]
    var titleArray: [String] = ["Welcome to PhotoBox ", "Share PhotoBox App", "You can use the App"]
    var subTitleArray: [String] = ["Because behind every picture\n there is a story\n We tell your stories with love 🤍.\n ", "share PhotoBox\n with family and friends 😄.", "Register in the application\n and enjoy the experience"]
    
    var gradiant: CAGradientLayer = {
        //Gradiant for the background view
        let blue = UIColor(red: 69/255, green: 127/255, blue: 202/255, alpha: 1.0).cgColor
        let purple = UIColor(red: 166/255, green: 172/255, blue: 236/255, alpha: 1.0).cgColor
        let gradiant = CAGradientLayer()
        gradiant.colors = [purple, blue]
        gradiant.startPoint = CGPoint(x: 0.5, y: 0.18)
        return gradiant
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradient()
        
        swiftyOnboard = SwiftyOnboard(frame: view.frame, style: .light)
        view.addSubview(swiftyOnboard)
        swiftyOnboard.dataSource = self
        swiftyOnboard.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func gradient() {
        //Add the gradiant to the view:
        self.gradiant.frame = view.bounds
        view.layer.addSublayer(gradiant)
    }
    
    @objc func handleSkip() {
        if UserDefaults.standard.bool(forKey: "SelectCategory") {
            let vc = TabBar()
            vc.modalPresentationStyle = .fullScreen

            self.present(vc, animated: true)
        }else{
          
            let vc = CategoryVC()
            vc.modalPresentationStyle = .fullScreen

            self.present(vc, animated: true)
            
        }
      
    }
    
    @objc func handleContinue(sender: UIButton) {
        let index = sender.tag
        swiftyOnboard?.goToPage(index: index + 1, animated: true)
    }
    @objc func handleGoToApp(sender: UIButton) {
        if UserDefaults.standard.bool(forKey: "SelectCategory") {
            let vc = TabBar()
            vc.modalPresentationStyle = .fullScreen

            self.present(vc, animated: true)
        }else{
          
            let vc = CategoryVC()
            vc.modalPresentationStyle = .fullScreen

            self.present(vc, animated: true)
            
        }

    }
}

extension OnboardVC: SwiftyOnboardDelegate, SwiftyOnboardDataSource {
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        //Number of pages in the onboarding:
        return 3
    }
    
    func swiftyOnboardBackgroundColorFor(_ swiftyOnboard: SwiftyOnboard, atIndex index: Int) -> UIColor? {
        //Return the background color for the page at index:
        return colors[index]
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let view = SwiftyOnboardPage()
        
        //Set the image on the page:
        view.imageView.image = UIImage(named: "onboard\(index)")
        
        //Set the font and color for the labels:
        view.title.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        view.subTitle.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        //Set the text in the page:
        view.title.text = titleArray[index]
        view.subTitle.text = subTitleArray[index]
        
        //Return the page for the given index:
        return view
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = SwiftyOnboardOverlay()
        
        //Setup targets for the buttons on the overlay view:
        overlay.skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        overlay.continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        
        //Setup for the overlay buttons:
        overlay.continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        overlay.continueButton.setTitleColor( UIColor.init(named: "witeColor")!, for: .normal)
        overlay.skipButton.setTitleColor( UIColor.init(named: "witeColor")!, for: .normal)
        overlay.skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        //Return the overlay view:
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        let currentPage = round(position)
        overlay.pageControl.currentPage = Int(currentPage)
        print(Int(currentPage))
        overlay.continueButton.tag = Int(position)
        
        if currentPage == 0.0 || currentPage == 1.0 {
            overlay.continueButton.setTitle("Continue".localized, for: .normal)
            overlay.skipButton.setTitle("Skip".localized, for: .normal)
            overlay.continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)

            overlay.skipButton.isHidden = false
        } else {
            overlay.continueButton.setTitle("Get Started!".localized, for: .normal)
            overlay.continueButton.addTarget(self, action: #selector(handleGoToApp), for: .touchUpInside)

            overlay.skipButton.isHidden = true
        }
    }
}
