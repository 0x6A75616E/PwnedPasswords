import Foundation

public struct BreachedAccount: Codable {
    public var name: String

    enum CodingKeys: String, CodingKey {
        case name = "Name"
    }
}

extension HIBP {
    public func breachedAccountFull(account: String, domain: String? = nil, completion: @escaping (Result<[Breach], HIBPError>) -> Void) {
        var url = "\(baseURL)/breachedaccount/\(account)?truncateResponse=false"
        if let domain = domain {
            url += "&domain=\(domain)"
        }
        let responseData = get(url: url, apiKey: apiKey, userAgent: userAgent) { result in
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

    public func breachedAccount(account: String, domain: String? = nil, completion: @escaping (Result<[BreachedAccount], HIBPError>) -> Void) {
        var url = "\(baseURL)/breachedaccount/\(account)?truncateResponse=true"
        if let domain = domain {
            url += "&domain=\(domain)"
        }
        get(url: url, apiKey: apiKey, userAgent: userAgent) { result in
            switch result {
            case let .success(data):
                let decoded = decodeBreachedAccount(data: data)
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

func decodeBreachedAccount(data: Data) -> Result<[BreachedAccount], HIBPError> {
    let decoder = JSONDecoder()
    // decoder.keyDecodingStrategy =
    guard let decoded = try? decoder.decode([BreachedAccount].self, from: data) else { return .failure(.decodeError) }
    return .success(decoded)
}
