import Foundation

class AboutImages: Codable {
    var isLiked: Bool
    var imageDescription: String
    var imageFileName: String
    
    init(isLiked: Bool, imageDescription: String, imageFileName: String) {
        self.imageDescription = imageDescription
        self.isLiked = isLiked
        self.imageFileName = imageFileName
    }
    
    enum CodingKeys: String, CodingKey {
        case isLiked
        case imageDescription
        case imageFileName
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(imageFileName, forKey: .imageFileName)
        try container.encode(isLiked, forKey: .isLiked)
        try container.encode(imageDescription, forKey: .imageDescription)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.imageFileName = try container.decode(String.self, forKey: .imageFileName)
        self.imageDescription = try container.decode(String.self, forKey: .imageDescription)
        self.isLiked = try container.decode(Bool.self, forKey: .isLiked)
    }
}
