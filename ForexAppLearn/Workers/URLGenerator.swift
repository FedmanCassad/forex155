import Foundation

enum RequestGenerator {
    
    private enum URLGenerator {
        case signals
        
        var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-dd"
            return formatter
        }
        
        private var currencyListSymbols: String {
            "USD,EUR,RUB,JPY,GBP,AUD,CAD,BRL,UAH,BYN,BGN"
        }
        
        private var signalsToken: String {
            guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
              fatalError("Couldn't find file 'Info.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "signals_token") as? String else {
              fatalError("Couldn't find key 'API_KEY' in 'Info.plist'.")
            }
            return value
        }
        
        private var baseCurrency: String {
            guard let baseCurrency = UserDefaults.standard.object(forKey: "baseCurrency") as? String else {
                return "USD"
            }
            return baseCurrency
        }
        
        var url: URL {
            switch self {
            case .signals:
                var components = URLComponents(string: "https://finapp.finanse.space/api/fetch/signals")
                components?.queryItems = [
                    .init(name: "token" , value: signalsToken)
                ]
                guard let url = components?.url else {
                    fatalError("Error with API url")
                }
                return url
            }
        }
    }
    
    case signals
    
    var request: URLRequest {
        switch self {
        case .signals:
            let url = URLGenerator.signals.url
            return URLRequest(url: url)
        }
    }
}
