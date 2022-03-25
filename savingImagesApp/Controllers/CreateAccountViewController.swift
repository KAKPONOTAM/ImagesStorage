import UIKit
import SwiftyKeychainKit

class CreateAccountViewController: UIViewController {
    //MARK: - properties
    private var scrollViewBottomAnchor: NSLayoutConstraint?
    private let textFieldPlaceholder = " password"
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentInsetAdjustmentBehavior = .never
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .clear
        return scroll
    }()
    
    private let visualView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: effect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 5
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        textField.layer.borderWidth = 1
        return textField
    }()
    
    private let repeatPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 5
        textField.autocorrectionType = .no
        textField.layer.borderWidth = 1
        return textField
    }()
    
    private let savePasswordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Save", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(checkAndSavePassword), for: .touchUpInside)
        return button
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        return button
    }()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        setupConstraints()
        setupTextFields()
        createAttributedPlaceholder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        registerForKeyboardNotifications()
    }
    
    //MARK: - methods
    private func addSubview() {
        view.addSubview(scrollView)
        scrollView.addSubview(visualView)
        
        visualView.contentView.addSubview(passwordTextField)
        visualView.contentView.addSubview(repeatPasswordTextField)
        visualView.contentView.addSubview(savePasswordButton)
        visualView.contentView.addSubview(dismissButton)
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
            visualView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            visualView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            visualView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            visualView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            visualView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            visualView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: visualView.centerXAnchor),
            passwordTextField.centerYAnchor.constraint(equalTo: visualView.centerYAnchor, constant: -50),
            passwordTextField.leadingAnchor.constraint(equalTo: visualView.leadingAnchor, constant: 10),
            passwordTextField.trailingAnchor.constraint(equalTo: visualView.trailingAnchor, constant: -10),
            passwordTextField.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            repeatPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            repeatPasswordTextField.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            repeatPasswordTextField.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            repeatPasswordTextField.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            savePasswordButton.bottomAnchor.constraint(equalTo: visualView.bottomAnchor, constant: -30),
            savePasswordButton.leadingAnchor.constraint(equalTo: visualView.leadingAnchor, constant: 30),
            savePasswordButton.trailingAnchor.constraint(equalTo: visualView.trailingAnchor, constant: -30),
            savePasswordButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            dismissButton.leadingAnchor.constraint(equalTo: visualView.leadingAnchor, constant: 10),
            dismissButton.widthAnchor.constraint(equalTo: visualView.widthAnchor, multiplier: 1 / 6),
            dismissButton.heightAnchor.constraint(equalToConstant: 50),
            dismissButton.topAnchor.constraint(equalTo: visualView.topAnchor, constant: 50)
        ])
    }
    
    private func setupTextFields() {
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
    }
    
    @objc private func checkAndSavePassword() {
        guard let passwordTextFieldText = passwordTextField.text,
              let repeatPasswordTextFieldText = repeatPasswordTextField.text else { return }
        
        if passwordTextFieldText.isEmpty || repeatPasswordTextFieldText.isEmpty {
            passwordTextField.layer.borderColor = UIColor.red.cgColor
            passwordTextField.placeholder = " введите пароль"
            
            repeatPasswordTextField.layer.borderColor = UIColor.red.cgColor
            repeatPasswordTextField.placeholder = " введите пароль"
            
            
        } else if passwordTextFieldText != repeatPasswordTextFieldText {
            passwordTextField.text = nil
            passwordTextField.layer.borderColor = UIColor.red.cgColor
            passwordTextField.placeholder = " пароли не совпадают"
            
            repeatPasswordTextField.text = nil
            repeatPasswordTextField.layer.borderColor = UIColor.red.cgColor
            repeatPasswordTextField.placeholder = " пароли не совпадают"
            
        } else if passwordTextFieldText.count < 4 && repeatPasswordTextFieldText.count < 4 {
            passwordTextField.text = nil
            passwordTextField.layer.borderColor = UIColor.red.cgColor
            passwordTextField.placeholder = " пароль должен содержать минимум 4 символа"
            
            repeatPasswordTextField.text = nil
            repeatPasswordTextField.layer.borderColor = UIColor.red.cgColor
            repeatPasswordTextField.placeholder = " пароль должен содержать минимум 4 символа"
            
        } else {
            UserPasswordManager.shared.savePassword(userPassword: passwordTextFieldText)
            
            let alert = UIAlertController(title: "Пароль успешно сохарнен", message: "перейдите в раздел логина и авторизируйтесь", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            scrollViewBottomAnchor?.isActive = false
            
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
        
        passwordTextField.attributedPlaceholder = attributedPlaceholder
        repeatPasswordTextField.attributedPlaceholder = attributedPlaceholder
    }
}

extension CreateAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
