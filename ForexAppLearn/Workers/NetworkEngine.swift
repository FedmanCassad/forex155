import Foundation
import Alamofire

typealias SignalResponseResult = (Result<SignalsResponse, ErrorDomain>) -> Void
typealias UserResponseResult = (Result<UserResponse, AFError>) -> Void
typealias AllCurrenciesResult = (Result<CurrenciesResponse, AFError>) -> Void
typealias HistoryResult = (Result<HistoryResponse, AFError>) -> Void
typealias RatingResult = (Result<RatingResponse, AFError>) -> Void
typealias IntResult = (Result<Int, AFError>) -> Void
typealias RegResult = (Result<URL, AFError>) -> Void

enum ErrorDomain: Error {
    case AFError(AFError?)
    case errorGettingData
}

final class NetEngine {
    private var token = "4adtckJzpCSWqDDK6JmbMMi4fWEzt0LTF7E"
    
    private let session = AF.session
    
    func fetchRating(completion: @escaping RatingResult) {
        guard var components = URLComponents(string: "https://stocksinformationl.site/api/rating") else {
            completion(.failure(.explicitlyCancelled))
            return
        }

        components.queryItems = [
            .init(name: "token", value: token)
        ]
        
        guard let url = components.url else {
            completion(.failure(.explicitlyCancelled))
            return
        }
        var request = URLRequest(url: url)
        request.method = .get
        performDecodableRequest(request: request, completion: completion)
    }
    
    func submitUser(with username: String, avatar: UIImage? = nil, completion: @escaping UserResponseResult) {
        guard var components = URLComponents(string: "https://stocksinformationl.site/api/user") else {
            completion(.failure(.explicitlyCancelled))
            return
        }
        
        components.queryItems = [
            .init(name: "token", value: token),
            .init(name: "name", value: username)
        ]
        
        guard let url = components.url else {
            completion(.failure(.explicitlyCancelled))
            return
        }
        
        var request = URLRequest(url: url)
        request.method = .post
        request.addValue("Content-Type", forHTTPHeaderField: "multipart/form-data")
        request.addValue("Content-Disposition", forHTTPHeaderField: "form-data")
        performDecodableRequest(request: request, completion: completion)
    }
    
    func fetchHistory(completion: @escaping HistoryResult) {
        guard var components = URLComponents(string: "https://stocksinformationl.site/api/trade/history") else {
            completion(.failure(.explicitlyCancelled))
            return
        }
        guard let userID = UserLocalSettings.user?.id else { return }
        components.queryItems = [
            .init(name: "token", value: token),
            .init(name: "user_id", value: "\(userID)")
        ]
        
        guard let url = components.url else {
            completion(.failure(.explicitlyCancelled))
            return
        }
        
        var request = URLRequest(url: url)
        request.method = .get
        performDecodableRequest(request: request, completion: completion)
    }
    
    func fetchHistory(forSpecific userID: Int, completion: @escaping HistoryResult) {
        guard var components = URLComponents(string: "https://stocksinformationl.site/api/trade/history") else {
            completion(.failure(.explicitlyCancelled))
            return
        }
      
        components.queryItems = [
            .init(name: "token", value: token),
            .init(name: "user_id", value: "\(userID)")
        ]
        
        guard let url = components.url else {
            completion(.failure(.explicitlyCancelled))
            return
        }
        
        var request = URLRequest(url: url)
        request.method = .get
        performDecodableRequest(request: request, completion: completion)
    }
    
    func requestAllCurrenciesCourses(completion: @escaping AllCurrenciesResult) {
        guard var components = URLComponents(string: "https://stocksinformationl.site/api/currencies/current") else {
            completion(.failure(.explicitlyCancelled))
            return
        }
        
        components.queryItems = [
            .init(name: "token", value: token)
        ]
        
        guard let url = components.url else {
            completion(.failure(.explicitlyCancelled))
            return
        }
        
        var request = URLRequest(url: url)
        request.method = .get
        performDecodableRequest(request: request, completion: completion)
    }
    
