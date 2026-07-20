fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

### update_native_libraries

```sh
[bundle exec] fastlane update_native_libraries
```

Updates the versions of the native libraries.

#### Options
* `version`: The version of the native libraries.
* `platform`: The platform to update. Leave blank to update both.
* `local`: Whether to use the local SPM instead of the remote.

#### Examples
```sh
bundle exec fastlane update_native_libraries version:3.4.0
bundle exec fastlane update_native_libraries version:3.4.0 platform:android
bundle exec fastlane update_native_libraries version:3.4.0 platform:ios
bundle exec fastlane update_native_libraries version:3.4.0 local:true
bundle exec fastlane update_native_libraries version:3.4.0 local:true platform:ios
```


### clear

```sh
[bundle exec] fastlane clear
```

#### Examples
```sh
bundle exec fastlane clear
```


### update_kotlin_version

```sh
[bundle exec] fastlane update_kotlin_version
```

Updates Kotlin version of each package.

#### Options
* `version`: The new version for Kotlin.

#### Examples
```sh
bundle exec fastlane update_kotlin_version version:1.7.20
```


### bump

```sh
[bundle exec] fastlane bump
```

Updates the version of each package.

#### Options
* `version`: The new version for the libraries.

#### Examples
```sh
bundle exec fastlane bump version:3.4.0
```


### update_sample_apps

```sh
[bundle exec] fastlane update_sample_apps
```

Updates the lockfile of each package, and sample apps iOS dependencies (SPM & Pods).

#### Options
* `local`: Use local iOS SDK libs for sample app Pods and SPM dependencies.

#### Examples
```sh
bundle exec fastlane update_sample_apps
bundle exec fastlane update_sample_apps local:true
```


### publish

```sh
[bundle exec] fastlane publish
```

Validates and publishes each package.

#### Options
* `dry_run`: Only run in validation mode.

#### Examples
```sh
bundle exec fastlane publish
bundle exec fastlane publish dry_run:true
```


----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
