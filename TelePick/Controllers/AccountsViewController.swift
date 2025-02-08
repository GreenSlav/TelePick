import UIKit

class AccountsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Аккаунты"
        
        setupUI()
    }
    
    func setupUI() {
        // Кнопка добавления аккаунта
        let addAccountButton = UIButton(type: .system)
        addAccountButton.setTitle("Добавить аккаунт", for: .normal)
        addAccountButton.addTarget(self, action: #selector(addAccountTapped), for: .touchUpInside)
        
        addAccountButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addAccountButton)
        
        NSLayoutConstraint.activate([
            addAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addAccountButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func addAccountTapped() {
        let addAccountVC = AddAccountViewController()
        
        // Настраиваем модальное отображение
        addAccountVC.modalPresentationStyle = .formSheet   // Экран на весь экран
        addAccountVC.modalTransitionStyle = .coverVertical  // Анимация "снизу вверх"
        
        present(addAccountVC, animated: true, completion: nil)
    }
}
