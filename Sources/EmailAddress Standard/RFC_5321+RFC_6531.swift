import RFC_1123
public import RFC_5321
public import RFC_6531

extension RFC_5321.EmailAddress {

    public init(_ rfc6531: RFC_6531.EmailAddress) throws(Error) {
        let localPart: LocalPart
        do throws(LocalPart.Error) {
            localPart = try .init(String(describing: rfc6531.localPart))
        } catch {
            throw .invalidLocalPart(error)
        }
        try self.init(
            displayName: rfc6531.displayName,
            localPart: localPart,
            domain: rfc6531.domain
        )
    }
}

extension RFC_6531.EmailAddress {

    public init(_ rfc5321: RFC_5321.EmailAddress) throws(Error) {
        let localPart: LocalPart
        do throws(LocalPart.Error) {
            localPart = try .init(String(describing: rfc5321.localPart))
        } catch {
            throw .invalidLocalPart(error)
        }
        self.init(
            displayName: rfc5321.displayName,
            localPart: localPart,
            domain: rfc5321.domain
        )
    }
}
