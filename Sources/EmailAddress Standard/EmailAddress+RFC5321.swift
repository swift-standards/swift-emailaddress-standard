public import RFC_5321
import RFC_5322
import RFC_6531

extension EmailAddress {

    public init(rfc5321: RFC_5321.EmailAddress) throws(Error) {

        let rfc6531: RFC_6531.EmailAddress
        do throws(RFC_6531.EmailAddress.Error) {
            rfc6531 = try RFC_6531.EmailAddress(rfc5321)
        } catch {
            throw .rfc6531(error)
        }
        self.init(canonical: rfc6531)
    }
}

extension RFC_5321.EmailAddress {

    public init(_ emailAddress: EmailAddress) throws(EmailAddress.Error) {
        guard let rfc5321 = emailAddress.rfc5321 else {
            throw .conversionFailure
        }
        self = rfc5321
    }
}
