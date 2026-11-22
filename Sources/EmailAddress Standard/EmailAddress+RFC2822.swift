public import RFC_2822
import RFC_6531

extension EmailAddress {

    public init(_ addrSpec: IETF.RFC.`2822`.AddrSpec) throws(Error) {
        let mailbox: IETF.RFC.`6531`.Mailbox
        do throws(IETF.RFC.`6531`.Mailbox.Error) {
            mailbox = try IETF.RFC.`6531`.Mailbox(addrSpec)
        } catch {
            throw .rfc6531(error)
        }
        self.init(canonical: mailbox)
    }
}

extension IETF.RFC.`2822`.AddrSpec {

    public init(_ emailAddress: EmailAddress) throws(Error) {
        try self.init(emailAddress.rfc6531)
    }
}
