import UIKit
import AVFoundation

class SwipeImagesViewController: UIViewController {
    //MARK: - properties
    private var index = 0
    private var isLiked = false
    private var userSavedData = [AboutImages]()
    private var scrollViewBottomAnchor: NSLayoutConstraint?
    private let textFieldPlaceholder = " description"
    private let imagePicker = UIImagePickerController()
    private let fullScreenImageView = FullScreenImageView.instanceFromNib()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        button.setImage(UIImage(systemName: "camera.fill", withConfiguration: configuration), for: .normal)
        return button
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageDescriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " description"
        textField.delegate = self
        textField.textAlignment = .center
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let frontImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let deleteImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .red
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        button.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
        button.setImage(UIImage(systemName: "trash", withConfiguration: configuration), for: .normal)
        return button
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .red
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        button.setImage(UIImage(systemName: "heart", withConfiguration: configuration), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(backToCollectionView), for: .touchUpInside)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    private let movingImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    
    init(index: Int) {
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubView()
        setupConstraints()
        let savedUserImages = UserSavedImagesManager.shared.receiveImages()
        userSavedData = savedUserImages
        loadFirstSavedData()
        createAttributedPlaceholder()
        registerForKeyboardNotifications()
        addImageFullScreenRecognizer()
        removeFullScreenImageViewRecognizer()
        addSwipeRecognizer()
        addHideKeyBoardRecognizer()
    }

    //MARK: - methods
    private func addSubView() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(containerView)
        
        containerView.addSubview(likeButton)
        containerView.addSubview(frontImageView)
        containerView.addSubview(imageDescriptionTextField)
        containerView.addSubview(cameraButton)
        containerView.addSubview(deleteImageButton)
        containerView.addSubview(dismissButton)
        
