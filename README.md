# Scipio-S3
A cli tool wrapping [Scipio](https://github.com/giginet/Scipio) for using S3 as a cache storage.
This tool caches XCFrameworks to your local storage and S3 storage.

## How to Use
Before using this tool, set environment values, `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.

```sh
$ scipio-s3 {path/to/MyAppDependencies} {bucket name} {region} {endpoint}
```
This is an example.
```sh
$ scipio-s3 ./ scipio-cache us-east-1 http://s3.us-east-1.amazonaws.com
```
This tool also supports the same options Scipio like `--support-simulators` and `--embed-debug-symbols`.
Please check documents of options of scipio.
