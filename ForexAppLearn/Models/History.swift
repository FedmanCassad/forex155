import Foundation
struct HistoryResponse: Codable {
    let error: Bool
    let history: [History]
}

// MARK: - History
struct History: Codable {
    let id, userID: Int
    let currency: CurrencyPairs
    let dealType, dealValue, dealMode: Int
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case currency
        case dealType = "deal_type"
        case dealValue = "deal_value"
        case dealMode = "deal_mode"
        case createdAt = "created_at"
    }
}
