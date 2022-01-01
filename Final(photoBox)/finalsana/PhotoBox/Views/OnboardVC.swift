import UIKit
import SwiftyOnboard

class OnboardVC: UIViewController{
    
    var swiftyOnboard: SwiftyOnboard!
    
    let colors:[UIColor] = [ #colorLiteral(red: 0.9180842042, green: 0.5687887669, blue: 0.581851542, alpha: 1) , #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1), #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1) ]
    var titleArray: [String] = ["Welcome to Confess!", "It’s completely anonymous", "Say something positive"]
    var subTitleArray: [String] = ["Confess lets you anonymously\n send confessions to your friends\n and receive confessions from them.", "All confessions sent are\n anonymous. Your friends will only\n know that it came from one of\n their facebook friends.", "Be nice to your friends.\n Send them confessions that\n will make them smile :)"]
    
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
        let vc = TabBar()
        vc.modalPresentationStyle = .fullScreen

        self.present(vc, animated: true)
    }
    
    @objc func handleContinue(sender: UIButton) {
        let index = sender.tag
        swiftyOnboard?.goToPage(index: index + 1, animated: true)
    }
    @objc func handleGoToApp(sender: UIButton) {
        let vc = TabBar()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
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
        view.subTitle.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
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
