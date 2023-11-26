# branch-deploy

This software is under active development. This is not working software.

For more information, see [the initial roadmap](https://github.com/rick/branch-deploy/issues/4).

## Setup

```
$ script/bootstrap
```

## Running

```
$ bd --help
Usage: bd [options]
    -r, --repo REPO                  Repository passed to 'git clone' command on deployment host [REQUIRED]
    -b, --branch BRANCH              Branch name to deploy [REQUIRED]
        --host HOSTNAME              Target host for remote deployment [REQUIRED, or --local]
    -l, --local                      Deploy to the local host (default: false) [REQUIRED, or --host]
    -p, --path PATH                  Deployment path on target host [REQUIRED]
    -c, --changes                    Output changes for proposed deployment, do not deploy (default: true)
    -d, --deploy                     Perform deploy -- actually update files (default: false)
    -s, --ssh-options OPTIONS        Flags passed to the 'ssh' command for remote deployment (default: "")
    -t, --temp-path                  Base path for tempdir creation on deployment host (default: OS default)
    -v, --verbose                    Run verbosely
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


### Contributing

#### Creating repository fixtures

Since this tool works by cloning and deploying files from git repositories, our test suite relies on the ability to use git repositories with known properties. These "repo fixtures" are stored in this project's git repository as bare git repositories under [`spec/repo-fixtures`](spec/repo-fixtures/).

Fixtures generally suffer from the problem that they obscure their properties away from the test suite using them. Git repositories are even further opaque as special tooling (access to and knowledge of the `git` software) is needed to even examine them.

To aid in discoverability, we have a script in [`script/build-repo-fixtures`](script/build-repo-fixtures) which automates the process of creating usable bare git repository fixtures from readable shell scripts.

The process of creating a new repository fixture:

 - For a repository fixture named `new-feature`, create the template directory for the repo builder:

``` shell
$ script/new-repo-fixture new-feature

Creating new fixture path: /home/user/git/branch-deploy/spec/repo-builders/new-feature
Creating new build.sh: /home/user/git/branch-deploy/spec/repo-builders/new-feature/build.sh


Update /home/user/git/branch-deploy/spec/repo-builders/new-feature/build.sh with the commands to create your fixture repo.
Then run script/build-repo-fixtures to build the fixture repo.
```

 - Now edit the created builder script (`spec/repo-builders/new-feature/build.sh`) to add the commands to modify the git repository for the fixture.

 - Then, update the collection of bare git repositories that make up our usable fixtures:

``` shell
$ script/build-repo-fixtures

Building new-feature...
Removing old repo...
Initialized empty Git repository in /Users/play/git/rick/branch-deploy/spec/repo-fixtures/new-feature/
Cloning empty bare repo to working dir...
Cloning into 'working'...
warning: You appear to have cloned an empty repository.
done.
Running build.sh for new-feature...
+++ dirname -- /Users/play/git/rick/branch-deploy/spec/repo-builders/new-feature/build.sh
++ cd -- /Users/play/git/rick/branch-deploy/spec/repo-builders/new-feature
++ cd ..
++ pwd
+ ROOT_DIR=/Users/play/git/rick/branch-deploy/spec/repo-builders
+ git checkout -b new-feature
Switched to a new branch 'new-feature'
+ echo 'This is a README.md'
+ git add README.md
+ git commit -m 'Initial commit'
[new-feature (root-commit) 2f2a4a4] Initial commit
 1 file changed, 1 insertion(+)
 create mode 100644 README.md
Pushing to bare repo...
Enumerating objects: 3, done.
Counting objects: 100% (3/3), done.
Writing objects: 100% (3/3), 454 bytes | 454.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
To /Users/play/git/rick/branch-deploy/spec/repo-fixtures/new-feature
 * [new branch]      new-feature -> new-feature
Removing working dir...
```

 - If everything looks ok, then commit your changes:

```
$ git add spec/repo-builders/new-feature/
$ git add spec/repo-fixtures/new-feature/
$ git commit -m "Add new repo fixture 'new-feature'"
```
