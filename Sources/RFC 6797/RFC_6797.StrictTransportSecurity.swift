public import RFC_9110

extension RFC_6797 {

    public struct StrictTransportSecurity: Sendable {

        public let maxAge: UInt64

        public let includeSubDomains: Bool

        public init(maxAge: UInt64, includeSubDomains: IncludeSubDomains = .absent) {
            self.maxAge = maxAge
            self.includeSubDomains = includeSubDomains == .present
        }
    }
}

extension RFC_6797.StrictTransportSecurity: Codable, Equatable, Hashable, CustomStringConvertible {
    private init(maxAge: UInt64, includeSubDomains: Bool) {
        self.maxAge = maxAge
        self.includeSubDomains = includeSubDomains
    }

    public var headerValue: String {
        if includeSubDomains {
            return "max-age=\(maxAge); includeSubDomains"
        }
        return "max-age=\(maxAge)"
    }

    public static func parse(_ value: String) -> Self? {
        var maxAge: UInt64?
        var includeSubDomains = false

        for rawDirective in value.split(separator: ";", omittingEmptySubsequences: false) {
            let directive = trimOWS(rawDirective)
            guard !directive.isEmpty else { return nil }

            let parts = directive.split(
                separator: "=",
                maxSplits: 1,
                omittingEmptySubsequences: false
            )
            let name = parts[0].lowercased()

            switch name {
            case "max-age":
                guard maxAge == nil, parts.count == 2 else { return nil }
                let digits = parts[1]
                guard !digits.isEmpty,
                    digits.utf8.allSatisfy({ $0 >= 48 && $0 <= 57 }),
                    let parsed = UInt64(digits)
                else { return nil }
                maxAge = parsed

            case "includesubdomains":
                guard parts.count == 1, !includeSubDomains else { return nil }
                includeSubDomains = true

            default:
                return nil
            }
        }

        guard let maxAge else { return nil }
        return Self(maxAge: maxAge, includeSubDomains: includeSubDomains)
    }

    public init?(_ value: String) {
        guard let parsed = Self.parse(value) else { return nil }
        self = parsed
    }

    public var description: String { headerValue }

    private static func trimOWS(_ value: Substring) -> Substring {
        var result = value
        while result.first == " " || result.first == "\t" { result = result.dropFirst() }
        while result.last == " " || result.last == "\t" { result = result.dropLast() }
        return result
    }
}

extension RFC_9110.Header.Field.Name {

    public static var strictTransportSecurity: Self {
        get throws(RFC_9110.Header.Field.Name.Error) {
            try Self("Strict-Transport-Security")
        }
    }
}
