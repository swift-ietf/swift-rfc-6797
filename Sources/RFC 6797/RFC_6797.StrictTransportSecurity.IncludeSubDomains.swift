extension RFC_6797.StrictTransportSecurity {
    /// The presence state of the RFC 6797 `includeSubDomains` directive.
    public enum IncludeSubDomains: Sendable {
        case absent
        case present
    }
}
