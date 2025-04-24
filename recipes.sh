
#!/bin/bash

mkdir -p log

source cookware.sh

TIMEOUT_DURATION="${TIMEOUT_DURATION:-5}"

# recipes "pwd" "cd" "pwd"

#so make sure to gather arguments
# recipes "ls -l" "cd .." "ls -l"

#test pipe as an argument 
# recipes "ls -l | wc -l" "pwd"

#or even a redirection, but dont forget the flag as first argument !
# recipes "-r" "echo -e '180g milk' > log/outfile" 

#always put the --leaks as flag first !
# recipes "--leaks" "-r" "echo -e '5g vanilla' >> log/outfile"

#to use quotes, use \" or ' or \' ... 
# recipes "echo -e \"two eggs\"" "echo -e '100g sugar'" 

#test by yourself !
# recipes "your" "own"
# recipes "t" "e" "s" "t" "S"

# You can either add your own tests here manualy, or you can use the --add-recipe command, 
# the sequence in buffer will be added after this linesm ready to run with ./recipes.sh or --recipes in CLI. 

# I recommend to keep this file clean and organized by sorting tests in categories here 
# Comments are your friends !
# recipes "pwd" "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" "cd .." 
#
# ==========BUILT-IN==========
# ------------echo------------
echo -e "${RED}WARNING ! TIME OUT NOT DETECTED IN RECIPES.SH !!$NC"
echo "echo"
echo
recipes "--leaks" "echo" 
recipes "--leaks" "echo -n" 
recipes "--leaks" "echo -n hello" 
recipes "--leaks" "echo -n -n -n " 
recipes "--leaks" "echo -n -n hello" 
recipes "--leaks" "echo hello" 
recipes "--leaks" "echo hello world" 
# ------------exit------------
echo
echo "exit"
echo
recipes "--leaks" "exit" 
echo "In interactive mode, bash doesn't print \"exit\" in STDOUT, this test must be done manualy"
recipes "--leaks" "exit 256" 
recipes "--leaks" "exit 256999999999999999999999999999999999999999999999999999999999999999999999999999999999999999" 
recipes "--leaks" "exit 42" 
recipes "--leaks" "exit -1" 
recipes "--leaks" "exit -256" 
recipes "--leaks" "exit 1 2" 
recipes "--leaks" "exit not_numeric_argument" 
recipes "--leaks" "exit 1 not_numeric_argument" 
# ------------pwd------------
echo
echo "pwd"
echo
recipes "--leaks" "pwd" 
recipes "--leaks" "pwd with args" 
# ------------cd------------
echo
echo "cd"
echo
recipes "--leaks" "cd" 
recipes "--leaks" "cd /" "pwd" "cd /home" "pwd" "cd /home/oelleaum" "pwd" 
recipes "--leaks" "cd /non_existing_folder"
recipes "--leaks" "cd /egerg" 
recipes "--leaks" "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" 
recipes "--leaks" "cd .." "pwd" "cd readmetest" "pwd" 
recipes "--leaks" "pwd" "cd .." 
recipes "--leaks" "cd .." "cd " 
recipes "--leaks" "cd minishell" 
recipes "--leaks" "cd fwef feww" 
recipes "cd .." "cd -" 
recipes "cd -" 
recipes "cd .." "pwd" "cd -" "pwd" "cd .." "pwd" "cd -" "pwd" 

recipes "cd -" "cd -" 
