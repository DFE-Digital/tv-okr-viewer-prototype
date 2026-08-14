# App

Replace this with a description of what this service does and who it's for.

## Getting started

### Prerequisites

Make sure you have the following installed:

- [asdf](https://asdf-vm.com/) with Ruby and Node plugins
- [Postgres](https://www.postgresql.org/)

The required versions are:
- Ruby: 4.0.2 (see `.ruby-version`)
- Node: 24.14.0 (see `package.json` under `engines.node`)
- Yarn: 4.9.2 (see `package.json` under `packageManager`)

### Setup

```bash
# Clone the repository
git clone <repository-url>
cd app

# Install Ruby and Node versions
asdf install

# Setup the application
bin/setup
```

`bin/setup` will install gems, install JavaScript packages, set up the database, and start the Rails development server. See the script to understand what it runs.

## Running the application locally

```bash
# Start the development server
bin/setup

# Run tests and linters
bin/ci
```

See `bin/setup` and `bin/ci` scripts to understand what gets run each time.

## Making changes

After pulling changes from your branch:

```bash
bin/setup
```

This will update gems, JavaScript packages, run any pending migrations, and start the dev server.

### Linting

To run the linters:

```bash
bin/rubocop
```

Autofix linting errors:

```bash
bin/rubocop --autocorrect-all
```
### Intellisense

[solargraph](https://github.com/castwide/solargraph) is bundled as part of the
development dependencies. You need to [set it up for your
editor](https://github.com/castwide/solargraph#using-solargraph), and then run
this command to index your local bundle (re-run if/when we install new
dependencies and you want completion):

```sh
bundle exec yard gems
```

You'll also need to configure your editor's `solargraph` plugin to
`useBundler`:

```diff
+  "solargraph.useBundler": true,
```
## How the application works

We keep track of architecture decisions in [Architecture Decision Records
(ADRs)](/adr/).

We use `rladr` to generate the boilerplate for new records:

```bash
bundle exec rladr new title
```
