public import RFC_2822
import RFC_5322
import RFC_6531

extension EmailAddress {

    public init(_ addrSpec: RFC_2822.AddrSpec) throws(Error) {

        let rfc6531: RFC_6531.EmailAddress
        do throws(RFC_6531.EmailAddress.Error) {
            rfc6531 = try RFC_6531.EmailAddress(addrSpec)
        } catch {
            throw .rfc6531(error)
        }
        self.init(canonical: rfc6531)
    }
}

extension RFC_2822.AddrSpec {

    public init(_ emailAddress: EmailAddress) throws(Error) {
        if let rfc5322 = emailAddress.rfc5322 {

            try self.init(
                localPart: String(describing: rfc5322.localPart),
                domain: rfc5322.domain.name
            )
        } else {

            try self.init(emailAddress.rfc6531)
        }
    }
}
