import RFC_1123
public import RFC_2822
public import RFC_6531

extension IETF.RFC.`2822`.AddrSpec {

    public init(_ rfc6531: IETF.RFC.`6531`.Mailbox) throws(Error) {
        try self.init(
            localPart: rfc6531.localPart.description,
            domain: .init(rfc6531.domain.name)
        )
    }
}

extension IETF.RFC.`6531`.Mailbox {

    public init(_ addrSpec: IETF.RFC.`2822`.AddrSpec) throws(Error) {

        let localPart: LocalPart
        do throws(LocalPart.Error) {
            localPart = try .init(addrSpec.localPart)
        } catch {
            throw .invalidLocalPart(error)
        }
        let domain: IETF.RFC.`1123`.Domain
        do throws(IETF.RFC.`1123`.Domain.Error) {
            domain = try .init(addrSpec.domain.value)
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