        frontImageView.addSubview(movingImageView)
    }
    
    private func setupConstraints() {
        scrollViewBottomAnchor = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollViewBottomAnchor ?? scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            frontImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 100),
            frontImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            frontImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            frontImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1 / 2)
        ])
        
        NSLayoutConstraint.activate([
            likeButton.centerYAnchor.constraint(equalTo: frontImageView.centerYAnchor, constant: view.frame.height / 3),
            likeButton.centerXAnchor.constraint(equalTo: frontImageView.centerXAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 100),
            likeButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            imageDescriptionTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            imageDescriptionTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            imageDescriptionTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            imageDescriptionTextField.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            deleteImageButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40),
            deleteImageButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            deleteImageButton.widthAnchor.constraint(equalToConstant: 50),
            deleteImageButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40),
            dismissButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            dismissButton.widthAnchor.constraint(equalToConstant: 50),
            dismissButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            cameraButton.topAnchor.constraint(equalTo: likeButton.topAnchor),
            cameraButton.leadingAnchor.constraint(equalTo: frontImageView.leadingAnchor),
            cameraButton.heightAnchor.constraint(equalToConstant: 100),
            cameraButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func changeLikeButtonImage() {
        if !userSavedData.isEmpty {
            isLiked = userSavedData[index].isLiked
            
            let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
            
            switch isLiked {
            case true:
                likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: imageConfiguration), for: .normal)
            case false:
                likeButton.setImage(UIImage(systemName: "heart", withConfiguration: imageConfiguration), for: .normal)
            }
        }
    }
    
    private func loadFirstSavedData() {
        switch userSavedData.isEmpty {
        case false:
            frontImageView.image = FileManager.loadImage(fileName: userSavedData[index].imageFileName)
            isLiked = userSavedData[index].isLiked
            imageDescriptionTextField.text = userSavedData[index].imageDescription
            
        case true:
            frontImageView.image = UIImage(named: "no photo")
            deleteImageButton.isEnabled = false
        }
    }
    
    @objc private func likeButtonTapped() {
        if !userSavedData.isEmpty {
            
            let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
            isLiked.toggle()
            
            switch isLiked {
            case true:
                likeButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: imageConfiguration), for: .normal)
            case false:
                likeButton.setImage(UIImage(systemName: "heart", withConfiguration: imageConfiguration), for: .normal)
            }
            
            userSavedData[index].isLiked = isLiked
            
            UserDefaults.standard.setValue(encodable: userSavedData, forKey: UserDefaultsKeys.imagesKey)
        }
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let descriptionTextFieldText = imageDescriptionTextField.text,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            scrollViewBottomAnchor?.isActive = false
            
            if !userSavedData.isEmpty {
                userSavedData[index].imageDescription = descriptionTextFieldText
                UserDefaults.standard.setValue(encodable: userSavedData, forKey: UserDefaultsKeys.imagesKey)
            }
            
            scrollViewBottomAnchor = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardScreenEndFrame.height - 15)
            scrollViewBottomAnchor?.isActive = true
            
        } else if notification.name == UIResponder.keyboardWillHideNotification {
            scrollViewBottomAnchor?.isActive = false
            
            scrollViewBottomAnchor = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            scrollViewBottomAnchor?.isActive = true
        }
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func createAttributedPlaceholder() {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray
        ]
        
        let attributedPlaceholder = NSAttributedString(string: textFieldPlaceholder, attributes: attributes)
        
        imageDescriptionTextField.attributedPlaceholder = attributedPlaceholder
    }
    
    private func cameraAccessAlert(title: String?, message: String?, okActionHandler: ((UIAlertAction) -> ())?, actionStyle: UIAlertAction.Style, preferredStyle: UIAlertController.Style, completion: (() -> ())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let okAction = UIAlertAction(title: "OK", style: actionStyle, handler: okActionHandler)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: completion)
    }
    
    @objc private func openCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker, animated: true, completion: nil)
            
        case .restricted:
            cameraAccessAlert(title: "Камера недоустпна", message: "пеерейдите в настройки и разрешите доступ", okActionHandler: nil, actionStyle: .default, preferredStyle: .alert, completion: nil)
            
        case .denied:
            cameraAccessAlert(title: "Камера недоустпна", message: "пеерейдите в настройки и разрешите доступ", okActionHandler: nil, actionStyle: .default, preferredStyle: .alert, completion: nil)
            
        case .notDetermined:
            cameraAccessAlert(title: "Камера недоустпна", message: "пеерейдите в настройки и разрешите доступ", okActionHandler: nil, actionStyle: .default, preferredStyle: .alert, completion: nil)
            
        @unknown default:
            break
        }
    }
    
    private func addImageFullScreenRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(presentFullScreenImageView))
        frontImageView.addGestureRecognizer(recognizer)
    }
    
    @objc private func presentFullScreenImageView() {
        if !userSavedData.isEmpty {
            fullScreenImageView.configure(with: userSavedData[index])
            containerView.addSubview(fullScreenImageView)
            imageDescriptionTextField.resignFirstResponder()
        }
    }
    
    @objc private func backToCollectionView() {
        dismiss(animated: true, completion: nil)
    }
    
    private func removeFullScreenImageViewRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(removeFullScreenImageView))
        fullScreenImageView.addGestureRecognizer(recognizer)
    }
    
    @objc private func removeFullScreenImageView() {
        fullScreenImageView.removeFromSuperview()
    }
    
    @objc private func deleteImage() {
        var savedImages = UserSavedImagesManager.shared.receiveImages()
        
        let alert = UIAlertController(title: "Вы действительно хотите удалить фотографию?", message: "данное действие удалит фотографию из вашей коллекции", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .destructive) { _ in
            savedImages.remove(at: self.index)
            self.userSavedData = savedImages
            UserDefaults.standard.setValue(encodable: self.userSavedData, forKey: UserDefaultsKeys.imagesKey)
            if self.index != 0 {
                self.index -= 1
            }
            
            switch savedImages.isEmpty {
            case false:
                self.frontImageView.image = FileManager.loadImage(fileName: self.userSavedData[self.index].imageFileName)
                self.isLiked = self.userSavedData[self.index].isLiked
                self.imageDescriptionTextField.text = self.userSavedData[self.index].imageDescription
                
            case true:
                self.deleteImageButton.isEnabled = false
                self.frontImageView.image = UIImage(named: "no photo")
                self.isLiked = false
                self.imageDescriptionTextField.text = ""
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func changeImageBySwipe(imagesArray: [AboutImages], swipeDirection: SwipeDirection) {
        if !imagesArray.isEmpty {
            switch swipeDirection {
            case.left:
                movingImageView.frame = frontImageView.bounds
                
                index -= 1
                
                if index <= 0 {
                    index = imagesArray.count - 1
                }
                
                UIView.animate(withDuration: 0.5) {
                    self.movingImageView.frame.origin.x = -self.view.frame.width - self.movingImageView.frame.width
                    self.frontImageView.image = FileManager.loadImage(fileName: imagesArray[self.index].imageFileName)
                    self.imageDescriptionTextField.text = imagesArray[self.index].imageDescription
                    self.changeLikeButtonImage()
                    
                } completion: { _ in
                    self.movingImageView.image = self.frontImageView.image
                }
                
            case .right:
                movingImageView.frame = frontImageView.bounds
                
                index += 1
                if index >= imagesArray.count - 1  {
                    index = 0
                }
                
                UIView.animate(withDuration: 0.5) {
                    self.movingImageView.frame.origin.x = self.view.frame.width + self.movingImageView.frame.width
                    self.frontImageView.image = FileManager.loadImage(fileName: imagesArray[self.index].imageFileName)
                    self.imageDescriptionTextField.text = imagesArray[self.index].imageDescription
                    self.changeLikeButtonImage()
                    
                } completion: { _ in
                    self.movingImageView.image = self.frontImageView.image
                }
            }
        }
    }
    
    @objc private func imagesMovementRecognizer(recognizer: UISwipeGestureRecognizer) {
        if !userSavedData.isEmpty {
            switch recognizer.direction {
            case .left:
                changeImageBySwipe(imagesArray: userSavedData, swipeDirection: .left)
                
            case.right:
                changeImageBySwipe(imagesArray: userSavedData, swipeDirection: .right)
                
            default:
                print("something goes wrong")
            }
        }
    }
    
    
    private func addSwipeRecognizer() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(imagesMovementRecognizer(recognizer:)))
        leftSwipe.direction = .left
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(imagesMovementRecognizer(recognizer:)))
        rightSwipe.direction = .right
        
        frontImageView.addGestureRecognizer(leftSwipe)
        frontImageView.addGestureRecognizer(rightSwipe)
    }
    
    private func addHideKeyBoardRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardRecognizer))
        containerView.addGestureRecognizer(recognizer)
    }
    
    @objc private func hideKeyboardRecognizer() {
        imageDescriptionTextField.resignFirstResponder()
    }
}
