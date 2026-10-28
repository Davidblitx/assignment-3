# Assignment 3 - CI/CD with GitHub Actions
## Setup
chmod +x app/*.sh scripts/*.sh tests/*.sh
## Usage
./app/app.sh system-info | check-host <host> | check-port <host> <port> | help
## Testing
./scripts/lint.sh, ./tests/test.sh, ./scripts/build.sh, ./grade.sh
## CI
Pipeline: validate -> test -> docker (enforced with needs:). Runs on push and pull_request.
## CI failure demonstration
Branch `ci-fail-demo` introduced a syntax error in app/app.sh. The validate job failed and
test/docker were skipped. The fix was pushed and the pipeline passed.
## Assumptions
Linux, bash, Docker installed.
