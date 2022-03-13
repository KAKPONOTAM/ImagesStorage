import UIKit

class AuthorizationViewController: UIViewController {
    //MARK: - properties
    private var isLiked = false
    
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.backgroundColor = .black
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(presentLoginViewController), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.setTitle("Create account", for: .normal)
        button.addTarget(self, action: #selector(presentCreateAccountViewController), for: .touchUpInside)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let animationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let animationImages: [UIImage] = {
        var imagesArray = [UIImage]()
        guard let firstImage = UIImage(named: "first"),
              let secondImage = UIImage(named: "second"),
              let thirdImage = UIImage(named: "third"),
              let fourthImage = UIImage(named: "fourth") else { return [UIImage]() }
        
        imagesArray += [firstImage, secondImage, thirdImage, fourthImage]
        
        return imagesArray
    }()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubView()
        setupConstraints()
        animateImages()
    }
    
    //MARK: - methods
    private func addSubView() {
        view.addSubview(createAccountButton)
        view.addSubview(signInButton)
        view.addSubview(animationImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            createAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            createAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            createAccountButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            createAccountButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: createAccountButton.bottomAnchor, constant: 10),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            animationImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            animationImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            animationImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            animationImageView.bottomAnchor.constraint(equalTo: createAccountButton.topAnchor, constant: -20)
        ])
    }
    
    @objc private func presentLoginViewController() {
        let loginViewController = LoginViewViewController()
        loginViewController.modalPresentationStyle = .overFullScreen
        
        present(loginViewController, animated: true, completion: nil)
    }
    
    @objc private func presentCreateAccountViewController() {
        let createAccountViewController = CreateAccountViewController()
        createAccountViewController.modalPresentationStyle = .overFullScreen
        
        present(createAccountViewController, animated: true, completion: nil)
    }
    
    private func animateImages() {
        animationImageView.animationDuration = 18
        animationImageView.animationImages = animationImages
        animationImageView.startAnimating()
        UIView.animate(withDuration: 2, delay: 2, options: [.curveEaseOut, .repeat, .autoreverse]) {
          
        }
    }
}

