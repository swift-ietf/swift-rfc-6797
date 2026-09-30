import RFC_9110
import Testing

@testable import RFC_6797

struct RFC_6797_StrictTransportSecurity_Tests {}

extension RFC_6797_StrictTransportSecurity_Tests {
    @Suite
    struct Unit {
        @Test
        func `field name is owned by RFC 9110`() throws {
            let canonical = try RFC_9110.Field.Name.strictTransportSecurity
            let lowercase = try RFC_9110.Field.Name("strict-transport-security")

            #expect(canonical.rawValue == "Strict-Transport-Security")
            #expect(lowercase == canonical)
        }

        @Test
        func `serializes the required directive`() {
            #expect(
                RFC_6797.StrictTransportSecurity(maxAge: 31_536_000).headerValue
                    == "max-age=31536000"
            )
            #expect(
                RFC_6797.StrictTransportSecurity(
                    maxAge: 31_536_000,
                    includeSubDomains: .present
                ).headerValue == "max-age=31536000; includeSubDomains"
            )
        }
    }

    @Suite
    struct `Edge Case` {
        @Test
        func `rejects a missing or malformed max-age`() {
            #expect(RFC_6797.StrictTransportSecurity.parse("includeSubDomains") == nil)
            #expect(RFC_6797.StrictTransportSecurity.parse("max-age=-1") == nil)
        }

        @Test
        func `ignores unknown directives and skips empty ones`() {
            #expect(RFC_6797.StrictTransportSecurity.parse("max-age=60; preload")?.maxAge == 60)
            #expect(RFC_6797.StrictTransportSecurity.parse("max-age=60; report-uri=\"https://example.com\"")?.maxAge == 60)
            #expect(RFC_6797.StrictTransportSecurity.parse("max-age=60;")?.maxAge == 60)
            #expect(RFC_6797.StrictTransportSecurity.parse("max-age=60;; includeSubDomains")?.includeSubDomains == true)
            #expect(RFC_6797.StrictTransportSecurity.parse(";max-age=60")?.maxAge == 60)
        }

        @Test
        func `a repeated directive still invalidates the header`() {
            #expect(RFC_6797.StrictTransportSecurity.parse("max-age=60; max-age=70") == nil)
            #expect(RFC_6797.StrictTransportSecurity.parse("max-age=60; includeSubDomains; includeSubDomains") == nil)
        }
    }

    @Suite
    struct Integration {
        @Test
        func `parses RFC 6797 directives`() {
            let value = RFC_6797.StrictTransportSecurity.parse(
                "  max-age=31536000 ; includeSubDomains  "
            )
            #expect(value?.maxAge == 31_536_000)
            #expect(value?.includeSubDomains == true)
        }
    }
}
