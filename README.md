# Python-Template

Python module template

# Requirement

* pipenv

  Installation pipenv: https://github.com/pypa/pipenv#installation

# Developnent

## Reproduce environment

* Install environment by `Pipfile`:

  Install specified packages latest version, if it not indicate version.
  Therefore, the reproduced environment is not always the same.

  ```shell
  $ make init
  ```

* Install environment by `Pipfile.lock`:

  Install specified packages same version.
  Use this command when the environment created by `make init` does not work.

  ```shell
  make syncinit
  ```

## Usage of evelopment tool

Run unit test:

  ```shell
  make test
  ```

Format check and type-check:

  ```shell
  make check
  ```

Code formatting by black:

  ```shell
  make format
  ```

Generate or update document by sphinx:

  ```shell
  make gendoc
  ```

# License

MIT
