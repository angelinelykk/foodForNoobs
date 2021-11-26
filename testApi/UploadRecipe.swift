//
//  UploadRecipe.swift
//  testApi
//
//  Created by Max Wilcoxson on 11/26/21.
//

import Foundation
import UIKit
import AVFoundation

class AddRecipeVC: UIViewController {
    
    var has_image = false
    
    var num_ingredients = 1
    
    private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView : UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private let nameTextField : AuthTextField = {
        let text = AuthTextField(title: "Recipe Name")
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private let addImageLabel : UILabel = {
        let text = UILabel()
        text.textColor = .black
        text.text = "Image"
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private let findImageButton : LoadingButton = {
        let button = LoadingButton()
        button.layer.backgroundColor = UIColor.primary.cgColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.titleLabel?.textAlignment = .center
        button.isUserInteractionEnabled = true
        button.setTitle("Photo Library", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let takeImageButton : LoadingButton = {
        let button = LoadingButton()
        button.layer.backgroundColor = UIColor.primary.cgColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.titleLabel?.textAlignment = .center
        button.isUserInteractionEnabled = true
        button.setTitle("Take Picture", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let imageView : UIImageView = {
        let view = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 150)
        view.image = UIImage(systemName: "photo",withConfiguration: config)
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let eventDescription : LabelledTextView = {
        let view = LabelledTextView(title: "Description", lines: 4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let addEventButton : LoadingButton = {
        let button = LoadingButton()
        button.layer.backgroundColor = UIColor.primary.cgColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.titleLabel?.textAlignment = .center
        button.isUserInteractionEnabled = true
        button.setTitle("Create Event!", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        private let ingredients : [UITableView] = {
            return 0..<self.num_ingredients.map
            let ingredients = UITableView()
            ingredients.translatesAutoresizingMaskIntoConstraints = false
            return ingredients
        }()
        
        
        navigationItem.title = "Add Event"
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(nameTextField)
        contentView.addSubview(findImageButton)
        contentView.addSubview(takeImageButton)
        contentView.addSubview(imageView)
        contentView.addSubview(eventDescription)
        contentView.addSubview(ingredients)
        contentView.addSubview(addEventButton)
        eventDescription.textField.delegate = self
        findImageButton.layer.cornerRadius = 15
        takeImageButton.layer.cornerRadius = 15
        addEventButton.layer.cornerRadius = 15
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -32),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            nameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nameTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor,constant: -32),
            findImageButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            findImageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            findImageButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5,constant: -24),
            takeImageButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            takeImageButton.leadingAnchor.constraint(equalTo: findImageButton.trailingAnchor, constant: 16),
            takeImageButton.widthAnchor.constraint(equalTo: findImageButton.widthAnchor),
            imageView.topAnchor.constraint(equalTo: findImageButton.bottomAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: nameTextField.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.4),
            ingredients.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 16),
            ingredients.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            ingredients.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32),
            ingredients.heightAnchor.constraint(equalTo: contentView.heightAnchor,multiplier: 0.4),
            eventDescription.topAnchor.constraint(equalTo: ingredients.bottomAnchor, constant: 16),
            eventDescription.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            eventDescription.widthAnchor.constraint(equalTo: imageView.widthAnchor),         addEventButton.topAnchor.constraint(equalTo: eventDescription.bottomAnchor),
            addEventButton.centerXAnchor.constraint(equalTo: eventDescription.centerXAnchor),
            addEventButton.widthAnchor.constraint(equalTo: eventDescription.widthAnchor),
            addEventButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        takeImageButton.addTarget(self, action: #selector(didTapTakeImage(_:)), for: .touchUpInside)
        findImageButton.addTarget(self, action: #selector(didTapFindImage(_:)), for: .touchUpInside)
        addEventButton.addTarget(self,action: #selector(didTapCreateEvent(_:)),for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc func didTapTakeImage(_ sender: UIButton) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            presentCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: {
                granted in
                if granted {
                    self.presentCamera()
                }
            })
        case .restricted:
            return
        case .denied:
            return
        }
    }
    
    @objc func didTapCreateEvent(_ sender: UIButton) {
        //Nothing
        

    }
    func presentCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            picker.sourceType = .camera
            present(picker, animated: true)
        }
    }
    @objc func didTapFindImage(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    
}
    
}
extension AddRecipeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        imageView.image = image
        self.has_image = true
        // let imageName = UUID().uuidString
        //let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imageName)
        //if let data = image.jpegData(compressionQuality: 0.8) {
         //   try? data.write(to: path)
        //}
        dismiss(animated: true, completion: nil)
    }
}

extension AddRecipeVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 140 {
                textView.text = String(textView.text.prefix(140))
        }
    }
}



