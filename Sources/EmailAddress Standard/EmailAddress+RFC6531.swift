public import RFC_6531

extension EmailAddress {

    public init(rfc6531: IETF.RFC.`6531`.Mailbox) {
        self.init(canonical: rfc6531)
    }
}

extension IETF.RFC.`6531`.Mailbox {

    public init(_ emailAddress: EmailAddress) {
        self = emailAddress.rfc6531
    }
}
