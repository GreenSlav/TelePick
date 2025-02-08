import UIKit

class AddAccountViewController: UIViewController {
    
    let phoneTextField = UITextField()
    let codeTextField = UITextField()
    let passwordTextField = UITextField()
    let submitButton = UIButton(type: .system)
    let closeButton = UIButton(type: .system)
    
    var currentStep: AuthStep = .phone

    enum AuthStep {
        case phone, code, password
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Добавить аккаунт"
        
        setupUI()
        setupGestureToDismissKeyboard()
    }

    func setupUI() {
        setupTextField(phoneTextField, placeholder: "Введите номер телефона", keyboardType: .phonePad)
        setupTextField(codeTextField, placeholder: "Введите код из Telegram", keyboardType: .numberPad)
        setupTextField(passwordTextField, placeholder: "Введите пароль", isSecure: true)
        
        submitButton.setTitle("Далее", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = UIColor(red: 51/255, green: 107/255, blue: 78/255, alpha: 1)
        submitButton.layer.cornerRadius = 10
        submitButton.addTarget(self, action: #selector(nextStepTapped), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        closeButton.setTitle("✕", for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(phoneTextField)
        view.addSubview(codeTextField)
        view.addSubview(passwordTextField)
        view.addSubview(submitButton)
        view.addSubview(closeButton)
        
        setupConstraints()
        updateUI(for: .phone)
    }
    
    func setupTextField(_ textField: UITextField, placeholder: String, keyboardType: UIKeyboardType = .default, isSecure: Bool = false) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = isSecure
        textField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        textField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            
            phoneTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            phoneTextField.widthAnchor.constraint(equalToConstant: 280),
            phoneTextField.heightAnchor.constraint(equalToConstant: 44),
            
            codeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            codeTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            codeTextField.widthAnchor.constraint(equalToConstant: 280),
            codeTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            passwordTextField.widthAnchor.constraint(equalToConstant: 280),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            submitButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 30),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 200),
            submitButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc func nextStepTapped() {
        switch currentStep {
        case .phone:
            guard let phoneNumber = phoneTextField.text, !phoneNumber.isEmpty else {
                print("Введите номер телефона")
                return
            }
            transition(to: .code)
            
        case .code:
            guard let code = codeTextField.text, !code.isEmpty else {
                print("Введите код")
                return
            }
            transition(to: .password)
            
        case .password:
            guard let password = passwordTextField.text, !password.isEmpty else {
                print("Введите пароль")
                return
            }
            print("Авторизация завершена для аккаунта с паролем: \(password)")
        }
    }
    
    @objc func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func transition(to nextStep: AuthStep) {
        let currentView: UIView
        let nextView: UIView

        switch currentStep {
        case .phone:
            currentView = phoneTextField
        case .code:
            currentView = codeTextField
        case .password:
            currentView = passwordTextField
        }

        switch nextStep {
        case .phone:
            nextView = phoneTextField
        case .code:
            nextView = codeTextField
        case .password:
            nextView = passwordTextField
        }

        UIView.animate(withDuration: 0.3, animations: {
            currentView.alpha = 0
            self.submitButton.alpha = 0
            currentView.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            self.submitButton.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
        }, completion: { _ in
            self.updateUI(for: nextStep)
            currentView.transform = .identity
            self.submitButton.transform = .identity
            nextView.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
            nextView.alpha = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                nextView.transform = .identity
                nextView.alpha = 1
                self.submitButton.alpha = 1
            }, completion: { _ in
                nextView.becomeFirstResponder()
            })
        })

        currentStep = nextStep
    }

    func updateUI(for step: AuthStep) {
        phoneTextField.isHidden = step != .phone
        codeTextField.isHidden = step != .code
        passwordTextField.isHidden = step != .password
        
        switch step {
        case .phone:
            submitButton.setTitle("Подтвердить номер", for: .normal)
        case .code:
            submitButton.setTitle("Подтвердить код", for: .normal)
        case .password:
            submitButton.setTitle("Войти", for: .normal)
        }
    }
    
    func setupGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
