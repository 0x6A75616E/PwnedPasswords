import Foundation

func get(url: String, apiKey: String? = nil, userAgent: String? = nil, completion: @escaping (Result<Data, HIBPError>) -> Void) {
    guard let url = URL(string: url) else {
        completion(.failure(.invalidURL))
        return
    }

    var request = URLRequest(url: url)
    if let apiKey = apiKey {
        request.setValue(apiKey, forHTTPHeaderField: "hibp-api-key")
    }

    if let userAgent = userAgent {
        request.setValue(userAgent, forHTTPHeaderField: "user-agent")
    }

    URLSession.shared.dataTask(with: request) { data, _, error in
        if error != nil {
            completion(.failure(.networkError))
        }
        if let data = data {
            completion(.success(data))
        }
    }.resume()
}
