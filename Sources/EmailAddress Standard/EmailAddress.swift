public import Domain_Standard
public import RFC_5321
public import RFC_5322
public import RFC_6531

public struct EmailAddress: Hashable, Sendable {

    private let canonical: RFC_6531.EmailAddress

    internal init(canonical: RFC_6531.EmailAddress) {
        self.canonical = canonical
    }

    public init(
        displayName: String? = nil,
        _ string: String
    ) throws(Error) {

        let rfc6531Address: RFC_6531.EmailAddress
        do throws(RFC_6531.EmailAddress.Error) {
            rfc6531Address = try RFC_6531.EmailAddress(string)
        } catch {
            throw .rfc6531(error)
        }

        if let displayName {
            self.canonical = RFC_6531.EmailAddress(
                displayName: displayName,
                localPart: rfc6531Address.localPart,
                domain: rfc6531Address.domain
            )
        } else {
            self.canonical = rfc6531Address
        }
    }
}

extension EmailAddress_Standard.EmailAddress {

    public init(displayName: String? = nil, localPart: String, domain: String) throws(Error) {
        try self.init(
            displayName: displayName,
            "\(localPart)@\(domain)"
        )
    }
}

extension EmailAddress_Standard.EmailAddress {

    public var name: String? { displayName }

    public var displayName: String? { canonical.displayName }

}

extension EmailAddress_Standard.EmailAddress {

    public var rfc5321: RFC_5321.EmailAddress? {
        guard canonical.isASCII else { return nil }
        do throws(RFC_5321.EmailAddress.Error) {
            return try RFC_5321.EmailAddress(canonical)
        } catch {
            return nil
        }
    }

    public var rfc5322: RFC_5322.EmailAddress? {
        guard canonical.isASCII else { return nil }
        do throws(RFC_5322.EmailAddress.Error) {
            return try RFC_5322.EmailAddress(canonical)
        } catch {
            return nil
        }
    }

    public var rfc6531: RFC_6531.EmailAddress { canonical }

}

extension EmailAddress {

    public var address: String {
        rfc5321?.address ?? rfc5322?.address ?? rfc6531.address
    }

    public var localPart: String {
        if let rfc5321 {
            return String(describing: rfc5321.localPart)
        }
        if let rfc5322 {
            return String(describing: rfc5322.localPart)
        }
        return String(describing: rfc6531.localPart)
    }
}

extension EmailAddress {

    public var domain: Domain_Standard.Domain {
        if let emailAddress = rfc5321 {
            return Domain_Standard.Domain(rfc1123: emailAddress.domain)
        }
        if let emailAddress = rfc5322 {

            return Domain_Standard.Domain(rfc1123: emailAddress.domain)
        }

        return Domain_Standard.Domain(rfc1123: rfc6531.domain)
    }

    public var isASCII: Bool {
        rfc5321 != nil || rfc5322 != nil
    }

    public var isInternationalized: Bool {
        !isASCII
    }
}

extension EmailAddress {

    public func normalized() -> EmailAddress {

        guard isASCII else { return self }

        if let rfc5321 = self.rfc5321 {

            return try! EmailAddress(rfc5321: rfc5321)
        }
        if let rfc5322 = self.rfc5322 {

            return try! EmailAddress(rfc5322: rfc5322)
        }
        return self
    }

    public func matches(_ other: EmailAddress) -> Bool {
        if let myRFC5321 = rfc5321, let otherRFC5321 = other.rfc5321 {
            return myRFC5321.address.lowercased() == otherRFC5321.address.lowercased()
        }
        if let myRFC5322 = rfc5322, let otherRFC5322 = other.rfc5322 {
            return myRFC5322.address.lowercased() == otherRFC5322.address.lowercased()
        }
        return rfc6531.address.lowercased() == other.rfc6531.address.lowercased()
    }
}

extension EmailAddress {
    public enum Error: Swift.Error, Equatable {
        case conversionFailure
        case invalidFormat(description: String)
        case rfc6531(RFC_6531.EmailAddress.Error)
    }
}

extension EmailAddress.Error {
    public var errorDescription: String? {
        switch self {
        case .conversionFailure:
            return "Failed to convert between email address formats"

        case .invalidFormat(let description):
            return "Invalid email format: \(description)"

        case .rfc6531(let error):
            return "RFC 6531 parsing failed: \(error)"
        }
    }
}

extension EmailAddress: CustomStringConvertible {
    public var description: String { String(self) }
}

extension EmailAddress: Codable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        try self.init(rawValue)
    }
}

extension EmailAddress: RawRepresentable {
    public var rawValue: String { String(self) }
    public init?(rawValue: String) {
        do throws(Error) {
            try self.init(rawValue)
        } catch {
            return nil
        }
    }
}

extension EmailAddress {
    public init(ascii string: String) throws(Error) {
        let email = try Self(string)
        guard email.isASCII else {
            throw .invalidFormat(description: "Must be ASCII-only")
        }
        self = email
    }
}

extension EmailAddress {

    public static let regex: String =
        "^(?!.*\\.\\.)[A-Za-z0-9](?:[A-Za-z0-9._%+-]{0,62}[A-Za-z0-9])?@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
}
