//
//  LoginViewController.swift
//  Gong_Gan
//
//  Created by 이창형 on 11/7/23.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseCore
import AuthenticationServices
import FirebaseFirestoreInternal
import CryptoKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class LoginViewController: UIViewController {
    let viewModel = LoginViewModel()
    let isEmailValid = BehaviorSubject(value: false)
    let isPwValid = BehaviorSubject(value: false)
    let disposeBag = DisposeBag()
    
    private let brandImage: UIImageView = {
        let imageView = UIImageView()
        
        if let image = UIImage(named: "brand") {
            imageView.image = image
        }
        
        return imageView
    }()
    
    private let appleLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apple로 로그인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.layer.cornerRadius = 25
        button.backgroundColor = .white
        
        // 이미지 설정
        if let appleImage = UIImage(named: "apple") {
            button.setImage(appleImage, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -100, bottom: 0, right: 0)
        }
        
        // titleLabel 중앙에 위치시키기
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -button.imageView!.frame.size.width, bottom: 0, right: 0)
        
        return button
    }()
    
    private let emailLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("이메일 로그인", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .brandColor
        button.layer.cornerRadius = 25
        
        if let mailImage = UIImage(named: "mail") {
            button.setImage(mailImage, for: .normal)
            button.imageView?.contentMode = .scaleToFill
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -100, bottom: 0, right: 0)
        }
        
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -button.imageView!.frame.size.width, bottom: 0, right: 0)
        
        return button
    }()
    
    private let joinButton: UIButton = {
        let button = UIButton()
        let fullText = "아직 회원이 아니라면? 회원가입"
        
        button.setTitle(fullText, for: .normal)
        button.setTitleColor(.galleryLabelColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        
        // 전체 텍스트에 대한 스타일 설정
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)
        ])
        
        // "회원가입" 부분에만 밑줄 추가
        let range = (fullText as NSString).range(of: "회원가입")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue,range: range)
        
        let textColor = UIColor.brandColor
        // "회원가입" 부분만 색 변경
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: range)
        
        
        button.setAttributedTitle(attributedString, for: .normal)
        
        button.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let seeFirstButton: UIButton = {
        let button = UIButton()
        button.setTitle("먼저 둘러볼게요", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        
        let attributedString = NSAttributedString(string: button.titleLabel?.text ?? "", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.baselineOffset: 4])
        button.setAttributedTitle(attributedString, for: .normal)

        return button
    }()

    
    // TODO: 카카오 로그인시 이메일을 아직 받아오지 못하기 때문에 임시 제거
    // TODO: 카카오 로그인시 이메일을 받아오려면 카카오에 검수를해 동의를 받아야함
