public import RFC_5321
public import RFC_5322

extension RFC_5321.EmailAddress {

    public init(_ rfc5322: RFC_5322.EmailAddress) throws(Error) {
        let localPart: LocalPart
        do throws(LocalPart.Error) {
            localPart = try .init(String(describing: rfc5322.localPart))
        } catch {
            throw .invalidLocalPart(error)
        }
        try self.init(
            displayName: rfc5322.displayName,
            localPart: localPart,
            domain: rfc5322.domain
        )
    }
}

extension RFC_5322.EmailAddress {

    public init(_ rfc5321: RFC_5321.EmailAddress) throws(Error) {
        let localPart: LocalPart
        do throws(LocalPart.Error) {
            localPart = try .init(String(describing: rfc5321.localPart))
        } catch {
            throw .localPart(error)
        }
        try self.init(
            displayName: rfc5321.displayName,
            localPart: localPart,
            domain: rfc5321.domain
        )
    }
}
