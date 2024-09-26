//
//  ViewController.swift
//  MemApp
//
//  Created by Кирилл Бахаровский on 9/27/24.
//

import UIKit

class ViewController: UIViewController {
    
    let url: String? = "https://api.imgflip.com/caption_image"
    var idMeme: String = ""
    var data: Automeme = Automeme(template_id: "", username: "baharovsky", password: "kismuv-jUhtek-vapzy1", text0: "test")
    
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter the name of the meme"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24)
        label.numberOfLines = 2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(questionTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24)
        button.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: config), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(questionTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let questionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let memImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default-image")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setTitle("👍", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 64)
        button.addTarget(self, action: #selector(likeDislikeTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    private lazy var dislikeButton: UIButton = {
        let button = UIButton()
        button.setTitle("👎", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 64)
        button.addTarget(self, action: #selector(likeDislikeTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setConstraints()
    }
    
    @objc func questionTapped(){
        AlertManager.shared.simpleAlertWithTF(title: "Add meme", message: "Enter the name of the meme", titleSaveButton: "Get a prediction", viewController: self) { [weak self] text in
            guard let self = self else { return }
            
            self.questionLabel.text = text
            self.data.text0 = text
            getImage()
        }
    }
    
    @objc func likeDislikeTapped(_ sender: UIButton) {
        guard let memImage = memImage.image, memImage != UIImage(named: "default-image") else { AlertManager.shared.showMessagePrompt("Введите название мема", viewController: self); return }
        if sender.currentTitle == "👍"{
            AlertManager.shared.showMessagePrompt("Ответ принят", viewController: self)
        } else {
            getImage()
        }
    }
    
    private func getImage() {
        NetworkManager.shared.getMemes { memes in
            guard let memes = memes else {
                print("Ошибка в получении данных")
                return
            }
            
            self.data.template_id = memes[Int.random(in: 0..<memes.count)].id
            
            guard let url = self.url else { return }
            print(self.data)
            NetworkManager.shared.getImageOfUrl(url: url, json: self.data) { imageData in
                DispatchQueue.main.async {
                    self.memImage.image = UIImage(data: imageData)
                }
            }
        }
    }
}

extension ViewController {
    private func setupViews() {
        view.addSubview(questionStackView)
        questionStackView.addArrangedSubview(questionLabel)
        questionStackView.addArrangedSubview(searchButton)
        view.addSubview(memImage)
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(likeButton)
        buttonsStackView.addArrangedSubview(dislikeButton)
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            questionStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            questionStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            questionStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            questionStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            questionLabel.widthAnchor.constraint(equalTo: questionStackView.widthAnchor, multiplier: 0.9),
            searchButton.widthAnchor.constraint(equalTo: questionStackView.widthAnchor, multiplier: 0.1)
        ])
        
        NSLayoutConstraint.activate([
            memImage.topAnchor.constraint(equalTo: questionStackView.bottomAnchor, constant: 10),
            memImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            memImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            memImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            memImage.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
        
    }
}
