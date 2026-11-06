public import RFC_6531

extension EmailAddress {

    /// The address `text` spells, read as an RFC 6531 mailbox.
    public init(_ text: some StringProtocol) throws(RFC_6531.Mailbox.Error) {
        self.init(canonical: try RFC_6531.Mailbox(text))
    }
}

extension EmailAddress: Codable {

    public init(from decoder: any Decoder) throws {
        self.init(rfc6531: try RFC_6531.Mailbox(try decoder.singleValueContainer().decode(String.self)))
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rfc6531.description)
    }
}
