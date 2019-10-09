public struct HIBP {
    public let apiKey: String
    public let userAgent: String
    let baseURL = "https://haveibeenpwned.com/api/v3"

    public init(apiKey: String, userAgent: String) {
        self.apiKey = apiKey
        self.userAgent = userAgent
    }
}

public enum HIBPError: Error {
    case invalidURL
    case networkError
    case decodeError
}
