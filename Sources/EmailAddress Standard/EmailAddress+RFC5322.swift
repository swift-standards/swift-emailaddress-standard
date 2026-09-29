public import RFC_5322
public import RFC_6531

extension EmailAddress {

    public init(rfc5322: RFC_5322.Mailbox) throws(Error) {
        let mailbox: RFC_6531.Mailbox
        do throws(RFC_6531.Mailbox.Error) {
            mailbox = try RFC_6531.Mailbox(rfc5322)
        } catch {
            throw .rfc6531(error)
        }
        self.init(canonical: mailbox)
    }
}

extension RFC_5322.Mailbox {

    public init(_ emailAddress: EmailAddress) throws(RFC_6531.Mailbox.ConversionError) {
        try self.init(emailAddress.rfc6531)
    }
}
