#!/bin/bash

print_help()
{
  echo -e "$YELLOW"
  echo "╔═══════════════════════════════════════════════════════════════════╗"
  echo "║                         Muffinette Usage                          ║"
  echo "╠═══════════════════════════════════════════════════════════════════╣"
  echo "║ Each line you type composes the inputs sequence                   ║"
  echo "║ Just send an empty prompt to run the sequence                     ║"
  echo "║                                                                   ║"
  echo "║ Flags : (switches ON/OFF)                                         ║"
  echo "║ --valgrind         : Run a full valgrind test                     ║"
  echo "║ -- >             : Test redirection out                           ║"
  echo "║ -- >>            : Test redirection out with append               ║"
  echo "║ --print=flags   : Display flags status                            ║"
  echo "║                                                                   ║"
  echo "║ Display infos:                                                    ║"
  echo "║ --print=seq     : Print the inputs sequence in memory             ║"
  echo "║ --print=stdout  : Show minishell & bash stdout logs               ║"
  echo "║ --print=stderr  : Show minishell & bash stderr logs               ║"
  echo "║ --print=valgrind: Show valgrind logs                              ║"
  echo "║ --watch=stdout  : Open 2 terminals watching stdout logs           ║"
  echo "║ --watch=stderr  : Open 2 terminals watching stderr logs           ║"
  echo "║ --watch=valgrind: Open a terminal watching valgrind logs          ║"
  echo "║                                                                   ║"
  echo "║ Other Commands:                                                   ║"
  echo "║ --oops          : Remove last input from sequence in memory       ║"
  echo "║ --recipes       : Run recipes.sh                                  ║"
  echo "║                                                                   ║"
  echo "║ Or just type \"bye\" to quit                                        ║"
  echo "╚═══════════════════════════════════════════════════════════════════╝"
  echo -e "$NC"
}

print_stdout()
{
  echo -e "$YELLOW"
    echo "Bash STDOUT";
    echo "";
    cat log/bash_output;
    echo "";
    echo "------";
    echo "";
    echo "Minishell STDOUT";
    echo "";
    cat log/minishell_output;
    echo "";
    echo "Diff :";
    diff log/minishell_output log/bash_output
    echo -e "$NC"
}

print_stderr()
{
  echo -e "$YELLOW"
    echo "Bash STDERR";
    echo "";
    cat log/bash_stderr;
    echo "";
    echo "------";
    echo "";
    echo "Minishell STDERR";
    echo "";
    cat log/minishell_stderr;
    echo "";
    echo "Diff :";
    diff log/minishell_stderr log/bash_stderr
    echo -e "$NC"
}

# formate flags into arguments readable by taster.sh
set_flags()
{
  FLAGS=()
  if [[ $VALGRIND_FLAG == 1 ]]; then
    FLAGS+=("--leaks")
  fi
  if [[ $R_FLAG == 1 ]]; then
    FLAGS+=("-r")
  fi
  if [[ $AUTO_SAVE_FLAG == 1 ]]; then
    FLAGS+=("-as")
  fi
}

print_flags()
{
  echo -e "$YELLOW"
  if [[ $VALGRIND_FLAG == 1 ]]; then
    echo -e "valgrind : ON"
  else
    echo -e "valgrind : OFF"
  fi
  if [[ $R_FLAG == 1 ]]; then
    echo -e ">        : ON"
  else
    echo -e ">        : OFF"
  fi
  if [[ $AUTO_SAVE_FLAG == 1 ]]; then
    echo -e "auto-save : ON"
  else
    echo -e "auto-save : OFF"
  echo -e "$NC"
  fi
}

spatule()
{
  if [[ $1 == "bash" ]]; then
    kitty --detach bash -c "bash" &
  elif [[ $1 == "minishell" ]]; then
    kitty --detach bash -c "./minishell" &
  elif [[ $1 == "spatule" ]]; then
    kitty --detach bash -c "bash" &
    kitty --detach bash -c "./minishell" &
  fi
}

watch_logs() {
  case "$1" in
    "off") pgrep watch | tail -n +2 | xargs kill ;;
    "all")
      kitty --detach bash -c 'watch -n1 cat log/minishell_output'
      kitty --detach bash -c 'watch -n1 cat log/bash_output'
      kitty --detach bash -c 'watch -n1 cat log/minishell_stderr'
      kitty --detach bash -c 'watch -n1 cat log/bash_stderr'
      kitty --detach bash -c 'watch -n1 cat log/valgrind_output'
      kitty --detach bash -c 'watch -n1 cat log/outfile' ;;
    "stdout")
      kitty --detach bash -c 'watch -n1 cat log/minishell_output'
      kitty --detach bash -c 'watch -n1 cat log/bash_output' ;;
    "stderr")
      kitty --detach bash -c 'watch -n1 cat log/minishell_stderr'
      kitty --detach bash -c 'watch -n1 cat log/bash_stderr' ;;
    "valgrind")
      kitty --detach bash -c 'watch -n1 cat log/valgrind_output' ;;
    "outfile")
      kitty --detach bash -c 'watch -n1 cat log/outfile' ;;
  esac
}

