# App

This is a whole ass, mono-repo application.  It's got a database and tests and a bunch of other little goodies.

## Set up

If you haven't already, install `brew`:
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then, cd into this repo and install the dependencies from `.tool-versions` using `asdf` by running the following commands:
```shell
brew install asdf
asdf plugin add python
asdf plugin add poetry
asdf plugin add terraform
asdf install
```

## Contents

Follow the setup instructions in the following order.
- [Backend Service](../backend/README.md)
- [Infrastructure Provisioning](../infrastructure/README.md)
- [Continuous Integration & Continuous Development (CI/CD)](./ci-cd.md)
