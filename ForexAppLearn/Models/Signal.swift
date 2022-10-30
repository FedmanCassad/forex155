import Foundation
struct SignalsResponse: Decodable {
    let data: [Signal]
    
    struct Signal: Decodable {
        let signalType: String
        let currencyPair: [String]
//        let stock: String
        let rate: Double
        let trend: String
        let priceOpen, stopLossValue, takeProfitValue: Double
        let createdAt: String
        let timeframe: String
        
        enum CodingKeys: String, CodingKey {
            case signalType = "signal_type"
            case currencyPair = "currency_pair"
            case rate, trend, timeframe
            case priceOpen = "price_open"
            case stopLossValue = "stop_loss_value"
            case takeProfitValue = "take_profit_value"
            case createdAt
        }
    }
}
