# App

This is a whole ass application.

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

Follow the setup instructions in the next two sections.
- [Backend Service](backend/README.md)
- [Infrastructure Provisioning](infrastructure/README.md)