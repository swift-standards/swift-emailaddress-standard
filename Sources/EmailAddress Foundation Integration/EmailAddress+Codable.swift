public import EmailAddress_Standard
import RFC_6531
import RFC_6531_Foundation_Integration

extension EmailAddress: Encodable, Decodable {

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(rfc6531: try container.decode(RFC_6531.Mailbox.self))
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rfc6531)
    }
}
