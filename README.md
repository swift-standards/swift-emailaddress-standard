# swift-emailaddress-standard

Use this package when you need one email address type that accepts internationalized addresses and still gives you the SMTP and message header forms when they exist. Start from `EmailAddress`. If you need exactly one standard's rules, use `RFC_5321.EmailAddress` from swift-rfc-5321, `RFC_5322.Mailbox` from swift-rfc-5322 or `RFC_6531.Mailbox` from swift-rfc-6531. For encoding and decoding, add the `EmailAddress Foundation Integration` product.

## Laws

- An `EmailAddress` is stored as an RFC 6531 mailbox, so any address RFC 6531 accepts, including non-ASCII local parts, can be held.
- `EmailAddress.rfc5321` and `EmailAddress.rfc5322` are set only for ASCII addresses. For an internationalized address both are nil, and converting it to `RFC_5321.EmailAddress` or `RFC_5322.Mailbox` throws.
- Equality includes the display name. `EmailAddress.matches(_:)` compares only the addresses, ignoring the display name and the case of the whole address, local part included.
- An `RFC_2822.AddrSpec` has no display name, so converting through it drops the display name.
- With `EmailAddress Foundation Integration`, an address encodes as its mailbox text, such as `user@example.com`, or with the display name first and the address in angle brackets. Decoding reads the same forms.
