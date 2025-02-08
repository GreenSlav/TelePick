import UIKit

class AddAccountViewController: UIViewController {
    let phoneTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Добавить аккаунт"
        
        setupUI()
    }

    func setupUI() {
        phoneTextField.placeholder = "Введите номер телефона"
        phoneTextField.borderStyle = .roundedRect
        phoneTextField.keyboardType = .phonePad
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Авторизоваться", for: .normal)
        submitButton.addTarget(self, action: #selector(authorizeTapped), for: .touchUpInside)
        
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(phoneTextField)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            phoneTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            phoneTextField.widthAnchor.constraint(equalToConstant: 250),
            
            submitButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func authorizeTapped() {
        guard let phoneNumber = phoneTextField.text, !phoneNumber.isEmpty else {
            print("Введите номер телефона")
            return
        }
        
        // Здесь будет вызов Python-скрипта для авторизации через Telethon
        print("Авторизация для номера: \(phoneNumber)")
    }
}
