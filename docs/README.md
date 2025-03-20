# Good Ass App

This is a whole ass, mono-repo application (w/ no face).  It's got a database and tests and a bunch of other little goodly doodlies.

## Set up

You can't commit to this repo, so after you `git clone git@github.com:bagpyp/app.git`,
Go [create your own repo](https://github.com/new) and take note of its ssh url, which looks like 
git@github.com:<YOU>/<IT>.git

```shell
cd app
rm -fr .git
git init
git add .
git commit -m 'initial commit'
git remote add origin git@github.com:<YOU>/<IT>.git
git push -u origin main
```

## Keep Up the Good Work

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

Verify that asdf has installed the dependencies and set their current versions correctly:
```shell
❯ asdf current
```

The above command should output ths following:
```plaintext
poetry          2.1.0           /path/to/this/.tool-versions
python          3.13.2          /path/to/this/.tool-versions
terraform       1.11.2          /path/to/this/.tool-versions
```

If it doesn't, you may need to add the following line to your `~/.zshrc` or `~/.bashrc` file:
```shell
# asdf setup
. $(brew --prefix asdf)/libexec/asdf.sh
```

## Can't Stop Won't Stop Don't Stop Setting Up

Follow the setup instructions in the following order.

- [Backend Service](../backend/README.md)
- [Infrastructure Provisioning](../infrastructure/README.md)
- [Continuous Integration & Continuous Development (CI/CD)](./ci-cd.md)
