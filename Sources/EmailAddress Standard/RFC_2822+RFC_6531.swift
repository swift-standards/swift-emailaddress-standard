public import RFC_2822
public import RFC_6531

extension RFC_2822.AddrSpec {

    public init(_ rfc6531: RFC_6531.EmailAddress) throws(Error) {

        let combined = "\(rfc6531.localPart)@\(rfc6531.domain.name)"
        try self.init(ascii: combined.utf8.map { Byte($0) })
    }
}

extension RFC_6531.EmailAddress {

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
            throw .invalidDomain(String(describing: error))
        }
        self.init(
            displayName: nil,
            localPart: localPart,
            domain: domain
        )
    }
}
