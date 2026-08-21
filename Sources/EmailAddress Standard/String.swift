import RFC_6531

extension String {
    public init(
        _ emailAddress: EmailAddress_Standard.EmailAddress
    ) {
        self =
            emailAddress.rfc5321
            .map(\.description) ?? emailAddress.rfc5322
            .map { String($0) } ?? String(emailAddress.rfc6531)
    }
}
