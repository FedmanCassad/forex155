import UIKit

struct CurrenciesResponse: Codable {
    let error: Bool
    let currencies: [CurrencyNetModel]
}

// MARK: - Currency
struct CurrencyNetModel: Codable {
    let pair: CurrencyPairs
    let price: Double
    let isTrendUp: Bool
    let changeInPercent, change, bid, ask: Double
    let max, min: Double
    let currencyAt: Date?
}
