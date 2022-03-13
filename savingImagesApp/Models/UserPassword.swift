import Foundation

class UserPassword: Codable {
    var password: String
    
    init(password: String) {
        self.password = password
    }
    
    enum CodingKeys: String, CodingKey {
        case password
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(password, forKey: .password)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.password = try container.decode(String.self, forKey: .password)
    }
}
