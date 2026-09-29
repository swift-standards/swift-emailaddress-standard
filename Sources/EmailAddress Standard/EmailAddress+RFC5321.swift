public import RFC_5321
public import RFC_6531

extension EmailAddress {

    public init(rfc5321: RFC_5321.EmailAddress) throws(Error) {
        let mailbox: RFC_6531.Mailbox
        do throws(RFC_6531.Mailbox.Error) {
            mailbox = try RFC_6531.Mailbox(rfc5321)
        } catch {
            throw .rfc6531(error)
        }
        self.init(canonical: mailbox)
    }
}

extension RFC_5321.EmailAddress {

    public init(_ emailAddress: EmailAddress) throws(RFC_6531.Mailbox.ConversionError) {
        try self.init(emailAddress.rfc6531)
    }
}
