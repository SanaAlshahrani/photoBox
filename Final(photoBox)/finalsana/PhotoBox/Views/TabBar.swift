//
//  TabBar.swift
//  PhotoBox
//
//  Created by Sana Alshahrani on 24/05/1443 AH.
//

import UIKit

class TabBar: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
   
    
        viewControllers = [
            barItem(tabBarTitle: "images".localized, tabBarImage: UIImage(systemName:    "photo.on.rectangle.angled")!.withTintColor(UIColor( #colorLiteral(red: 0.7037770748, green: 0.4958333373, blue: 0.6524182558, alpha: 1)), renderingMode: .alwaysOriginal), viewController: ImagesCV()),
           
           
//            barItem(tabBarTitle: "Users".localized, tabBarImage: UIImage(systemName: "plus.message")!.withTintColor(UIColor( #colorLiteral(red: 0.7037770748, green: 0.4958333373, blue: 0.6524182558, alpha: 1)), renderingMode: .alwaysOriginal), viewController: UsersVC()),
//
//            barItem(tabBarTitle: "", tabBarImage: UIImage(systemName: "laptopcomputer.and.arrow.down")!.withTintColor(UIColor( #colorLiteral(red: 0.7037770748, green: 0.4958333373, blue: 0.6524182558, alpha: 1)), renderingMode: .alwaysOriginal), viewController: PlacesVideosVC()),
//
//            
            barItem(tabBarTitle: "camera".localized, tabBarImage: UIImage(systemName: "camera")!.withTintColor(UIColor( #colorLiteral(red: 0.7037770748, green: 0.4958333373, blue: 0.6524182558, alpha: 1)), renderingMode: .alwaysOriginal), viewController: CameraVC()),

//            
//            
//            
//            barItem(tabBarTitle: "Settings".localized, tabBarImage: UIImage(systemName: "person.circle")!.withTintColor(UIColor( #colorLiteral(red: 0.7037770748, green: 0.4958333373, blue: 0.6524182558, alpha: 1)), renderingMode: .alwaysOriginal), viewController: ProfileVC()),

            
        ]
        tabBar.isTranslucent = true
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor( #colorLiteral(red: 0, green: 0.4916976094, blue: 0.8193511367, alpha: 1))], for: .selected)
        tabBar.unselectedItemTintColor = .gray
    }
    
    private func barItem(tabBarTitle: String, tabBarImage: UIImage, viewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = tabBarTitle
        navigationController.tabBarItem.image = tabBarImage
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
}
    


