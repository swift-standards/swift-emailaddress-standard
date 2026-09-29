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
}
