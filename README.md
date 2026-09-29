# swift-emailaddress-standard

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)
[![CI](https://github.com/swift-standards/swift-emailaddress-standard/workflows/CI/badge.svg)](https://github.com/swift-standards/swift-emailaddress-standard/actions/workflows/ci.yml)

A domain model of an email address across the RFC standards that define one.

## Overview

`EmailAddress` stores a single canonical value — an `RFC_6531.Mailbox` — and offers the RFC 5321,
RFC 5322 and RFC 2822 views of it:

- **RFC 5321**: SMTP addresses (ASCII only)
- **RFC 5322**: Internet Message Format mailboxes (ASCII, with display names)
- **RFC 6531**: internationalized mailboxes (Unicode), the canonical representation
- **RFC 2822**: address specifications

The type is a pure domain model: it validates and converts between the standards, and it carries no
parser or serializer. Reading an email address off the wire and writing one to the wire belong in a
coder sibling.

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-standards/swift-emailaddress-standard", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "EmailAddress Standard", package: "swift-emailaddress-standard")
    ]
)
```

## Quick Start

```swift
import EmailAddress_Standard
import RFC_1123
import RFC_6531

let email = EmailAddress(
    displayName: "John Doe",
    localPart: try RFC_6531.Mailbox.LocalPart("john.doe"),
    domain: try RFC_1123.Domain("example.com")
)

email.address     // "john.doe@example.com"
email.name        // "John Doe"
email.domain.name // "example.com"
String(describing: email) // "John Doe <john.doe@example.com>"
```

## Standards Views

```swift
email.rfc6531           // RFC_6531.Mailbox, always available
email.rfc5321           // RFC_5321.EmailAddress?, nil when not ASCII
email.rfc5322           // RFC_5322.Mailbox?, nil when not ASCII
email.isASCII
email.isInternationalized
```

Each standard converts in both directions:

```swift
let fromSMTP = try EmailAddress(rfc5321: rfc5321Address)
let fromMessage = try EmailAddress(rfc5322: mailbox)
let fromAddrSpec = try EmailAddress(addrSpec)

let backToSMTP = try RFC_5321.EmailAddress(email)
let backToMessage = try RFC_5322.Mailbox(email)
let backToAddrSpec = try RFC_2822.AddrSpec(email)
```

Addresses that differ only in display name or ASCII case match:

```swift
named.matches(plain) // true
```

## Codable

Apple Foundation bridging lives in the `EmailAddress Foundation Integration` product, never in the
domain target:

```swift
.product(name: "EmailAddress Foundation Integration", package: "swift-emailaddress-standard")
```

```swift
import EmailAddress_Foundation_Integration

struct User: Codable {
    let email: EmailAddress
}
```

## Related Packages

- [swift-domain-standard](https://github.com/swift-standards/swift-domain-standard): a type-safe domain model.
- [swift-rfc-6531](https://github.com/swift-ietf/swift-rfc-6531): internationalized mailboxes.
- [swift-rfc-5321](https://github.com/swift-ietf/swift-rfc-5321), [swift-rfc-5322](https://github.com/swift-ietf/swift-rfc-5322), [swift-rfc-2822](https://github.com/swift-ietf/swift-rfc-2822): the ASCII standards.

## Requirements

- Swift 6.4
- macOS 27+ / iOS 27+ / tvOS 27+ / watchOS 27+

## License

This project is licensed under the Apache 2.0 License. See [LICENSE](LICENSE.md) for details.

## Feedback

For issues, questions, or contributions, please visit the [GitHub repository](https://github.com/swift-standards/swift-emailaddress-standard).

- [Subscribe to newsletter](http://coenttb.com/en/newsletter/subscribe)
- [Follow on X](http://x.com/coenttb)
- [Connect on LinkedIn](https://www.linkedin.com/in/tenthijeboonkkamp)
