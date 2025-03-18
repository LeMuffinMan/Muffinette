#!/bin/bash

GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"

mkdir -p log

#comment to test non existing files
#to implement : a cmd in the CLI to tweak it 
rm log/outfile
touch log/outfile
touch log/infile

#uncomment and tweak yourself to test permissions
#to implement : a cmd in the CLI to tweak it 
# chmod 000 log/outfile
# chmod 000 log/infile

#Bye default, auto-save of failed tests logs is disable, switch this variable to 1 to enable it
AUTO_SAVE=0
# edit this variable to set your own failed test folder for auto save of logs
FAILED_TEST="failed_tests"

#if your STDOUT appears always KO for no reason, read the README and edit this line
PROMPT="$(echo -e "\n" | ./minishell | awk '{print $1}' | head -1)"

#comment these lines for a shorter output for quick tests or recipes.sh full tests
# echo -e "----------| Muffinette |----------"
# echo ""

# uncommenting following lines will always displays the sequence sent to test in head of the tastor output
# for arg in "$@"; do
#   if [[ "$arg" != "--leaks" && "$arg" != "-r" && "$arg" != "-ra" ]]; then
#     echo -e "$PROMPT $arg"
#   fi
# done
# echo ""

# comment these lines to test an empty infile, or customize for your taste
echo -e "Some people... some people like cupcakes, exclusively... 
while myself, I say, there is naught nor ought there be nothing
So exalted on the face of god's grey earth as that prince of foods... 
the muffin!

Franc Zappa - Muffin Man" > log/infile

if [[ -z $1 ]]; then
  echo -e "-----------------------------| Muffinette usage |-----------------------------\n"
  # echo "Each line you type compose the inputs sequence"
  # echo "Just send an empty prompt to run the sequence"
  # echo ""
  # echo "Consult log files with : --log=stdout --log=stderr --log=valgrind"
  # echo "Run your recipes with : --recipes"
  # echo ""
  # echo "Or just say \"bye\" to quit"
  # echo ""
  echo "No input received"
  exit 
fi

LEAKS_FLAG=0

if [[ $(find . -maxdepth 1 -type f -name minishell | wc -l) == 0 ]]; then
  echo "Error : no 'minishell' binary found in current working directory"
  exit 
fi

if [[ $1 == "--leaks" ]]; then
  LEAKS_FLAG=1;
  shift
fi

if [[ $1 == "--as" ]]; then
  if [[ $AUTO_SAVE == 1 ]]; then
    AUTO_SAVE=0
  else
    AUTO_SAVE=1
  fi
  shift
fi

if [[ $1 == "-r" ]]; then
  REDIR=1;
  shift
fi

# Johann working on ...
if [[ $1 == "--muffin" ]]; then
  echo "error: bakery not implemented yet"
  exit 
fi

# using \n as a separator to delimitate inputs in get_next_line / read of minishell / bash 
INPUT=$(printf "%s\n" "$@")

# using here_doc on minishell and bash to simulate sequences of inputs
# rederecting stdout  
./minishell << EOF 2> /dev/null > log/minishell_output 
$INPUT
EOF
#using $? to get last exit code
EXIT_CODE_P=$?

# Since minishell prints its prompt and input these lines clean it from its output file
# but first, PROMPT probably include special characters, sed can make it readable 
ESCAPED_PROMPT=$(printf "%s" "$PROMPT" | sed 's/[]\/$*.^[]/\\&/g')

# now we use sed to remove lines begnning with your minishell prompt
sed -i "/^$ESCAPED_PROMPT/d" log/minishell_output
# -i edit a file
# ^ lines beginning with 
# /d deletion

OLD_OUTFILE=$(<log/outfile)

MINISHELL_OUTFILE=$(<log/outfile)

echo "$OLD_OUTFILE" > log/outfile

# si option outfile non existing activee : 
# rm log/outfile

# We execute the same test on bash to have a reference 
bash << EOF 2> /dev/null > log/bash_output
$INPUT
EOF
EXIT_CODE_B=$?

BASH_OUTFILE=$(<log/outfile)

# same double test for STDERR 
./minishell << EOF 2> log/minishell_stderr > /dev/null
$INPUT
EOF

bash << EOF 2> log/bash_stderr > /dev/null
$INPUT
EOF

