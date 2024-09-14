import ArgumentParser
import Foundation
import ScipioKit
import ScipioStorage
import ScipioS3Storage
import Logging

let logger = Logger(label: "net.matsuji.scipio-s3")

@main
struct ScipioS3: AsyncParsableCommand {
    @Argument(help: "Path indicates a package directory.", completion: .directory)
    var packageDirectory: URL = URL(fileURLWithPath: ".")

    @Argument(help: "Bucket name")
    var bucketName: String

    @Argument(help: "Region of bucket")
    var region: String

    @Argument(help: "Endpoint of the bucket")
    var endpoint: String

    @OptionGroup var options: ScipioBuildOptionGroup

    func run() async throws {
        let logLevel: Logger.Level = options.verbose ? .trace : .info
        LoggingSystem.bootstrap(logLevel: logLevel)

        let compositeStorage = try CompositeCacheStorage(storages: [
            LocalCacheStorage(),
            s3Storage()
        ])

        let runner = try makeRunner(storage: compositeStorage)

        try await runner.run(
            packageDirectory: packageDirectory,
            frameworkOutputDir: resolveOutputDirectory()
        )
    }
}

extension ScipioS3 {

    private func s3Storage() throws -> S3Storage {
        guard let endpoint = URL(string: endpoint) else {
            logger.error("Invalid endpoint")
            throw S3StorageError.invalidEndpoint
        }

        guard let awsAccessKeyID = ProcessInfo.processInfo.environment["AWS_ACCESS_KEY_ID"] else {
            logger.error("AWS_ACCESS_KEY_ID environment variable is not set")
            throw S3StorageError.noAWSAccessKeyID
        }

        guard let awsSecretAccessKey = ProcessInfo.processInfo.environment["AWS_SECRET_ACCESS_KEY"] else {
            logger.error("AWS_SECRET_ACCESS_KEY environment variable is not set")
            throw S3StorageError.noAWSSecretAccessKey
        }

        let config = S3StorageConfig(
            authenticationMode: .authorized(accessKeyID: awsAccessKeyID, secretAccessKey: awsSecretAccessKey),
            bucket: bucketName,
            region: region,
            endpoint: endpoint
        )
        return try S3Storage(config: config)
    }

    enum S3StorageError: Error {
        case invalidEndpoint
        case noAWSAccessKeyID
        case noAWSSecretAccessKey
    }

    private func resolveOutputDirectory() -> Runner.OutputDirectory {
        if let customOutputDir = options.customOutputDirectory {
            .custom(customOutputDir)
        } else {
            .default
        }
    }

    private func makeRunner(storage: some CacheStorage) throws -> Runner {
        let runnerOptions = Runner.Options(
            baseBuildOptions: Runner.Options.BuildOptions(
                buildConfiguration: .release,
                isSimulatorSupported: options.supportSimulators,
                isDebugSymbolsEmbedded: options.embedDebugSymbols,
                frameworkType: options.frameworkType,
                enableLibraryEvolution: options.shouldEnableLibraryEvolution
            ),
            buildOptionsMatrix: [:],
            cacheMode: .storage(storage, [.consumer, .producer]),
            overwrite: true,
            verbose: options.verbose
        )

        return Runner(mode: .prepareDependencies, options: runnerOptions)
    }
}
