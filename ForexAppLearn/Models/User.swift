import Foundation

struct UserResponse: Codable {
    let error: Bool
    let user: User
}

// MARK: - User
struct User: Codable {
    let id: Int
    let isUserExists: Bool
    let balance: Int
    let name: String
    let avatar: URL?
}
