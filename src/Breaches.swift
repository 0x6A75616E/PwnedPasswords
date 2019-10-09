import Foundation

public struct Breach: Codable {
    public var name: String
    public var title: String
    public var domain: String
    public var breachDate: String
    public var addedDate: String
    public var modifiedDate: String
    public var pwnCount: Int
    public var description: String
    public var dataClasses: [String]
    public var isVerified: Bool
    public var isFabricated: Bool
    public var isSensitive: Bool
    public var isRetired: Bool
    public var isSpamList: Bool
    public var logoPath: String

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case title = "Title"
        case domain = "Domain"
        case breachDate = "BreachDate"
        case addedDate = "AddedDate"
        case modifiedDate = "ModifiedDate"
        case pwnCount = "PwnCount"
        case description = "Description"
        case dataClasses = "DataClasses"
        case isVerified = "IsVerified"
        case isFabricated = "IsFabricated"
        case isSensitive = "IsSensitive"
        case isRetired = "IsRetired"
        case isSpamList = "IsSpamList"
        case logoPath = "LogoPath"
    }
}

extension HIBP {
    public func breaches(domain: String? = nil, completion: @escaping (Result<[Breach], HIBPError>) -> Void) {
        let url: String
        if let domain = domain {
            url = "\(baseURL)/breaches?domain=\(domain)"
        } else {
            url = "\(baseURL)/breaches"
        }

        get(url: url, apiKey: apiKey, userAgent: userAgent) { result in
            switch result {
            case let .success(data):
                let decoded = decodeBreaches(data: data)
                switch decoded {
                case let .success(decodedData):
                    completion(.success(decodedData))
                case let .failure(error):
                    completion(.failure(error))
                }

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    public func breach(name: String, completion: @escaping (Result<[Breach], HIBPError>) -> Void) {
        let url = "\(baseURL)/breach\(name)"
        get(url: url, apiKey: apiKey, userAgent: userAgent) { result in
            switch result {
            case let .success(data):
                let decoded = decodeBreaches(data: data)
                switch decoded {
                case let .success(decodedData):
                    completion(.success(decodedData))
                case let .failure(error):
                    completion(.failure(error))
                }

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

func decodeBreaches(data: Data) -> Result<[Breach], HIBPError> {
    let decoder = JSONDecoder()
    guard let decoded = try? decoder.decode([Breach].self, from: data) else { return .failure(.decodeError) }
    return .success(decoded)
}
