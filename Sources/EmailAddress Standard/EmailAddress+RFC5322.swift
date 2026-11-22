public import RFC_5322
public import RFC_6531

extension EmailAddress {

    public init(rfc5322: IETF.RFC.`5322`.Mailbox) throws(Error) {
        let mailbox: IETF.RFC.`6531`.Mailbox
        do throws(IETF.RFC.`6531`.Mailbox.Error) {
            mailbox = try IETF.RFC.`6531`.Mailbox(rfc5322)
        } catch {
            throw .rfc6531(error)
        }
        self.init(canonical: mailbox)
    }
}

extension IETF.RFC.`5322`.Mailbox {

    public init(_ emailAddress: EmailAddress) throws(IETF.RFC.`6531`.Mailbox.ConversionError) {
        try self.init(emailAddress.rfc6531)
    }
}
