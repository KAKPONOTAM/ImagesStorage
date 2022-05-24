import UIKit

class LoginViewViewController: UIViewController {
    //MARK: - properties
    private var userPassword: String?
    private let textFieldPlaceholder = " password"
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Enter password"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(checkPasswordValidity), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Login", for: .normal)
        return button
    }()
    
    private let visualView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: effect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        return button
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .black
        textField.layer.cornerRadius = 5
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        textField.layer.borderWidth = 1
        return textField
    }()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        addSubview()
        setupConstraints()
        createAttributedPlaceholder()
        
        let userSavedPassword = UserPasswordManager.shared.receiveUserPassword()
        userPassword = userSavedPassword
    }
    
    //MARK: - methods
    private func addSubview() {
        view.addSubview(visualView)
        
        visualView.contentView.addSubview(dismissButton)
        visualView.contentView.addSubview(passwordTextField)
        visualView.contentView.addSubview(descriptionLabel)
        visualView.contentView.addSubview(loginButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            visualView.topAnchor.constraint(equalTo: view.topAnchor),
            visualView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            visualView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            visualView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dismissButton.leadingAnchor.constraint(equalTo: visualView.leadingAnchor, constant: 10),
            dismissButton.widthAnchor.constraint(equalTo: visualView.widthAnchor, multiplier: 1 / 6),
            dismissButton.heightAnchor.constraint(equalToConstant: 50),
            dismissButton.topAnchor.constraint(equalTo: visualView.topAnchor, constant: 50)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: visualView.centerXAnchor),
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: visualView.leadingAnchor, constant: 10),
            passwordTextField.trailingAnchor.constraint(equalTo: visualView.trailingAnchor, constant: -10),
            passwordTextField.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: visualView.topAnchor, constant: 50),
            descriptionLabel.leadingAnchor.constraint(equalTo: visualView.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: visualView.trailingAnchor, constant: -10),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            loginButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalTo: passwordTextField.heightAnchor)
        ])
    }
    
    @objc private func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func checkPasswordValidity() {
        guard let passwordTextFieldText = passwordTextField.text,
              let userPassword = userPassword else { return }
        
        if passwordTextFieldText == userPassword {
            let imagesCollectionViewController = ImagesCollectionViewController()
            imagesCollectionViewController.modalPresentationStyle = .fullScreen
            present(imagesCollectionViewController, animated: true, completion: nil)
            
        } else {
            passwordTextField.layer.borderColor = UIColor.red.cgColor
            passwordTextField.text = ""
            passwordTextField.placeholder = " не верный пароль"
        }
    }
    
    private func createAttributedPlaceholder() {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray
        ]
        
        let attributedPlaceholder = NSAttributedString(string: textFieldPlaceholder, attributes: attributes)
        
        passwordTextField.attributedPlaceholder = attributedPlaceholder
    }
}
