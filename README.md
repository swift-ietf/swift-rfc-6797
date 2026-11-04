# swift-rfc-6797

Use this package when a server sends an HSTS policy or a client reads one from a `Strict-Transport-Security` response header. Start from `RFC_6797.StrictTransportSecurity`, and use `RFC_9110.Field.Name.strictTransportSecurity` for the field name.

## Laws

- A header without `max-age` is refused. `max-age` must be one or more ASCII digits that fit in 64 bits, so a sign, a quoted value or an empty value makes the whole header invalid.
- A directive that appears twice makes the whole header invalid, even when both copies agree.
- Directive names are matched without regard to case. Directives the package doesn't know, such as `preload`, are ignored, and so are empty ones between semicolons.
- Spaces and tabs around each directive are ignored.
- The header is written as `max-age` first, then `includeSubDomains` only when it is present, separated by a semicolon and a space.
