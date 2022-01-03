//
//  CameraVC.swift
//  PhotoBox
//
//  Created by Sana Alshahrani on 22/04/1443 AH.
//


    import UIKit
    import FirebaseAuth
    import AVFoundation // كاميرا - تسجيل صوت - فيديو كل شي تقريبا يتعلق بالكاميرا
    import Photos
    import FirebaseFirestore
    import FirebaseStorage

    class CameraVC: UIViewController {
        
        private var sessionForAV: AVCaptureSession? // اوبجكت اوبشنال من الاي في كابتشر سيشن
        private let photoOutput = AVCapturePhotoOutput() // نعرض عليها الصور
        private let videoPreviewLayer = AVCaptureVideoPreviewLayer() // اول مانفتح الكاميرا
        private var isFlashOn = false
        private let storage = Storage.storage() // ريفيرنس للستورج فالداتا بيس
        
        private let recordButton: UIButton  = { // زر التقاط الصورة
            let btn = UIButton(type: .system)
            btn.setImage(UIImage(systemName: "camera")?.withTintColor(UIColor.cyan, renderingMode: .alwaysOriginal), for: .normal)
            btn.layer.cornerRadius = 15
            btn.backgroundColor = .clear
            btn.layer.borderColor = UIColor.cyan.cgColor
            btn.layer.borderWidth = 2
            return btn
        }()
        
        let previewContainer: UIView = { // الصورة بعد الالتقاط
            let pC = UIView()
            
           
            return pC
        }()
        let cancelPhotoButton: UIButton = { // نكنسل الصورة
            let btn = UIButton(type: .system)

            btn.setupButton(using: "xmark")
            
            return btn
        }()
        let savePhotoButton: UIButton = { // نخزن الصورة
            let btn = UIButton(type: .system)

            btn.setupButton(using: "square.and.arrow.down")
            
            return btn
        }()
        
        let flashButton: UIButton = {
            let btn = UIButton(type: .system)
            btn.setupButton(using: "bolt.slash")
            return btn
        }()
        
        let userProcessedImage: UIImageView = { // عشان نعرض الصورة بعد الالتقاط
            let img = UIImageView()
            img.contentMode = .scaleAspectFit
            return img
        }()
        
        let profileImage: UIImageView = {
            let img = UIImageView()
            img.contentMode = .scaleAspectFill
            img.layer.cornerRadius = 60/2
            img.layer.borderColor = UIColor.init(named: "witeColor")!.cgColor
            img.layer.borderWidth = 2
            img.isHidden  = true 
            img.clipsToBounds = true
            return img
        }()
        
        
     
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = UIColor.init(named: "BlackColor")!
            view.layer.addSublayer(videoPreviewLayer)
           
            navigationItem.title = "SnapTest"
            
            setupRecordButton()
            
            hasUserGavePermissionForCamera()
            setupCameraButtons()
            
            setupProfileImage()
            
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            Auth.auth().addStateDidChangeListener { (auth, user) in
                   if user != nil {
                      
                   }else{
                       self.showWelcomeScreen()
                   }
            }
        }
        
        private func setupProfileImage() {
            profileImage.isUserInteractionEnabled = true
//            profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileBarImageTapped)))
            profileImage.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(profileImage)
            
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
            profileImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
            profileImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
        }

        private func setupCameraButtons() {
            
            flashButton.addTarget(self, action: #selector(flashButtonTapped), for: .touchUpInside)
            
            let stackView = UIStackView(arrangedSubviews:  [flashButton])
            stackView.distribution = .fillEqually
            stackView.spacing = 15
            stackView.axis = .vertical
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.backgroundColor = .clear
            stackView.layer.cornerRadius = 10
            stackView.clipsToBounds = true
            stackView.layer.borderWidth = 2
            stackView.layer.borderColor = UIColor.cyan.cgColor
            
            view.addSubview(stackView)
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            stackView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            stackView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        }
        
        private func setupRecordButton(){
            
            recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
            recordButton.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(recordButton)
            recordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            recordButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
            recordButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        }
        private func showWelcomeScreen() {
            let vc = UINavigationController(rootViewController: StartVC())
//            vc.modalTransitionStyle = .flipHorizontal
//            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
        private func hasUserGavePermissionForCamera() {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                setupCapturingProcess()
            case .denied:
                let alert = UIAlertController(title: "Oops", message: "Please allow the app to access your camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(alert, animated: true)
                
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { authorized in
                    if authorized {
                        DispatchQueue.main.async {
                            self.setupCapturingProcess()
                        }
                    }
                }
                
            case .restricted:
                
                let alert = UIAlertController(title: "Oops", message: "To allow this app to function probably, please consult your parents to give permission.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(alert, animated: true)
                
            default:
                break
            }
        }
        
        private func setupCapturingProcess() {
            let sessionForAV = AVCaptureSession()
            guard let userDevice = AVCaptureDevice.default(for: .video) else {return}
            
            do {
                let inputDevice = try AVCaptureDeviceInput(device: userDevice)
                
                if sessionForAV.canAddInput(inputDevice) {
                    sessionForAV.addInput(inputDevice)
                }
                
                
                
            }catch let err {print("error getting input from device \(err.localizedDescription)")}
            if sessionForAV.canAddOutput(photoOutput) {
                sessionForAV.addOutput(photoOutput)
            }
            
            
            videoPreviewLayer.videoGravity = .resizeAspectFill
            
            videoPreviewLayer.session = sessionForAV
            videoPreviewLayer.frame = CGRect(x: 0, y:0, width: view.frame.width , height: view.frame.height)
      
          
            sessionForAV.startRunning()
            self.sessionForAV = sessionForAV
        }
        
        private func toggleFlash(on: Bool ) {
            guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
            
            do {
                try device.lockForConfiguration()
                
                device.torchMode = on ? .on : .off
                
                if on {
                    try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Error: \(error)")
            }
        }
        
        
        private func setupPreviewButtons() {
            
            
            savePhotoButton.addTarget(self, action: #selector(savePreviewPhotoToLibrary), for: .touchUpInside)
            cancelPhotoButton.addTarget(self, action: #selector(cancelPreviewPhoto), for: .touchUpInside)
            
            previewContainer.addSubview(userProcessedImage)
            
            
            let stackView = UIStackView(arrangedSubviews:  [cancelPhotoButton, savePhotoButton])
            
            stackView.distribution = .fillEqually
            stackView.spacing = 15
            stackView.axis = .vertical
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.backgroundColor = .clear
            stackView.layer.cornerRadius = 10
            stackView.clipsToBounds = true
            stackView.layer.borderWidth = 2
            stackView.layer.borderColor =  UIColor.cyan.cgColor
            
            previewContainer.addSubview(stackView)
            
            stackView.topAnchor.constraint(equalTo: previewContainer.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            stackView.trailingAnchor.constraint(equalTo: previewContainer.trailingAnchor, constant: -10).isActive = true
            stackView.widthAnchor.constraint(equalToConstant: 40).isActive = true
          
            stackView.heightAnchor.constraint(equalToConstant: 120).isActive = true
            
        }
        @objc private func cancelPreviewPhoto() {
            DispatchQueue.main.async {
                self.userProcessedImage.removeFromSuperview()
                self.previewContainer.removeFromSuperview()
            }
        }
        @objc private func savePreviewPhotoToLibrary() {
            guard let previewPhoto = userProcessedImage.image else {return}
            
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { authorizationStatus in
                
                if authorizationStatus == .authorized {
                    do {
                        try PHPhotoLibrary.shared().performChangesAndWait {
                            PHAssetChangeRequest.creationRequestForAsset(from: previewPhoto)
                            print("User saved photo to his library")
                            
                            
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Awesome!", message: "you photo has been saved", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                                    self.cancelPreviewPhoto()
                                }))
                                
                                self.present(alert, animated: true)
                            }
                            
                        }
                    }catch let err {
                        print("we couldn't save the photo with error: \(err)")
                }
                }else{
                    let alert = UIAlertController(title: "Oops!", message: "Please check if you allowed the app to access your library", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                    self.present(alert, animated: true)
                }
                
            }
        }
        @objc private func recordButtonTapped() {
            photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            
        }
        
        @objc private func flashButtonTapped() {
            print(isFlashOn)
            isFlashOn = !isFlashOn
            toggleFlash(on: isFlashOn)
            flashButton.setupButton(using: isFlashOn ? "bolt" : "bolt.slash")
            
        }
        
//        @objc private func profileBarImageTapped() {
//            navigationController?.pushViewController(ProfileVC(), animated: true)
//        }
    }

    extension CameraVC: AVCapturePhotoCaptureDelegate {
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            
            guard let photo = photo.fileDataRepresentation() else {return}
            
            let processedImage = UIImage(data: photo)
            
            previewContainer.frame   =  view.frame
            userProcessedImage.image =  processedImage
            userProcessedImage.frame =  previewContainer.frame
            setupPreviewButtons()
            
            view.addSubview(previewContainer)
           //
           let vc = ImageInformationVC()
            vc.image = processedImage
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)

            DispatchQueue.main.async {
                    self.userProcessedImage.removeFromSuperview()
                    self.previewContainer.removeFromSuperview()
                self.userProcessedImage.removeFromSuperview()
                self.recordButton.removeFromSuperview()
                self.profileImage.removeFromSuperview()
                self.videoPreviewLayer.removeFromSuperlayer()
              
                }
            
        }
    }

