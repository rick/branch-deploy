# branch-deploy



## Setup

```
$ script/bootstrap
```

## Running

```
$ bd --help
Usage: bd [options]
    -r, --repo REPOSITORY            Repository passed to 'git clone' command on deployment host [REQUIRED]
    -b, --branch BRANCH              Branch name to deploy [REQUIRED]
    -h, --host HOSTNAME              Target host for remote deployment [REQUIRED, or --local]
    -l, --local                      Deploy to the local host (default: false) [REQUIRED, or --host]
    -p, --path PATH                  Deployment path on target host [REQUIRED]
    -d, --diff                       Return diff output for proposed changes, do not deploy (default: true)
    -c, --confirm                    Confirm deployment -- actually update files (default: false)
    -s, --ssh-options OPTIONS        Flags passed to the 'ssh' command for remote deployment (default: "")
    -t, --temp-path                  Base path for tempdir creation on deployment host (default: OS default)
    -v, --verbose                    Run verbosely (default: false)
    -h, --help                       Prints this help
```

## Testing

```
$ script/test

Run options: --seed 27657

# Running:

.

Finished in 0.000601s, 1663.8931 runs/s, 1663.8931 assertions/s.

1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
```

or:

```
$ bundle exec rake

Run options: --seed 63598

# Running:

.

Finished in 0.000914s, 1094.0919 runs/s, 1094.0919 assertions/s.
1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
```

To view rake test targets:

```
rake spec           # Run the test suite
rake spec:cmd       # Print out the test command
rake spec:isolated  # Show which test files fail when run in isolation
rake spec:slow      # Show bottom 25 tests wrt time
```

This project uses [minitest](https://github.com/minitest/minitest).

### Linting

This project uses [rubocop](https://github.com/rubocop/rubocop).

```
$ bundle exec rubocop

Inspecting 4 files
....

4 files inspected, no offenses detected
```
