import Domain_Standard
import EmailAddress_Standard
import RFC_1123
import RFC_2822
import RFC_5321
import RFC_5322
import RFC_6531
import Testing

@Suite
struct `EmailAddress Tests` {

    @Test
    func `an email address is built from a local part and a domain`() throws {
        let email = EmailAddress(
            localPart: try RFC_6531.Mailbox.LocalPart("john.doe"),
            domain: try RFC_1123.Domain("example.com")
        )

        #expect(email.address == "john.doe@example.com")
        #expect(email.domain.name == "example.com")
        #expect(email.displayName == nil)
    }

    @Test
    func `a display name is carried alongside the address`() throws {
        let email = EmailAddress(
            displayName: "John Doe",
            localPart: try RFC_6531.Mailbox.LocalPart("john.doe"),
            domain: try RFC_1123.Domain("example.com")
        )

        #expect(email.name == "John Doe")
        #expect(email.description == "John Doe <john.doe@example.com>")
    }

    @Test
    func `an ASCII email address is available in its RFC 5321 and RFC 5322 forms`() throws {
        let email = EmailAddress(
            displayName: "John Doe",
            localPart: try RFC_6531.Mailbox.LocalPart("john.doe"),
            domain: try RFC_1123.Domain("example.com")
        )

        #expect(email.isASCII)

        let rfc5321 = try #require(email.rfc5321)
        #expect(rfc5321.address == "john.doe@example.com")

        let rfc5322 = try #require(email.rfc5322)
        #expect(rfc5322.displayName == "John Doe")
    }

    @Test
    func `an internationalized email address has no ASCII form`() throws {
        let email = EmailAddress(
            localPart: try RFC_6531.Mailbox.LocalPart("用户"),
            domain: try RFC_1123.Domain("example.com")
        )

        #expect(email.isInternationalized)
        #expect(email.rfc5321 == nil)
        #expect(email.rfc5322 == nil)
        #expect(email.address == "用户@example.com")
    }

    @Test
    func `an RFC 5321 email address becomes an email address`() throws {
        let rfc5321 = try RFC_5321.EmailAddress(
            displayName: "John Doe",
            localPart: try RFC_5321.EmailAddress.LocalPart("john.doe"),
            domain: try RFC_1123.Domain("example.com")
        )

        let email = try EmailAddress(rfc5321: rfc5321)

        #expect(email.address == "john.doe@example.com")
        #expect(try RFC_5321.EmailAddress(email) == rfc5321)
    }

    @Test
    func `an RFC 5322 mailbox becomes an email address`() throws {
        let rfc5322 = try RFC_5322.Mailbox(
            displayName: "John Doe",
            localPart: try RFC_5322.Mailbox.LocalPart("john.doe"),
            domain: try RFC_1123.Domain("example.com")
        )

        let email = try EmailAddress(rfc5322: rfc5322)

        #expect(email.name == "John Doe")
        #expect(try RFC_5322.Mailbox(email) == rfc5322)
    }

    @Test
    func `an RFC 2822 address specification becomes an email address`() throws {
        let addrSpec = try RFC_2822.AddrSpec(localPart: "john.doe", domain: "example.com")

        let email = try EmailAddress(addrSpec)

        #expect(email.address == "john.doe@example.com")
        #expect(try RFC_2822.AddrSpec(email) == addrSpec)
    }

    @Test
    func `email addresses match when only the display name differs`() throws {
        let localPart = try RFC_6531.Mailbox.LocalPart("john.doe")
        let domain = try RFC_1123.Domain("example.com")

        let named = EmailAddress(displayName: "John Doe", localPart: localPart, domain: domain)
        let plain = EmailAddress(localPart: localPart, domain: domain)

        #expect(named.matches(plain))
        #expect(named != plain)
    }
}
