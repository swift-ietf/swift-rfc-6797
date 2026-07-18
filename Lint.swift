// swift-linter-tools-version: 0.1

import Linter
import Linter_Standards_Rules

Lint.run(dependencies: [
    .package(
        url: "https://github.com/swift-standards/swift-standards-linter-rules.git",
        branch: "main",
        products: ["Linter Standards Rules"]
    )
]) {
    Lint.Rule.Bundle.standards
}
