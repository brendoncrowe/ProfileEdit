//
//  ProfileEditController.swift
//  ProfileEdit
//
//  Created by Brendon Crowe on 3/1/23.
//

import UIKit
import PhotosUI
import AVFoundation

protocol ProfileEditControllerDelegate: AnyObject {
    func ProfileEditController(_ controller: ProfileEditController, didSaveUserInfo user: PhoneUser)
}

class ProfileEditController: UIViewController {
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var profileImageBackground: UIView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userJobTextField: UITextField!
    @IBOutlet weak var userPhoneTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var user: PhoneUser?
    var userImage: UIImage?
    weak var delegate: ProfileEditControllerDelegate?
    var saveButtonIsEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTextFieldDelegates()
        configureImageButton()
        saveButton.isEnabled = saveButtonIsEnabled
        profileImageButton.addTarget(self, action: #selector(changeProfileImage), for: .touchUpInside)
        if user != nil {
            userNameTextField.text = user?.name
            userJobTextField.text = user?.job
            userPhoneTextField.text = user?.phoneNumber
            userEmailTextField.text = user?.email
            userImage = UIImage(data: user!.photo)
            profileImageButton.setImage(UIImage(data: user!.photo), for: .normal)
        }
    }
    
    private func configTextFieldDelegates() {
        userNameTextField.delegate = self
        userJobTextField.delegate = self
        userPhoneTextField.delegate = self
        userEmailTextField.delegate = self
    }
    
    @objc func changeProfileImage() {
        var phpPickerConfig = PHPickerConfiguration()
        phpPickerConfig.filter = .images
        phpPickerConfig.selectionLimit = 1
        let controller = PHPickerViewController(configuration: phpPickerConfig)
        if let sheet = controller.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        controller.delegate = self
        present(controller, animated: true)
    }
    
    private func configureImageButton() {
        profileImageBackground.layer.cornerRadius = 24
    }
    
    private func saveUserInfo() {
        guard let image = userImage else {
            print("image is nil")
            return
        }
        let name = userNameTextField.text ?? "No name"
        let job = userJobTextField.text ?? "No job available"
        let phoneNumber = userPhoneTextField.text ?? "No phone #"
        let email = userEmailTextField.text ?? "No email"
        
        // the below code is formatting the image into data needed for persistence
        let size = UIScreen.main.bounds.size
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = image.resizeImage(to: rect.size.width, height: rect.size.height)
        guard let imageData = resizedImage.jpegData(compressionQuality: 1.0) else {
            print("could not create image data")
            return
        }
        let photo = imageData
        user = PhoneUser(name: name, photo: photo, job: job, phoneNumber: phoneNumber, email: email)
        PhoneUser.saveUserInfo(user!)        
        delegate?.ProfileEditController(self, didSaveUserInfo: user!)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        presentSaveAlert()
        saveUserInfo()
    }
    
    private func presentSaveAlert() {
        let alertController = UIAlertController(title: "Saved", message: "Your info has been saved", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

extension ProfileEditController: PHPickerViewControllerDelegate {
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if !results.isEmpty {
            let result = results.first!
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    
                    if let error = error {
                        print("There was an error: \(error)")
                        return
                    }
                    guard let image = image as? UIImage else {
                        print("Could not fetch the image")
                        return
                    }
                    DispatchQueue.main.async {
                        self?.profileImageButton.setImage(image, for: .normal)
                        self?.saveButton.isEnabled = true
                        self?.userImage = image
                    }
                }
            }
        }
        picker.dismiss(animated: true)
    }
}

extension ProfileEditController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let neededText = textField.text else {
            return
        }
        guard !neededText.isEmpty else {
            saveButtonIsEnabled = false
            saveButton.isEnabled = saveButtonIsEnabled
            return
        }
        saveButtonIsEnabled = true
        saveButton.isEnabled = saveButtonIsEnabled
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension UIImage {
    func resizeImage(to width: CGFloat, height: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
