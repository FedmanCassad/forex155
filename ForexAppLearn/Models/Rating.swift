import Foundation

struct RatingResponse: Codable {
    let error: Bool
    let rating: [Rating]
}

// MARK: - Rating
struct Rating: Codable {
    let userID: Int
    let userName: String
    let avatar: String
    let rate: Int

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case userName, avatar, rate
    }
}
