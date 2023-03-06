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
    
    var userInfo: PhoneUser?
    var userImage: UIImage?
    weak var delegate: ProfileEditControllerDelegate?
    var saveButtonIsEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTextFieldDelegates()
        configureImageButton()
        saveButton.isEnabled = saveButtonIsEnabled
        profileImageButton.addTarget(self, action: #selector(changeProfileImage), for: .touchUpInside)
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
        let name = userNameTextField.text ?? ""
        print(name)
        let job = userJobTextField.text ?? ""
        let phoneNumber = userPhoneTextField.text ?? ""
        let email = userEmailTextField.text ?? ""
        
        // the below code is formatting the image into data needed for persistence
        let size = UIScreen.main.bounds.size
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = image.resizeImage(to: rect.size.width, height: rect.size.height)
        guard let imageData = resizedImage.jpegData(compressionQuality: 1.0) else {
            print("could not create image data")
            return
        }
        let photo = imageData
        
        userInfo = PhoneUser(name: name, photo: photo, job: job, phoneNumber: phoneNumber, email: email)
        delegate?.ProfileEditController(self, didSaveUserInfo: userInfo!)
    }


@IBAction func saveButtonTapped(_ sender: UIButton) {
    presentSaveAlert()
    saveUserInfo()
    
    // TODO: Save info here
}

private func presentSaveAlert() {
    let alertController = UIAlertController(title: "Saved", message: "Your info has been saved", preferredStyle: .alert)
    alertController.addAction((UIAlertAction(title: "OK", style: .default)))
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
                    }
                    self?.userImage = image
                }
            }
        }
        dismiss(animated: true)
    }
}

extension ProfileEditController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let neededText = userNameTextField.text else {
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
