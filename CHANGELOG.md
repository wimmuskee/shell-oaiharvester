# Changelog
Notable changes will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]
### Added
- Dependency check on bc, curl and xsltproc

### Changed
- Logtypes are gone, the default logs are always logged combined. The harvest process PID is part of the log file.
- The temp work dir no longer has a random part.

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
