#!/bin/bash
#https://facebook.github.io/react-native/docs/getting-started.html
tmp="/tmp"
so="$(uname)"

if [ ! "$so" = "Linux" ] && [ ! "$so" = "Darwin" ]; then
    echo "Desculpe, sistema não suportado."
    exit 0
fi

#if [ -z "$(which npm 2>/dev/null)" ]; then
echo "Baixando node e npm."
cd "${tmp:?}"
if [ "$so" = "Linux" ]; then
    curl -L -# https://nodejs.org/dist/v6.11.0/node-v6.11.0-linux-x64.tar.xz -o node.tar.xz
else
    curl -L -# https://nodejs.org/dist/v6.11.0/node-v6.11.0-darwin-x64.tar.xz -o node.tar.xz
fi
tar -Jxf node.tar.xz
rm -rf "${HOME:?}"/.node4ns "${HOME:?}"/.npm
mv "${tmp:?}"/node*/ "$HOME"/.node4ns
rm "${tmp:?}/node.tar.xz"
echo 'export PATH='$HOME'/.node4ns/bin/:"$PATH"' > $HOME/.noderc
echo 'source '$HOME'/.noderc' >> $HOME/.bashrc
source $HOME/.noderc

#fi

if [ "$so" = "Darwin" ]; then #configuracao adicional para mac
    touch $HOME/.bash_profile
    if ( ! grep -q [.]bashrc "$HOME/.bash_profile" );then
        echo 'source '$HOME'/.bashrc' >> $HOME/.bash_profile
    fi
fi

#if [ -z "$(which react-native 2>/dev/null)" ]; then
echo 'Instalando React Native.'
npm install -g react-native-cli
#fi

if [ "$so" = "Linux" ] && [ -z "$ANDROID_HOME" ] && [ ! -e "$HOME/Android" ]; then
    echo "Instalando Android SDK"
    git clone https://github.com/wison27/noroot-android && cd noroot-android && bash ./android.sh sdk
fi
echo "Tudo pronto!"
