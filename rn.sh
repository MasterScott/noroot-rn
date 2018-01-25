#!/bin/bash
#https://facebook.github.io/react-native/docs/getting-started.html
site_node="https://nodejs.org"
tmp="$(mktemp -d)"
so="$(uname | tr '[:upper:]' '[:lower:]')"

if [ ! "$so" = "linux" ] && [ ! "$so" = "darwin" ]; then
    echo "Desculpe, sistema não suportado (no momento apenas Linux e macOS)."
    exit 0
fi

echo "Verificando versão mais recente disponível do node."
a=$(curl -sL "$site_node/en/download/")

version="v"$(echo $a | sed -e 's/.*Version: <strong>\([^<]*\)<.*/\1/')
echo 'Encontrado node '$version' para download.'


if [ "$FORCE_NODE" = "1" ] || [ -z "$(which npm 2>/dev/null)" ] || (( $(node --version | sed "s/v\(.\).*/\1/") > ${version:1:1} )); then
    echo "Baixando ..."
    cd "${tmp:?}"
    link="$site_node/dist/$version/node-$version-"$so"-x64.tar.xz"
    curl -L -# "$link" -o node.tar.xz
    tar -Jxf node.tar.xz
    rm -rf "${HOME:?}"/.node_noroot "${HOME:?}"/.npm
    mv "${tmp:?}"/node*/ "$HOME"/.node_noroot
    rm "${tmp:?}/node.tar.xz"
    echo 'export PATH='$HOME'/.node_noroot/bin/:"$PATH"' > $HOME/.noderc
    echo 'source '$HOME'/.noderc' >> $HOME/.bashrc
    source $HOME/.noderc
else
    echo 'Versão local já está atualizada.'
fi

echo -en '\n'

if [ "$so" = "darwin" ]; then #configuracao adicional para mac
    touch $HOME/.bash_profile
    if ( ! grep -q [.]bashrc "$HOME/.bash_profile" );then
        echo 'source '$HOME'/.bashrc' >> $HOME/.bash_profile
    fi
fi

if [ -z "$(which react-native 2>/dev/null)" ]; then
    echo 'Instalando React Native.'
    own=$(ls -lah $(which node) | awk '{print $3}')
    opt=''
    if [ ! "$own" = "$(whoami)" ]; then
        echo 'O node está instalado no diretório raiz, por isso é preciso de acesso root apenas para instalar o módulo ou execute nesse terminal: "export FORCE_NODE=1" e rode esse script novamente.'
        opt='sudo'
    fi
    eval "$opt npm install -g react-native-cli"
fi

if [ "$so" = "linux" ] && [ -z "$ANDROID_HOME" ]; then
    echo "Instalando Android SDK"
    cd "${tmp:?}"
    rm -rf 'noroot-android'; git clone https://github.com/wison27/noroot-android && cd noroot-android && bash ./android.sh sdk
    cd "${tmp:?}"
    rm -rf noroot-android
fi
echo "Tudo pronto!"
