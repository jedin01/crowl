#!/usr/bin/env bash

SCRIPT_PATH="$(pwd)/crowl.sh"

USER_SHELL=$(basename "$SHELL")
case "$USER_SHELL" in
    bash)
        SHELL_RC="$HOME/.bashrc"
        ALIAS_CMD="alias crowl='$SCRIPT_PATH'"
        REFRESH_CMD="source $SHELL_RC"
        ;;
    zsh)
        SHELL_RC="$HOME/.zshrc"
        ALIAS_CMD="alias crowl='$SCRIPT_PATH'"
        REFRESH_CMD="source $SHELL_RC"
        ;;
    fish)
        SHELL_RC="$HOME/.config/fish/config.fish"
        ALIAS_CMD="alias crowl '$SCRIPT_PATH'"
        REFRESH_CMD="fish -c 'source $SHELL_RC'"
        ;;
    *)
        echo "Shell não suportado automaticamente."
        echo "Informe o arquivo de configuração (ex: ~/.bashrc):"
        read -r SHELL_RC
        echo "Informe o comando de alias que deseja adicionar (ex: alias crowl='$SCRIPT_PATH'):"
        read -r ALIAS_CMD
        REFRESH_CMD="source $SHELL_RC"
        ;;
esac

echo "Deseja adicionar o alias 'crowl' no arquivo $SHELL_RC? [s/N]"
read -r CONFIRM

if [[ "$CONFIRM" =~ ^[Ss]$ ]]; then
    if ! grep -Fxq "$ALIAS_CMD" "$SHELL_RC"; then
        echo "$ALIAS_CMD" >> "$SHELL_RC"
        echo "Alias 'crowl' adicionado em $SHELL_RC"
    else
        echo "Alias 'crowl' já existe em $SHELL_RC"
    fi

    eval "$REFRESH_CMD"
    echo "Alias 'crowl' ativo"
    echo "Teste agora digitando: 'crowl'"
else
    echo "Alias não adicionado."
fi

