

import Foundation

enum Currency: String {
    case EUR
    case GPB
    case AUD
    case CHF
    case NZD
    case USD
    case RUB
    
    var symbol: String {
        switch self {
        case .EUR:
            return "€"
        case .GPB:
            return "£"
        case .AUD:
            return "A$"
        case .CHF:
            return "F"
        case .NZD:
            return "$NZ"
        case .USD:
            return "$"
        case .RUB:
            return "₽"
        }
    }
}

enum CurrencyPairs: String, Codable, CaseIterable {
    case EURUSD
    case USDJPY
    case GBPUSD
    case AUDUSD
    case USDCAD
    case USDCHF
    case NZDUSD
    case EURJPY
    case GBPJPY
    case EURGBP
    case AUDJPY
    case EURAUD
    case EURCHF
    case AUDNZD
    case NZDJPY
    case GBPAUD
    case GBPCAD
    case EURNZD
    case AUDCAD
    case GBPCHF
    case USDRUB
    case RUBUSD
    
    var baseValue: Currency {
        switch self {
        case .EURUSD:
            return .EUR
        case .USDJPY:
            return .USD
        case .GBPUSD:
            return .GPB
        case .AUDUSD:
            return .AUD
        case .USDCAD:
            return .USD
        case .USDCHF:
            return .USD
        case .NZDUSD:
            return .NZD
        case .EURJPY:
            return .EUR
        case .GBPJPY:
            return .GPB
        case .EURGBP:
            return .EUR
        case .AUDJPY:
            return .AUD
        case .EURAUD:
            return .EUR
        case .EURCHF:
            return .EUR
        case .AUDNZD:
            return .AUD
        case .NZDJPY:
            return .NZD
        case .GBPAUD:
            return .GPB
        case .GBPCAD:
            return .GPB
        case .EURNZD:
            return .EUR
        case .AUDCAD:
            return .AUD
        case .GBPCHF:
            return .GPB
        case .USDRUB:
            return .USD
        case .RUBUSD:
            return .RUB
        }
    }
    
    var buttonTitle: String {
        return self.rawValue.prefix(3) + "/" + self.rawValue.suffix(3)
    }
}
