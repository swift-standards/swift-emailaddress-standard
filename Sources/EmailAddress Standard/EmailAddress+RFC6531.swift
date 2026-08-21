import RFC_5321
import RFC_5322
public import RFC_6531

extension EmailAddress {

    public init(rfc6531: RFC_6531.EmailAddress) {

        self.init(canonical: rfc6531)
    }
}

extension RFC_6531.EmailAddress {

    public init(_ emailAddress: EmailAddress) {
        self = emailAddress.rfc6531
    }
}
