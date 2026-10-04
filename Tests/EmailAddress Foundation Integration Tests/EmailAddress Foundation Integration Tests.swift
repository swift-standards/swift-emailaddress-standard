import EmailAddress_Foundation_Integration
import EmailAddress_Standard
import Foundation
import RFC_1123
import RFC_6531
import Testing

@Suite
struct `EmailAddress Foundation Integration Tests` {

    @Test
    func `an email address round-trips through JSON`() throws {
        let email = EmailAddress(
            displayName: "John Doe",
            localPart: try RFC_6531.Mailbox.LocalPart("john.doe"),
            domain: try RFC_1123.Domain("example.com")
        )

        let data = try JSONEncoder().encode(email)

        #expect(try JSONDecoder().decode(EmailAddress.self, from: data) == email)
    }

    @Test
    func `an email address encodes as its mailbox text`() throws {
        let email = EmailAddress(
            localPart: try RFC_6531.Mailbox.LocalPart("user"),
            domain: try RFC_1123.Domain("example.com")
        )

        let data = try JSONEncoder().encode(email)

        #expect(String(decoding: data, as: UTF8.self) == #""user@example.com""#)
        #expect(try JSONDecoder().decode(EmailAddress.self, from: data) == email)
    }

    @Test
    func `a display name is kept in the mailbox text`() throws {
        let data = Data(#""John Doe <john.doe@example.com>""#.utf8)

        let email = try JSONDecoder().decode(EmailAddress.self, from: data)

        #expect(email.displayName == "John Doe")
        #expect(email.address == "john.doe@example.com")
        #expect(try JSONEncoder().encode(email) == data)
    }
}
