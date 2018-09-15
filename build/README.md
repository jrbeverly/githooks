# Build

You can build the project using the scripts available in the [`build/`](build/) directory. The `lint.sh` script will work to ensure that the scripts are compliant with the `/bin/sh` shell, enabling it to work on most git environments. You can do this with the following:

```bash
sh build/lint.sh
```

Or you can use the docker based script, `docker-lint.sh` if you do not have the necessary commands installed locally on your machine. You can do this with the following:

```bash
sh build/docker-lint.sh
```

## Packaging

You can package the git hooks into a single archive using the `package.sh` script. You can do this with the following:

```bash
sh build/package.sh
```

You can use the packaged hooks to quickly install the hooks into a git repository. The packaged hooks are available under `out/githooks*.zip`.

## Tests

All scripts in the repository use [Bash Automated Testing System (Bats)](https://github.com/sstephenson/bats) for testing. All scripts have tests associated with them in the `tests/` directory. These scripts are responsible for verifying the execution behaviour of any of the hooks in the repository. To run all the tests in the `tests/` directory, you can do this with the following:

```bash
sh run.sh
```

Or you can use the docker based script, `docker-run.sh` if you do not have the necessary commands installed locally on your machine. You can do this with the following:

```bash
sh docker-run.sh
```