import Foundation
import ArgumentParser
import ScipioKit

struct ScipioBuildOptionGroup: ParsableArguments {
    @Option(
        name: [.customShort("o"), .customLong("output")],
        help: "Path indicates a XCFrameworks output directory."
    )
    var customOutputDirectory: URL?

    @Option(
        name: [.customLong("configuration"), .customShort("c")],
        help: "Build configuration for generated frameworks. (debug / release)"
    )
    var buildConfiguration: BuildConfiguration = .release

    @Flag(
        name: .customLong("embed-debug-symbols"),
        help: "Whether embed debug symbols to frameworks or not."
    )
    var embedDebugSymbols = false

    @Flag(
        name: .customLong("support-simulators"),
        help: "Whether also building for simulators of each SDKs or not."
    )
    var supportSimulators = false

    @Flag(
        name: [.customLong("static")],
        help: "Whether generated frameworks are Static Frameworks or not"
    )
    var shouldBuildStaticFramework = false

    @Option(
        name: [.customLong("framework-type")],
        help: "Specify the frameworkType. Availables: dynamic, static or mergeable"
    )
    var frameworkType: FrameworkType = .dynamic

    @Flag(
        name: [.customLong("library-evolution")],
        inversion: .prefixedEnableDisable,
        help: "Whether to enable Library Evolution feature or not"
    )
    var shouldEnableLibraryEvolution = false

    @Flag(
        name: [.customLong("only-use-versions-from-resolved-file")],
        help: "Whether to disable updating Package.resolved automatically"
    )
    var shouldOnlyUseVersionsFromResolvedFile: Bool = false

    @Flag(
        name: [.customShort("f", allowingJoined: false), .long],
        help: "Whether overwrite generated frameworks or not"
    )
    var overwrite: Bool = false

    @Flag(
        name: [.short, .long],
        help: "Provide additional build progress."
    )
    var verbose: Bool = false
}

extension FrameworkType: @retroactive ExpressibleByArgument { }

extension BuildConfiguration: @retroactive ExpressibleByArgument {
    public init?(argument: String) {
        let string = argument.lowercased()
        self.init(rawValue: string)
    }
}

extension URL: @retroactive ExpressibleByArgument {
    public init?(argument: String) {
        self.init(fileURLWithPath: argument)
    }
}