public import RFC_5322
public import RFC_6531

extension RFC_6531.Mailbox {

    public init(_ rfc5322: RFC_5322.Mailbox) throws(Error) {
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