CLEAN=0
# some spicy stuff with valgrind
if [[ $LEAKS_FLAG == 1 ]]; then
valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --show-mismatched-frees=yes --track-fds=yes --trace-children=yes ./minishell << EOF 2>&1 | tee log/valgrind_output | grep -v "$PROMPT" > /dev/null
$INPUT
EOF

  LEAKS=0

  if grep -q "Process terminating with default action of signal 11 (SIGSEGV)" log/valgrind_output; then
    echo -e "${RED}SEGMENTATION FAULT !${NC}"
  fi

  if ! grep -q "LEAK SUMMARY" log/valgrind_output; then
    echo -e "${GREEN}NO LEAKS${NC}"
  else
    LEAKS=1
    echo -e "${RED}LEAKS !${NC}"
  fi

  # Here we will have all children reports, so we need to clean first the "expected outputs" for the line "ERROR SUMMARY" and if we still find a line "ERROR SUMMARY" it can be only errors
  NB_ERR=$(grep -v "ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)" log/valgrind_output | grep "ERROR SUMMARY: " | wc -l)
    if [[ $NB_ERR == 0 ]]; then
    echo -e "${GREEN}NO ERRORS${NC}"
  else
    LEAKS=1
    echo -e "${RED}$NB_ERR ERRORS !${NC}"
  fi

  if [[ ! $(grep -q "ERROR: Some processes were left running at exit." log/valgrind_output) ]]; then
    echo -e "${GREEN}NO ZOMBIE PROCESS${NC}"
  else
    LEAKS=1
    echo -e "${RED}ZOMBIE PROCESS !${NC}"
  fi

  # NOT VALID !!
  if [[ ! $(grep -v "FILE DESCRIPTORS: 3 open (3 std) at exit." log/valgrind_output | grep -q "FILES DESCRIPTORS") ]]; then
    echo -e "${GREEN}FD CLOSED${NC}"
  else
    LEAKS=1
    echo -e "${RED}FD OPEN AT EXIT !${NC}"
  fi

  if [[ $LEAKS == 1 ]]; then
    echo -e "Full valgrind log : \e]8;;file://$(pwd)/log/valgrind_output\alog/valgrind_output\e]8;;\a"
  fi
fi

CLEAN=$LEAKS

# print result for STDOUT
if diff -q log/minishell_output log/bash_output > /dev/null; then
  echo -e "STDOUT : ${GREEN}OK${NC}"
else
  echo -e "STDOUT : ${RED}KO${NC}"
  CLEAN=1
  diff log/minishell_output log/bash_output
fi

ERROR_MISSING=0

# checking stderr : the -i option ignore upper/lowercase difference. We assume you stick to bash formulation
# but you can still customize the second grep for your custom error message
if [[ $(grep -i "command not found" log/bash_stderr | wc -l) != $(grep -i "command not found" log/minishell_stderr | wc -l) ]]; then
  ERROR_MISSING=1
fi
if [[ $(grep -i "Permission denied" log/bash_stderr | wc -l) != $(grep -i "Permission denied" log/minishell_stderr | wc -l) ]]; then
  ERROR_MISSING=1
fi
if [[ $(grep -i "Is a directory" log/bash_stderr | wc -l) != $(grep -i "Is a directory" log/minishell_stderr | wc -l) ]]; then
  ERROR_MISSING=1
fi
if [[ $(grep -i "No such file or directory" log/bash_stderr | wc -l) != $(grep -i "No such file or directory" log/minishell_stderr | wc -l) ]]; then
  ERROR_MISSING=1
fi
# //too many files open

if [[ $ERROR_MISSING != 0 ]]; then
  CLEAN=1
fi

if [[ $ERROR_MISSING == 0 ]] ; then
  echo -e "STDERR : ${GREEN}OK${NC}"
else
  echo -e "STDERR : ${RED}KO${NC}"
  diff log/minishell_stderr log/bash_stderr
  CLEAN=1
fi

# comparing exit code
if [[ "$EXIT_CODE_P" -ne "$EXIT_CODE_B" ]]; then
  echo -e "EXIT : ${RED}KO${NC}"
  echo -e "bash : $EXIT_CODE_B\nminishell: $EXIT_CODE_P"
  CLEAN=1
else
  echo -e "EXIT : ${GREEN}OK${NC}"
fi

# Option redirection
if [[ $REDIR == 1 ]]; then
  if diff -q "$MINISHELL_OUTFILE" "$BASH_OUTFILE" > /dev/null 2>/dev/null; then
    echo -e "REDIR > : ${RED}KO${NC}"
    diff $MINISHELL_OUTFILE $BASH_OUTFILE
    $CLEAN = 1
  else
    echo -e "REDIR > : ${GREEN}OK${NC}"
  fi
    echo -e "minishell output : \n" > log/outfile
    echo -e $MINISHELL_OUTFILE >> log/outfile
    echo -e "--------------------------------" >> log/outfile
    echo -e "bash output : \n" >> log/outfile
    echo -e $BASH_OUTFILE >> log/outfile
fi

if [[ $CLEAN == 1 && $AUTO_SAVE == 1 ]]; then
  mkdir -p $FAILED_TEST
  TEST_FOLDER=$FAILED_TEST/$(printf "%s_" "$@")
  mkdir -p $TEST_FOLDER
  cp log/* $TEST_FOLDER
  echo "Failed test saved in $FAILED_TEST"
fi

# echo "" > log/outfile
