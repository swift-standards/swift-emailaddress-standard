import RFC_1123
public import RFC_2822
public import RFC_6531

extension RFC_2822.AddrSpec {

    public init(_ rfc6531: RFC_6531.Mailbox) throws(Error) {
        try self.init(
            localPart: rfc6531.localPart.description,
            domain: rfc6531.domain.name
        )
    }
}

extension RFC_6531.Mailbox {

    public init(_ addrSpec: RFC_2822.AddrSpec) throws(Error) {

        let localPart: LocalPart
        do throws(LocalPart.Error) {
            localPart = try .init(addrSpec.localPart)
        } catch {
            throw .invalidLocalPart(error)
        }
        let domain: RFC_1123.Domain
        do throws(RFC_1123.Domain.Error) {
            domain = try .init(addrSpec.domain)
        } catch {
            throw .invalidDomain(error)
        }
        self.init(
            displayName: nil,
            localPart: localPart,
            domain: domain
        )
    }
}
