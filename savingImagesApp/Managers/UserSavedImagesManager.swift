import Foundation

class UserSavedImagesManager {
    //MARK: - properties
    static let shared = UserSavedImagesManager()
    
    //MARK: - private init
    private init() {}
    
    //MARK: - methods
    func saveImages(aboutImages: AboutImages) {
        var loadedImages = receiveImages()
        loadedImages.append(aboutImages)
        
        UserDefaults.standard.setValue(encodable: loadedImages, forKey: UserDefaultsKeys.imagesKey)
    }
    
    func receiveImages() -> [AboutImages] {
        guard let model = UserDefaults.standard.loadValue([AboutImages].self, forKey: UserDefaultsKeys.imagesKey) else { return [] }
        return model
    }
}
