//
//  AppDelegate.swift
//  NewsAgregator
//
//  Created by Игорь Иванюков on 12.02.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: MainVC())
        
        return true
    }
}

extension UINavigationController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleColor = UIColor(named: "txt")
        let buttonTextColor = UIColor(named: "btn")
        
        let largeTitleAttributes: [NSAttributedString.Key : Any] = [.foregroundColor: titleColor!, .font : UIFont.systemFont(ofSize: 36, weight: .bold)]
        
        let titleAttributes: [NSAttributedString.Key : Any] = [.foregroundColor: titleColor!, .font : UIFont.systemFont(ofSize: 20, weight: .medium)]
        
        self.view.backgroundColor = UIColor(named: "bgVC")
        
        let customFont = UIFont.systemFont(ofSize: 17, weight: .medium)
        let attributes = [NSAttributedString.Key.font: customFont]
        
        let largeTitleAppearance = UINavigationBarAppearance()
        largeTitleAppearance.configureWithOpaqueBackground()
        largeTitleAppearance.shadowImage = nil
        largeTitleAppearance.shadowColor = .clear
        largeTitleAppearance.backgroundColor = UIColor(named: "bgVC")
        largeTitleAppearance.titleTextAttributes = titleAttributes
        largeTitleAppearance.largeTitleTextAttributes = largeTitleAttributes
        self.navigationBar.standardAppearance = largeTitleAppearance
        self.navigationBar.scrollEdgeAppearance = largeTitleAppearance
        
        let buttonAppearance = UIBarButtonItemAppearance()
        buttonAppearance.normal.titleTextAttributes = attributes
        largeTitleAppearance.buttonAppearance = buttonAppearance
        
        self.view.backgroundColor = UIColor(named: "bgVC")
        self.navigationBar.isTranslucent = false
        self.navigationBar.prefersLargeTitles = true
        
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.tintColor = buttonTextColor
        self.navigationBar.barTintColor = UIColor(named: "bgVC")
        
        self.navigationBar.titleTextAttributes = titleAttributes
        self.navigationBar.largeTitleTextAttributes = largeTitleAttributes
        
        self.navigationItem.backBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
    }
}
