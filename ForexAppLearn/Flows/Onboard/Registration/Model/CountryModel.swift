//
//  CountryModel.swift
//  Quotex
//
//  Created by Yaşar Ergin on 13.10.2022.
//

import UIKit

struct CountryModel: Codable {
    let title: String
    let langCode: String
    
    static let allCountries: [CountryModel] = [
        .init(title: "USA", langCode: "us"),
        .init(title: "China", langCode: "cn"),
        .init(title: "India", langCode: "in"),
        .init(title: "Indonesia", langCode: "id"),
        .init(title: "Pakistan", langCode: "pk"),
        .init(title: "Brazil", langCode: "br"),
        .init(title: "Nigeria", langCode: "ng"),
        .init(title: "Bangladesh", langCode: "bd"),
        .init(title: "Russian Federation", langCode: "ru"),
        .init(title: "Mexico", langCode: "mx"),
        .init(title: "Great Britain", langCode: "gb")
    ].sorted(by: { $0.title < $1.title })
}
