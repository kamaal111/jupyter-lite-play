set export

# List available commands
default:
    just --list --unsorted

# Install modules
install-modules:
    #!/bin/zsh

    . ~/.zshrc || true

    . .venv/bin/activate
    poetry install

# Prepare project to work with
prepare: setup-virtual-environment

# Bootstrap project
bootstrap: install-poetry prepare

# Set up dev container. This step runs after building the dev container
post-dev-container-create:
    just .devcontainer/post-create
    just bootstrap

[private]
install-poetry: poetry-key-bindings
    #!/bin/zsh

    . ~/.zshrc || true

    python -m pip install --user pipx
    python -m pipx ensurepath
    python -m pipx install poetry

[private]
setup-virtual-environment: install-modules
    #!/bin/zsh

    if [ ! -d .venv ]
    then
        python -m venv .venv
    fi

[private]
poetry-key-bindings:
    #!/bin/zsh

    mkdir -p $ZSH_CUSTOM/plugins/poetry

    if [[ -f $ZSH/oh-my-zsh.sh && ! -f $ZSH_CUSTOM/plugins/poetry/_poetry ]]
    then
        poetry completions zsh > $ZSH_CUSTOM/plugins/poetry/_poetry
    fi