    func updateUserAvatar(with image: UIImage, completion: @escaping UserResponseResult) {
            guard var components = URLComponents(string: "https://stocksinformationl.site/api/user") else {
                completion(.failure(.explicitlyCancelled))
                return
            }
            
        guard let userName = UserLocalSettings.user?.name else {
            return
        }
            components.queryItems = [
                .init(name: "token", value: token),
                .init(name: "name", value: userName)
            ]
            
            guard let url = components.url else {
                completion(.failure(.explicitlyCancelled))
                return
            }
        let boundary = UUID().uuidString
        let mfData = MultipartFormData(fileManager: .default, boundary: boundary)
        mfData.append(
            image.pngData() ?? Data(),
            withName: "avatar",
            fileName: "avatar.png",
            mimeType: "image/png"
        )
         performDecodableUploadRequest(requestData: (mfData, url), completion: completion)
    }
    
    func updateUserAvatarAndName(with image: UIImage, name: String, completion: @escaping UserResponseResult) {
            guard var components = URLComponents(string: "https://stocksinformationl.site/api/user") else {
                completion(.failure(.explicitlyCancelled))
                return
            }
        
            components.queryItems = [
                .init(name: "token", value: token),
                .init(name: "name", value: name)
            ]
            
            guard let url = components.url else {
                completion(.failure(.explicitlyCancelled))
                return
            }
        let boundary = UUID().uuidString
        let mfData = MultipartFormData(fileManager: .default, boundary: boundary)
        mfData.append(
            image.pngData() ?? Data(),
            withName: "avatar",
            fileName: "avatar.png",
            mimeType: "image/png"
        )
         performDecodableUploadRequest(requestData: (mfData, url), completion: completion)
    }
       
    func makeTrade(with tradeModel: TradeModel, completion: @escaping UserResponseResult) {
        guard var components = URLComponents(string: "https://stocksinformationl.site/api/trade") else {
            completion(.failure(.explicitlyCancelled))
            return
        }
        
        guard
            let userID = UserLocalSettings.user?.id
        else { return }
        components.queryItems = [
            .init(name: "token", value: token),
            .init(name: "user_id", value: "\(userID)"),
            .init(name: "currency", value: tradeModel.currencyPair.rawValue),
            .init(name: "deal_type", value: tradeModel.isSuccess ? "1" : "2"),
            .init(name: "deal_value", value: "\(tradeModel.amount)"),
            .init(name: "deal_mode", value: "\(tradeModel.tradeType.rawValue)"),
        ]

        guard let url = components.url else {
            completion(.failure(.explicitlyCancelled))
            return
        }
        
        var request = URLRequest(url: url)
        request.method = .post
        performDecodableRequest(request: request, completion: completion)
    }
    

    
    private func performRequest<T: Decodable>(request: RequestGenerator,
                                              completion: @escaping (Result<T, ErrorDomain>) -> Void) {
        let request = request.request
        AF.request(request).validate().responseDecodable(of: T.self , queue: .global(qos: .userInitiated)) { data in
            guard let data = data.value else {
                completion(.failure(.AFError(data.error)))
                return
            }
            completion(.success(data))
        }
    }
    
    private func performDecodableRequest<T: Decodable>(
        request: URLRequest,
        completion: @escaping ((Result<T, AFError>) -> Void)
    ) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        AF.request(request)
            .validate()
            .responseDecodable(
                of: T.self,
                queue: .global(qos: .userInitiated),
                decoder: decoder
            ) { result in
                guard let data = result.value else {
                    if let error = result.error {
                        completion(.failure(error))
                    }
                    return
                }
                completion(.success(data))
            }
    }
    
    private func performDecodableUploadRequest<T: Decodable>(
        requestData: (MultipartFormData, URL),
        completion: @escaping ((Result<T, AFError>) -> Void)
    ) {
        
        let headers = [
            "Content-Type": "multipart/form-data",
            "Content-Disposition": "form-data"
        ]
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        let mfObject = requestData.0
        print(mfObject)
        AF
            .upload(multipartFormData: mfObject, to: requestData.1,
                    method: .post, headers: .init(headers))
            .validate()
            .responseDecodable(
                of: T.self,
                queue: .global(qos: .userInitiated),
                decoder: decoder
            ) { result in
                guard let data = result.value else {
                    if let error = result.error {
                        completion(.failure(error))
                    }
                    return
                }
                completion(.success(data))
            }
    }
    
    func fetchSignals(completion: @escaping SignalResponseResult) {
        performRequest(request: .signals, completion: completion)
    }
}
