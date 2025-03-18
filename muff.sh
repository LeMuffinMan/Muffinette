#!/bin/bash

# clone le repo dans le repo minishell
# faire muff.sh --install depuis le repo
#   ecris dans un fichier le PATH vers muffinette.sh
# condition pour bash ou zshrc
# ajouter un man
# et un alias pour muffin man

MUFF_PATH=$PWD/muffinette.sh
PROJECT_PATH=$(basename $PWD)

if [[ $(grep -q "alias muff=" $HOME/.zshrc) ]]; then
  echo "alias muff already exists"
  exit 
fi


if [[ $1 = "--install" ]]; then
  cp $HOME/.zshrc $HOME/.zshrc.bak
  echo -e "alias muff='$PWD/muffinette.sh'" >> $HOME/.zshrc
  cd .. && make 
  # voir si on reste pas bloque 
  if [[ -z "minishell" $PROJECT_PATH ]]; then
    PROJECT_PATH=""
    read "PATH to your minishell project folder :" PROJECT_PATH
    # sed ce script pour modifier le contenu de PROJECT_PATH
  fi
  exit
fi


if [[ $1 == "--bake" ]]; then
  cd $PROJECT_PATH && make
fi

cp $PROJECT_PATH/minishell $(dirname $MUFF_PATH)

if [[ $1 == "--watch" ]] || [[ $1 == "--recipes" ]]; then
  $MUFF_PATH $1
else
  $MUFF_PATH
fi