//    private let kakaoLoginButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("카카오로 로그인", for: .normal)
//        button.backgroundColor = .systemBlue
//        button.layer.cornerRadius = 6
//        button.addTarget(self, action: #selector(KakaoLogin), for: .touchUpInside)
//        
//        return button
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackGroundColor
        addViews()
        setConstraints()
        setupControl()
    }
    
    private func addViews() {
        view.addSubview(brandImage)
        view.addSubview(joinButton)
        view.addSubview(appleLoginButton)
        view.addSubview(seeFirstButton)
        view.addSubview(emailLoginButton)
//        view.addSubview(kakaoLoginButton)
    }
    
    private func setConstraints() {
        
        seeFirstButton.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-51)
            $0.centerX.equalToSuperview()
        })
        
        joinButton.snp.makeConstraints({
            $0.bottom.equalTo(seeFirstButton.snp.top).offset(-49)
            $0.centerX.equalToSuperview()
        })
        
        emailLoginButton.snp.makeConstraints({
            $0.bottom.equalTo(joinButton.snp.top).offset(-16)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(56)
        })
        
        appleLoginButton.snp.makeConstraints({
            $0.bottom.equalTo(emailLoginButton.snp.top).offset(-20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(56)
        })
        
        brandImage.snp.makeConstraints({
            $0.centerX.equalToSuperview()
//            $0.bottom.equalTo(appleLoginButton.snp.top).offset(-125)
            $0.centerY.equalToSuperview().offset(-view.bounds.height / 6)
        })
        
        
//        kakaoLoginButton.snp.makeConstraints({
//            $0.top.equalTo(appleLoginButton.snp.bottom).offset(30)
//            $0.centerX.equalToSuperview()
//            $0.width.equalTo(100)
//            $0.height.equalTo(30)
//        })
    }
    
    private func setupControl() {
        appleLoginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.startSignInWithAppleFlow()
            })
            .disposed(by: disposeBag)
        
        emailLoginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let vc = EmailLoginViewController()
                
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        seeFirstButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let vc = MainViewController()
                vc.seeFirst = true
                self?.navigationController?.pushViewController(vc, animated: false)
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func joinButtonTapped() {
        let vc = JoinViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func KakaoLogin(_ sender: Any) {
        if AuthApi.hasToken() {
            UserApi.shared.accessTokenInfo { _, error in
                if let error = error {
                    print("_________login error_________")
                    print(error)
                    if UserApi.isKakaoTalkLoginAvailable() {
                        UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                            if let error = error {
                                print(error)
                            } else {
                                print("New Kakao Login")
                                
                                //do something
                                _ = oauthToken
                                
                                // 로그인 성공 시
                                UserApi.shared.me { kuser, error in
                                    if let error = error {
                                        print("------KAKAO : user loading failed------")
                                        print(error)
                                    } else {
                                        Auth.auth().createUser(withEmail: (kuser?.kakaoAccount?.email)!, password: "\(String(describing: kuser?.id))") { fuser, error in
                                            if let error = error {
                                                print("FB : signup failed")
                                                print(error)
                                                Auth.auth().signIn(withEmail: (kuser?.kakaoAccount?.email)!, password: "\(String(describing: kuser?.id))", completion: nil)
                                            } else {
                                                print("FB : signup success")
                                            }
                                        }
                                    }
                                }
                                
                                let VC = self.storyboard?.instantiateViewController(identifier: "MainViewController") as! MainViewController
                                VC.modalPresentationStyle = .fullScreen
                                self.present(VC, animated: true, completion: nil)
                                
                            }
                        }
                    }
                } else {
                    print("good login")
                    let VC = self.storyboard?.instantiateViewController(identifier: "MainViewController") as! MainViewController
                    VC.modalPresentationStyle = .fullScreen
                    self.present(VC, animated: true, completion: nil)
                }
            }
        } else {
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                    if let error = error {
                        print(error)
                    } else {
                        print("New Kakao Login")
                        
                        //do something
                        _ = oauthToken
                        
                        // 로그인 성공 시
                        UserApi.shared.me { kuser, error in
                            if let error = error {
                                print("------KAKAO : user loading failed------")
                                print(error)
                            } else {
                                // TODO: 이메일 받아오도록 승인받아야함 카카오에서 그리곤 수정필요
                                Auth.auth().createUser(withEmail: (kuser?.kakaoAccount?.email) ?? "sef@naver.com", password: "\(String(describing: kuser?.id))") { fuser, error in
                                    if let error = error {
                                        print("FB : signup failed")
                                        print(error)
                                        // TODO: 이메일 받아오도록 승인받아야함 카카오에서 그리곤 수정필요
                                        Auth.auth().signIn(withEmail: (kuser?.kakaoAccount?.email) ?? "sef@naver.com", password: "\(String(describing: kuser?.id))", completion: nil)
                                    } else {
                                        print("FB : signup success")
                                    }
                                }
                            }
                        }
                        
//                        let VC = self.storyboard?.instantiateViewController(identifier: "MainViewController") as! MainViewController
//                        VC.modalPresentationStyle = .fullScreen
//                        self.present(VC, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    fileprivate var currentNonce: String?
    
    @available(iOS 13, *)
    @objc func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            randoms.forEach { random in
                if length == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
}

@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    print(error?.localizedDescription ?? "")
                    return
                }
                guard let user = authResult?.user else { return }
                let email = user.email ?? ""
                let loginName = "Apple"
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let db = Firestore.firestore()
                let userDocRef = db.collection("users").document(uid)

                // 해당 문서가 이미 존재하는지 확인
                userDocRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        // 문서가 이미 존재하는 경우
                        print("Document already exists, no need to setData.")
                    } else {
                        // 문서가 존재하지 않는 경우
                        // 데이터 추가
                        db.collection("users").document(uid).setData([
                            "email": email,
                            "platform": loginName
                        ]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("The user has signed up or is logged in.")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

extension LoginViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
