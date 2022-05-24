import Foundation
import UIKit

extension ImagesCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            guard let savedImageFileName = FileManager.saveImage(image) else { return }
            
            let userSavedData = AboutImages(isLiked: false, imageDescription: "", imageFileName: savedImageFileName)
            UserSavedImagesManager.shared.saveImages(aboutImages: userSavedData)
            
        } else if let image = info[.editedImage] as? UIImage {
            guard let savedImageFileName = FileManager.saveImage(image) else { return }
            let userSavedData = AboutImages(isLiked: false, imageDescription: "", imageFileName: savedImageFileName)
            UserSavedImagesManager.shared.saveImages(aboutImages: userSavedData)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
