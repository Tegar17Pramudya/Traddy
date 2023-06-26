//
//  Extensions.swift
//  Traddy
//
//  Created by Hafidz Ismail Hidayat on 09/06/23.
//

import SwiftUI

extension View {
    
    func setNavbarColor(color: Color){
        
    }
    
    func setNavbarTitleColor(color: Color){
        
    }
}

//NavigationController Helpers
extension UINavigationController{
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
//        UINavigationBar.appearance().shadowImage = UIImage().
//        UINavigationBar.appearance().s = UIImage()
        UINavigationBar.appearance().backIndicatorImage = UIImage(systemName: "chevron.backward.circle.fill")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.backward.circle.fill")?.withTintColor(UIColor.white)
        UINavigationBar.appearance().tintColor = UIColor.white
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.clear
        ], for: .normal)
    }
}
