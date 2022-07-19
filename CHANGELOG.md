# Changelog
Notable changes will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Granularity validation.

### Changed
- A noRecordsMatch error on the first page emits a warning instead of exiting the harvest process. This means the lasttimestamp value is now set after harvesting an empty resultset.

### Fixed
- Identify earliestDatestamp validation is now dependent on provided granularity.

### Removed
- The ability to set a repository conditional xslt.

## [2.4.0]
### Added 
- Harvesting of non-xml content (json for instance).
- Unittests for getTargetData.

### Changed
- getTargetData function can be used for record data.
- Use default value (Unix Epoch) for earliestDatestamp when missing from source Identify.

### Deprecated
- The ability to set a repository conditional xslt will be removed after 2022-06.

## [2.3.1]
### Added
- Url-encoding for + sign in resumptionToken, thx [justinkelly](https://github.com/justinkelly).
- Improved install documentation.

## [2.3.0]
### Added
- Strict validation option with --test-strict, thx [jesteves](https://github.com/jesteves).

### Changed
- Expand timestamp validation to include decimal fractions.
- Use timestamp validation on identify earliestdatestamp (not just session lasttimestamp).
- Always use identify granularity when determining correct "from" request argument.
- Invalid granularity falls back to YYYY-MM-DD format.

### Fixed
- Check on xmllint bin existence when testing.

## [2.2.1]
### Added
- More unittests for configuration reader.

### Changed
- Set empty $TMP to prevent conflicts from called environment.

## [2.2.0]
### Changed
- Process time calculation can handle macos date output for nanoseconds.
- Process time calculation does not require bc anymore.

### Removed
- Compression support.

## [2.1.2]
### Added
- Some more unittests.
- Test for validation xmllint dependency in the testRepository function.

### Changed
- Removed getopts from command line options reader and solve implicit dependency on util-linux.

## [2.1.1]
### Fixed
- Status check is no longer performed using HEAD request.
- Curl commands are executed in eval, fixing bug with curlopts headers using spaces.

### Deprecated
- The compression option will be removed in 2021. It is more useful to compress the whole repository, but should happen outside the scope of this code.

## [2.1.0]
### Added
- Commandline option to suppress notices.

### Changed
- Temporary working files will always be stored in PID subdirectory of configured temp path.

## [2.0.0]
### Added
- Dependency check on bc, curl, grep and xsltproc
- Migration script to move from old subdirs to new subdir (see also Changed).
- Migrations tests, easily extendable.
- Support for local config in *$HOME/.config/shell-oaiharvester/config.xml*.

### Changed
- The temp work dir no longer has a random part.
- The lasttimestamp.txt has been changed to a hidden .oaiharvester file which can contain other repository status information. It will still use the old file if the new one is not present.
- The repository storage subdir generation is now based on md5sum of identifier without the newline.

### Removed
- Distinction between instance and combined logtypes. This log cannot be set to instanced anymore. Instead the harvest process PID is part of the log file.
- Dependency on awk.

## [1.4.1]
### Fixed
- Failing to start harvest on working repository based on blocked HEAD request.

## [1.4.0]
### Added
- List repository function to display repositories in the config.

## [1.3.2]
### Added
- Option to override generic curlopts config with repository specific one.

## [1.3.1]
### Changed
- Simpler option for specifying working from developer perspective.

## [1.3.0]
### Added
- Add option to configure record log file, logging each record identifier and oai datestamp.
