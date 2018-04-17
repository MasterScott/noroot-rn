#!/bin/bash
#https://facebook.github.io/react-native/docs/getting-started.html
tmp="$(mktemp -d)"

if [ "$(id -u)" = "0" ];then
    echo "Não é recomendado executar esse script como root. Tente rodá-lo com um usuário comum ou comente a linha indicada no script se quiser forçar isso."
    exit 0 #essa linha
fi

cd "${tmp:?}"
git clone https://github.com/wison27/noroot-node && cd noroot-node && bash node.sh
rm -rf "${tmp:?}"/noroot-node
source $HOME/.noderc

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
exec -l bash
