public import EmailAddress_Standard
import RFC_6531

extension EmailAddress: Encodable, Decodable {

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(rfc6531: try RFC_6531.Mailbox(container.decode(String.self)))
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rfc6531.description)
    }
}
