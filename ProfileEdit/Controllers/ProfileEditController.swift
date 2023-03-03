//
//  ProfileEditController.swift
//  ProfileEdit
//
//  Created by Brendon Crowe on 3/1/23.
//

import UIKit
import PhotosUI

class ProfileEditController: UIViewController {
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var profileImageBackground: UIView!
    
    var userInfo: PhoneUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureImageButton()
    }
    
    func changeProfileImage() {
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
                }
            }
        }
        dismiss(animated: true)
    }
}
