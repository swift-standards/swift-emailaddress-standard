public import Domain_Standard
public import RFC_1123
public import RFC_5321
public import RFC_5322
public import RFC_6531

public struct EmailAddress: Hashable, Sendable {

    private let canonical: RFC_6531.Mailbox

    internal init(canonical: RFC_6531.Mailbox) {
        self.canonical = canonical
    }

    public init(
        displayName: String? = nil,
        localPart: RFC_6531.Mailbox.LocalPart,
        domain: RFC_1123.Domain
    ) {
        self.canonical = RFC_6531.Mailbox(
            displayName: displayName,
            localPart: localPart,
            domain: domain
        )
    }
}

extension EmailAddress {

    public var name: String? { displayName }

    public var displayName: String? { canonical.displayName }

    public var localPart: RFC_6531.Mailbox.LocalPart { canonical.localPart }

    public var domain: Domain_Standard.Domain {
        Domain_Standard.Domain(rfc1123: canonical.domain)
    }

    public var address: String { canonical.address }

    public var isASCII: Bool { canonical.isASCII }

    public var isInternationalized: Bool { !isASCII }
}

extension EmailAddress {

    public var rfc6531: RFC_6531.Mailbox { canonical }

    public var rfc5321: RFC_5321.EmailAddress? {
        do throws(RFC_6531.Mailbox.ConversionError) {
            return try RFC_5321.EmailAddress(canonical)
        } catch {
            return nil
        }
    }

    public var rfc5322: RFC_5322.Mailbox? {
        do throws(RFC_6531.Mailbox.ConversionError) {
            return try RFC_5322.Mailbox(canonical)
        } catch {
            return nil
        }
    }
}

extension EmailAddress {

    public func matches(_ other: EmailAddress) -> Bool {
        canonical.address.lowercased() == other.canonical.address.lowercased()
    }
}

extension EmailAddress {

    public enum Error: Swift.Error, Sendable, Equatable {
        case rfc6531(RFC_6531.Mailbox.Error)
    }
}

extension EmailAddress.Error: CustomStringConvertible {

    public var description: String {
        switch self {
        case .rfc6531(let error):
            "Not representable as an RFC 6531 mailbox: \(error)"
        }
    }
}

extension EmailAddress: CustomStringConvertible {

    public var description: String { canonical.description }
}
