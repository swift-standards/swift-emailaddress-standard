import EmailAddress_Standard
import RFC_1123
import RFC_5321
import RFC_5322
import RFC_6531
import Testing

@Suite
struct `EmailAddress Round Trip Tests` {

    @Test
    func `an RFC 5321 email address survives a round trip through an email address`() throws {
        let original = try RFC_5321.EmailAddress("user@example.com")

        let converted = try #require(try EmailAddress(rfc5321: original).rfc5321)

        #expect(converted == original)
        #expect(converted.address == original.address)
        #expect(converted.displayName == original.displayName)
        #expect(converted.localPart.description == original.localPart.description)
        #expect(converted.domain.name == original.domain.name)
    }

    @Test
    func `an RFC 5322 mailbox survives a round trip through an email address`() throws {
        let original = try RFC_5322.Mailbox("John Doe <john@example.com>")

        let converted = try #require(try EmailAddress(rfc5322: original).rfc5322)

        #expect(converted.address == original.address)
        #expect(converted.displayName == original.displayName)
        #expect(converted.displayName == "John Doe")
    }

    @Test
    func `an RFC 6531 mailbox survives a round trip through an email address`() throws {
        let original = try RFC_6531.Mailbox("用户@example.com")

        let converted = EmailAddress(rfc6531: original).rfc6531

        #expect(converted == original)
        #expect(converted.address == original.address)
        #expect(converted.displayName == original.displayName)
        #expect(RFC_6531.Mailbox(EmailAddress(rfc6531: original)) == original)
    }

    @Test
    func `an ASCII email address has the same address in every RFC form`() throws {
        let email = EmailAddress(
            localPart: try RFC_6531.Mailbox.LocalPart("test"),
            domain: try RFC_1123.Domain("example.com")
        )

        #expect(email.rfc5321?.address == "test@example.com")
        #expect(email.rfc5322?.address == "test@example.com")
        #expect(email.rfc6531.address == "test@example.com")
    }

    @Test
    func `an internationalized RFC 6531 mailbox keeps only its RFC 6531 form`() throws {
        let email = EmailAddress(rfc6531: try RFC_6531.Mailbox("用户@example.com"))

        #expect(email.isInternationalized)
        #expect(email.rfc5321 == nil)
        #expect(email.rfc5322 == nil)
        #expect(email.rfc6531.address == "用户@example.com")
    }
}
