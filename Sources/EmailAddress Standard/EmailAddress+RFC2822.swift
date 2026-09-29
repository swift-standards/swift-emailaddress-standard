public import RFC_2822
import RFC_6531

extension EmailAddress {

    public init(_ addrSpec: RFC_2822.AddrSpec) throws(Error) {
        let mailbox: RFC_6531.Mailbox
        do throws(RFC_6531.Mailbox.Error) {
            mailbox = try RFC_6531.Mailbox(addrSpec)
        } catch {
            throw .rfc6531(error)
        }
        self.init(canonical: mailbox)
    }
}

extension RFC_2822.AddrSpec {

    public init(_ emailAddress: EmailAddress) throws(Error) {
        try self.init(emailAddress.rfc6531)
    }
}
