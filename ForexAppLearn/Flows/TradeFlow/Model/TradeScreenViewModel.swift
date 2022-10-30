//
//  TradeScreenViewModel.swift
//  Quotex
//
//  Created by Yaşar Ergin on 14.10.2022.
//

import UIKit

enum TimeIntervals: Int, CaseIterable {
    case oneMin = 0
    case fiveMin
    case fifteenMin
    case oneHour
    case fourHours
    case oneDay
    case sevenDays
    
    var buttonTitle: String {
        switch self {
        case .oneMin:
            return R.string.localizable.oneMinuteShort()
        case .fiveMin:
            return R.string.localizable.fiveMinuteShort()
        case .fifteenMin:
            return R.string.localizable.fifteenMinuteShort()
        case .oneHour:
            return R.string.localizable.oneHourShort()
        case .fourHours:
            return R.string.localizable.fourHoursShort()
        case .oneDay:
            return R.string.localizable.oneDayShort()
        case .sevenDays:
            return R.string.localizable.oneWeekShort()
        }
    }
    
    var symbol: String {
        switch self {
        case .oneMin:
            return "1"
        case .fiveMin:
            return "5"
        case .fifteenMin:
            return "15"
        case .oneHour:
            return "60"
        case .fourHours:
            return "240"
        case .oneDay:
            return "D"
        case .sevenDays:
            return "W"
        }
    }
}

final class TradeScreenViewModel {
    var chosenTimerSeconds: Int = 30
    var currentBid: Int = 50
    var currenciesData: [CurrencyNetModel] = []
    var selectedPair: CurrencyPairs = .EURUSD
    var selectedInterval: TimeIntervals = .oneMin
    var startingPrice: Double = 0
    var endPrice: Double = 0
    
    var chartPortotype: String = """
    <html>
    <meta name="viewport" content="width=device-width, height= initial-scale=1.0">
    <body bgcolor="#010811">
    <!-- TradingView Widget BEGIN -->
    <div class="tradingview-widget-container">
      <div id="tradingview_cf2c9"></div>
      <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
      <script type="text/javascript">
      new TradingView.widget(
      {
      "autosize": true,
      "symbol": "FX_IDC:%symbol%",
      "interval": "%interval%",
      "timezone": "Etc/UTC",
      "theme": "dark",
      "style": "4",
      "locale": "en",
      "toolbar_bg": "#f1f3f6",
      "enable_publishing": false,
      "hide_top_toolbar": true,
     "studies": [
       
      ],
      "save_image": false,
      "container_id": "tradingview_cf2c9"
    }
      );
      </script>
    </div>
    <!-- TradingView Widget END -->
    </body>
    </html>
    """
    
    func getHtmlForWebView() -> String {
        var newHtml = chartPortotype.replacingOccurrences(of: "%interval%", with: selectedInterval.symbol)
        newHtml = newHtml.replacingOccurrences(of: "%symbol%", with: selectedPair.rawValue)
        return newHtml
    }
    
    func getCurrentlySelectedPairTitle() -> String {
        selectedPair.buttonTitle
    }
    
    func getCurrencyDataForCurrentPair() -> CurrencyNetModel? {
        guard let model = currenciesData.first(where: { currency in
            currency.pair == selectedPair
        }) else { return nil }
        return model
    }
    
    func makeTradeModel(for tradeType: TradeType) -> TradeModel {
        if tradeType == .sell {
            let isSuccess = startingPrice > endPrice
            print("starting price is \(startingPrice)")
            print("end price is \(endPrice)")
            print("isScuccess = \(isSuccess)")
            let model = TradeModel(
                tradeType: tradeType,
                amount: isSuccess ? currentBid : currentBid * -1,
                isSuccess: isSuccess,
                currencyPair: selectedPair
            )
            return model
        } else {
            let isSuccess = startingPrice < endPrice
            let model = TradeModel(
                tradeType: tradeType,
                amount: isSuccess ? currentBid : currentBid * -1,
                isSuccess: isSuccess,
                currencyPair: selectedPair
            )
            return model
        }
    }
}

enum TradeType: Int {
    case buy = 1
    case sell
}

struct TradeModel {
    let tradeType: TradeType
    let amount: Int
    let isSuccess: Bool
    let currencyPair: CurrencyPairs
}
