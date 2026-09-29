public import RFC_5321
public import RFC_6531

extension RFC_6531.Mailbox {

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
