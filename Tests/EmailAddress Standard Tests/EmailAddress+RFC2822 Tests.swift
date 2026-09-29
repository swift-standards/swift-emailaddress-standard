import Domain_Standard
import EmailAddress_Standard
import RFC_2822
import RFC_6531
import Testing

@Suite
struct `EmailAddress RFC 2822 Tests` {

    @Test
    func `an email address becomes an RFC 2822 address specification`() throws {
        let email = EmailAddress(rfc6531: try RFC_6531.Mailbox("user@example.com"))

        let addrSpec = try RFC_2822.AddrSpec(email)

        #expect(addrSpec.localPart == "user")
        #expect(addrSpec.domain == "example.com")
        #expect(addrSpec.description == "user@example.com")
    }

    @Test
    func `an RFC 2822 address specification yields the local part and domain`() throws {
        let email = try EmailAddress(RFC_2822.AddrSpec(localPart: "test", domain: "example.org"))

        #expect(email.localPart.description == "test")
        #expect(email.domain.name == "example.org")
    }

    @Test
    func `an email address survives an RFC 2822 round trip`() throws {
        let original = EmailAddress(rfc6531: try RFC_6531.Mailbox("hello@world.com"))

        #expect(try EmailAddress(RFC_2822.AddrSpec(original)) == original)
    }

    @Test
    func `a subdomain is kept in the RFC 2822 address specification`() throws {
        let email = EmailAddress(rfc6531: try RFC_6531.Mailbox("admin@mail.example.com"))

        let addrSpec = try RFC_2822.AddrSpec(email)

        #expect(addrSpec.localPart == "admin")
        #expect(addrSpec.domain == "mail.example.com")
    }

    @Test
    func `a plus-tagged local part is kept in the RFC 2822 address specification`() throws {
        let email = EmailAddress(rfc6531: try RFC_6531.Mailbox("user+tag@example.com"))

        let addrSpec = try RFC_2822.AddrSpec(email)

        #expect(addrSpec.localPart == "user+tag")
        #expect(addrSpec.domain == "example.com")
    }
}
