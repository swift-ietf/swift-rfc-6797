# swift-rfc-6797

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Foundation-free Swift implementation of RFC 6797: HTTP Strict Transport Security (HSTS).

The package provides the RFC 6797 `Strict-Transport-Security` field name and its defined `max-age` and `includeSubDomains` directives. Redirect handling, preload policy, and deployment policy are outside this specification package.

```swift
import RFC_6797

let hsts = RFC_6797.StrictTransportSecurity(maxAge: 31_536_000, includeSubDomains: true)
print(hsts.headerValue) // max-age=31536000; includeSubDomains
```
