//
//  AppController.swift
//  Gong_Gan
//
//  Created by 이창형 on 11/7/23.
//

import UIKit
import Firebase


// Firebase 초기화 및 로그인 상태에 따라 플로우를 담당하는 class
final class AppController {
    static let shared = AppController()
    private init() {
        FirebaseApp.configure()
        registerAuthStateDidChangeEvent()
    }
    
    private var window: UIWindow!
    private var rootViewController: UIViewController? {
        didSet {
            window.rootViewController = rootViewController
        }
    }
    
    func show(in window: UIWindow) {
        self.window = window
        window.backgroundColor = .systemBackground
        window.makeKeyAndVisible()
        
        // 로그인이 완료된 경우에는 AuthStateDidChange 이벤트를 받아서 NotificationCenter에 의하여 자동 로그인
        if Auth.auth().currentUser == nil {
            // 로그인 완료 되지 않았을때 로그인 뷰로
            routeToLogin()
        }
    }
    
    private func registerAuthStateDidChangeEvent() {
        NotificationCenter.default.addObserver(self, selector: #selector(checkLogin), name: .AuthStateDidChange, object: nil)
    }
    
    @objc private func checkLogin() {
        if let user = Auth.auth().currentUser {
            // 로그인 되었을때
            print("AppController -> user = \(user)")
            setHome()
        } else {
            routeToLogin()
        }
    }
    
    private func setHome() {
        rootViewController = UINavigationController(rootViewController: MainViewController())
    }
    
    private func routeToLogin() {
        // TODO: 로그인 뷰로 보내줘야함 아직 개발 전이라 모두 다 mainView로 보내주는 중
        rootViewController = UINavigationController(rootViewController: LoginViewController())
    }
    
}

//import UIKit
//import Firebase
//
//final class AppController {
//    static let shared = AppController()
//    private init() {
//        FirebaseApp.configure()
//        registerAuthStateDidChangeEvent()
//    }
//    
//    private var window: UIWindow!
//    private var rootViewController: UIViewController? {
//        didSet {
//            window.rootViewController = rootViewController
//        }
//    }
//    
//    func show(in window: UIWindow) {
//        self.window = window
//        window.backgroundColor = .systemBackground
//        window.makeKeyAndVisible()
//
//        // 로그인이 완료된 경우에는 AuthStateDidChange 이벤트를 받아서 NotificationCenter에 의하여 자동 로그인
//        if Auth.auth().currentUser == nil {
//            routeToLogin()
//        }
//    }
//    
//    private func registerAuthStateDidChangeEvent() {
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(checkLogin),
//                                               name: .AuthStateDidChange, // <- Firebase Auth 이벤트
//                                               object: nil)
//    }
//        
//    @objc private func checkLogin() {
//        if let user = Auth.auth().currentUser { // <- Firebase Auth
//            print("user = \(user)")
//            setHome()
//        } else {
//            routeToLogin()
//        }
//    }
//    
//    private func setHome() {
//        rootViewController = UINavigationController(rootViewController: MainViewController())
//    }
//
//    private func routeToLogin() {
//        rootViewController = UINavigationController(rootViewController: MainViewController())
//    }
//    
//}
