# branch-deploy



## Setup

```
$ script/bootstrap
```

## Testing

```
script/test
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
