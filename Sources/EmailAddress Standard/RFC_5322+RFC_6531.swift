public import RFC_5322
public import RFC_6531

extension RFC_5322.EmailAddress {

    public init(_ rfc6531: RFC_6531.EmailAddress) throws(Error) {
        let localPart: LocalPart
        do throws(LocalPart.Error) {
            localPart = try .init(String(describing: rfc6531.localPart))
        } catch {
            throw .localPart(error)
        }
        try self.init(
            displayName: rfc6531.displayName,
            localPart: localPart,
            domain: rfc6531.domain
        )
    }
}

extension RFC_6531.EmailAddress {

    public init(_ rfc5322: RFC_5322.EmailAddress) throws(Error) {
        let localPart: LocalPart
        do throws(LocalPart.Error) {
            localPart = try .init(String(describing: rfc5322.localPart))
        } catch {
            throw .invalidLocalPart(error)
        }
        self.init(
            displayName: rfc5322.displayName,
            localPart: localPart,
            domain: rfc5322.domain
        )
    }
}
