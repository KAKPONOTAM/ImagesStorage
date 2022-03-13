
import UIKit

class ImagesCollectionViewController: UIViewController {
    //MARK: - properties
    private var imagesArray = [AboutImages]()
    private let imagePicker = UIImagePickerController()
    
    private let imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let presentSwipeImagesViewControllerButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(presentSwipeImagesViewController), for: .touchUpInside)
        let configuration = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.forward", withConfiguration: configuration), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Сохраненные фото"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview()
        setupConstraints()
        setupCollectionView()
        imagePickerSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let saveImagesArray = UserSavedImagesManager.shared.receiveImages()
        imagesArray = saveImagesArray
        imagesCollectionView.reloadData()
    }
    
    //MARK: - methods
    private func addSubview() {
        view.addSubview(imagesCollectionView)
        view.addSubview(descriptionLabel)
        view.addSubview(presentSwipeImagesViewControllerButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imagesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            imagesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imagesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imagesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 2),
            descriptionLabel.bottomAnchor.constraint(equalTo: imagesCollectionView.topAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            presentSwipeImagesViewControllerButton.topAnchor.constraint(equalTo: descriptionLabel.topAnchor),
            presentSwipeImagesViewControllerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            presentSwipeImagesViewControllerButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 6),
            presentSwipeImagesViewControllerButton.bottomAnchor.constraint(equalTo: imagesCollectionView.topAnchor)
        ])
    }
    
    private func setupCollectionView() {
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        
        imagesCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
    }
    
    private func imagePickerSetup() {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.delegate = self
    }
    
    @objc private func presentSwipeImagesViewController() {
        let swipeImagesViewController = SwipeImagesViewController(index: 0)
        swipeImagesViewController.modalPresentationStyle = .fullScreen
        
        present(swipeImagesViewController, animated: true, completion: nil)
    }
}

extension ImagesCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imagesArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return  UICollectionViewCell() }
        
        switch indexPath.item {
        case 0:
            cell.firstCellConfigure()
            
        default:
            cell.configure(with: imagesArray[indexPath.item - 1])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.frame.width - 10) / 2
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            present(imagePicker, animated: true, completion: nil)
            
        default:
            let swipeImagesViewController = SwipeImagesViewController(index: indexPath.item - 1)
            swipeImagesViewController.modalPresentationStyle = .overFullScreen
            
            present(swipeImagesViewController, animated: true, completion: nil)
        }
    }
}
