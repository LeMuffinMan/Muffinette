#!/bin/bash

# To customize this CLI yourself, see below how to edits the cmds or to implement your own command

# I used yellow color to visualy separate the output of muffinette.sh and tastor.sh
# tastor.sh prints in white, muffinette.sh prints in yellow
YELLOW="\033[0;33m"
NC="\033[0m"

mkdir -p log
touch log/outfile
touch log/minishell_output
touch log/bash_output
touch log/minishell_stderr
touch log/bash_stderr
touch log/valgrind_output

# Cookware has functions to display infos and set flags
# customize yourself infos displayed by editing or adding a function in cookware.sh
source cookware.sh

# theses variables set autosave, valgrind check and redirection check to disable by default
# just switch it to 1 to enable it by default, or use CLI cmds
AUTO_SAVE_FLAG=0
VALGRIND_FLAG=0
R_FLAG=0

if [[ $1 == "--watch=all" ]]; then
  watch_logs "${1#--watch=}"
# Pierre tail --follow : voir pour ecraser le dernier log
  exit
fi

echo -en "${YELLOW}[Muffinette]\$ ${NC}"

ARGS=()

while IFS= read -r INPUT; do
# This sets the Internal Field Separator (IFS) to an empty value, and get from STDIN a string for $INPUT variable.
# By default, IFS is set to whitespace (space, tab, newline), which causes read to split input into multiple words.
# This allow user to use Muffinette prompt exactly the same way he would use bash or minishell prompt, 
# no need to use \ for special characters, or quotes to delimitate arguments 
# using switch cases makes the code cleaner more lisible and easier to edit
  case "$INPUT" in
    # the ! tests are meant to lead tests quickly, loading last sequence back and executing it with an additional option 
    # ! after a test, load back last sequence in buffer
    "!")
      ARGS=$(printf "%s\n" "${LAST_SEQ[@]}")
      printf "${YELLOW}%s\n" "${LAST_SEQ[@]}"
      ;;
    # !! after a test, load back and execute last sequence
    "!!")
      set_flags
      ./taster.sh "${FLAGS[@]}" "${LAST_SEQ[@]}" 2> /dev/null
      ;;
    # !! after a test, load back and execute last sequence with a valgrind test
    "!v")
      VALGRIND_FLAG=1
      set_flags
      ./taster.sh "${FLAGS[@]}" "${LAST_SEQ[@]}" 2> /dev/null
      VALGRIND_FLAG=0
      ;;
    # !! after a test, load back and execute last sequence with a redirection test
    "!>")
      R_FLAG=1
      set_flags
      ./taster.sh "${FLAGS[@]}" "${LAST_SEQ[@]}" 2> /dev/null
      R_FLAG=0
      ;;
    # -h --help : dispaly help
    "-h"|"--help")
      print_help
      ;;
    # -bye : quit and clean
    "bye")
      # pgrep watch | tail -n +2 | xargs kill 2> /dev/null
      if [[ $(pgrep -q terminator) ]]; then
        pgrep terminator | xargs kill
      fi
      # rm -rd log 2> /dev/null
      exit 0
      ;;
    # --watch= : new tty with watch on a log file option
    # see README for details
    "--auto-save")
      if [[ $AUTO_SAVE_FLAG == 1 ]]; then
        AUTO_SAVE_FLAG=0
      else
        AUTO_SAVE_FLAG=1
      fi
      ;;
    "--watch="*)
      watch_logs "${INPUT#--watch=}"
      ;;
    # --print=* : print log file
    "--print=stdout")
      print_stdout
      ;;
    "--print=stderr")
      print_stderr
      ;;
    "--print=valgrind")
      cat log/valgrind_output
      ;;
    "--print=outfile")
      cat log/outfile
      ;;
      # Valgrind test switch
    "--valgrind"|"-vg")
      VALGRIND_FLAG=$((1 - VALGRIND_FLAG))
      echo -e "${YELLOW}valgrind_flag = $( [[ $VALGRIND_FLAG -eq 1 ]] && echo ON || echo OFF )${NC}"
      ;;
      # Redirection test switch
    "- >")
      R_FLAG=$((1 - R_FLAG))
      echo -e "${YELLOW}> = $( [[ $R_FLAG -eq 1 ]] && echo ON || echo OFF )${NC}"
      ;;
      # Display flags status
    "--print=flags"|"-pf")
      print_flags
      ;;
      # Display sequence in buffer
    "--print=seq"|"-ps")
      printf "${YELLOW}%s\n" "${ARGS[@]}"
      echo -e "$NC"
      ;;
      # Display last sequence used
    "--print=last-seq"|"-pls")
      printf "${YELLOW}%s\n" "${LAST_SEQ[@]}"
      echo -e "$NC"
      ;;
      # run muffinette.sh with your custom tests in recipes.sh
    "--recipes")
      kitty --detach bash -c './recipes.sh; read'
      ;;
      # open a new tty with a bash shell
    "--bash")
      spatule "bash"
      ;;
      # open a new tty with a minishell shell
    "--minishell")
      spatule "minishell"
      ;;
      # open 2 tty with bash and minishell shells
    "--spatule")
      spatule "spatule"
      ;;
      # remove last input in sequence
    "--oops"|"-o")
      if [[ ${#ARGS[@]} -gt 0 ]]; then
        echo -e "${YELLOW}removed : ${ARGS[-1]}${NC}"
        unset 'ARGS[-1]'
      fi
      ;;
      # add your custom cmd here
      #"--cmd")
      #<execution>
      #<execution>
      #;;
      # ...
      # DO NOT override following cases ! "" and * must be the lasts
      #
      # no input : if the buffer is not empty : the sequence is sent to taster.sh
      # if the buffer is empy : print a helper
    "")
      if [[ ${#ARGS[@]} -eq 0 ]]; then
        echo -e "${YELLOW}No inputs recorded"
        echo ""
        echo "use -h or --help for usage informations"
        print_flags
      else
        set_flags
        ./taster.sh "${FLAGS[@]}" "${ARGS[@]}" 2> /dev/null
        LAST_SEQ=("${ARGS[@]}")
        ARGS=()
      fi
      ;;
      # Any other inputs will be considered as an input to add to the sequence to test
    *)
      ARGS+=("$INPUT")
      ;;
  esac
  echo -en "${YELLOW}[Muffinette]\$ ${NC}"
done

