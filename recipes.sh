
#!/bin/bash

YELLOW='\033[1;33m'

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
# recipes "-r" "echo -e '5g vanilla' >> log/outfile"

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
#Manual tests
# 
# run a random test manualy :
# cat recipes.sh | grep "recipes \"--leaks\"" | shuf -n 1 | sed "s/recipes \"--leaks\" //g" | sed "s/\"//g"
#
# mkdir -p a/b/c; cd a/b/c; rm -rf ../../a; pwd; cd ..; pwd; cd ..; pwd; cd ..; pwd;
# exit
# SIGNAUX
# des tabulatations CTRL + M et Tab ? demander a Sammy
# des espaces dans le prompt
# minishell dans minishell
# recipes "cd log" "pwd" "mkdir -p test/b/c" "cd test/b/c" "pwd" "cd ../../../" "pwd" "rm -rf test" 
#
# combo : pipes redirs && epands
echo 
echo "======= cmd ======="
echo 
recipes "whoami"
recipes "uname -a"
recipes "uname -m -n -r -s"
recipes "/usr/bin/uname -a"
recipes "non_existing_cmd"
# pour lancer une commande par son chemin relatif qui serait dans le cwd, on devrait faire ./ !
# recipes "/sbin/sudo"
# ------------echo------------
echo
echo "======= echo ======="
echo
recipes "echo" 
recipes "echo -n" 
recipes "echo -n hello" 
recipes "echo -n -n -n " 
recipes "echo -n -n hello" 
recipes "echo hello" 
recipes "echo hello world" 
# ------------exit------------
echo
echo "======= exit ======="
echo
# echo "This test must be done manualy, STDOUT always differs because of bash non interactive behaviour"
# recipes "exit" 
recipes "exit 256" 
recipes "exit 256999999999999999999999999999999999999999999999999999999999999999999999999999999999999999" 
recipes "exit 42" 
recipes "exit -1" 
recipes "exit -256" 
recipes "exit 1 2" 
recipes "exit not_numeric_argument" 
recipes "exit 1 not_numeric_argument" 
# ------------pwd------------
echo
echo "======= pwd ======="
echo
recipes "pwd" 
recipes "pwd with args" 
# ------------cd------------
echo
echo "======= cd ======="
echo
recipes "cd" 
recipes "cd /" "pwd" "cd /home" "pwd" "cd /home/oelleaum" "pwd" 
recipes "cd /non_existing_folder"
recipes "cd /egerg" 
recipes "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" 
recipes "pwd" "cd .." "pwd" 
recipes "cd .." "pwd" "cd " "pwd" 
recipes "cd log/ls_cpy" 
recipes "cd fwef feww" 
recipes "cd .." "cd -" 
recipes "cd -"
recipes "cd -" "cd -" 
recipes "cd .." "pwd" "cd -" "pwd" "cd .." "pwd" "cd -" "pwd" 
recipes "cd /home" "cd -" "cd -" 

echo 
echo "======= Pipes ======="
echo 
recipes "whoami | cat"
recipes "uname -a | cat"
echo
echo -e "${YELLOW}grep without arg fails and prints its error, but not in pipe !$NC"
recipes "whoami | grep"
echo -e "${YELLOW}cat -e doesn't work ?$NC"
recipes "whoami | cat | cat -e | cat | cat | cat"
echo -e "${YELLOW}BASH gere une syntax error ! : bash: syntax error near unexpected token \`|\'$NC"
recipes "|"
recipes "| wc -l"
echo -e "${YELLOW}bash opens a here_doc to complete the pipeline$NC"
recipes "uname -a | cat |"

echo 
echo "======= Redirections ======="
echo 
echo
echo -e "${YELLOW}syntax$NC"
recipes "-r" "> log/outfile"
echo -e "${YELLOW}bash: syntax error near unexpected token \`newline\'$NC"
recipes "-r" ">"
recipes "-r" "whoami >"
recipes "-r" "uname -a >>"
echo
echo -e "${YELLOW}permissions$NC"
recipes "-r" "whoami > log"
recipes "-r" "whoami > log/file_without_permissions"
recipes "-r" "whoami >> log/file_without_permissions"
recipes "-r" "whoami < log/file_without_permissions"
recipes "-r" "< log/file_without_permissions whoami"
echo
echo -e "${YELLOW}trunc$NC"
recipes "-r" "whoami > log/outfile"
echo
echo -e "${YELLOW}infile$NC"
recipes "-r" "< log/infile cat"
recipes "-r" "cat < log/infile"
recipes "-r" "< log/infile"
echo
echo -e "${YELLOW}append$NC"
recipes "-r" "whoami >> log/outfile"
recipes "-r" "whoami > log/outfile" "whoami >> log/outfile"
echo
echo -e "${YELLOW}multiple redirections$NC"
recipes "-r" "whoami > log/outfile" "whoami >> log/outfile"
recipes "-r" "< log/non_existing_file cat < log/infile"
recipes "-r" "< log/file_without_permissions cat < log/infile"
recipes "-r" "< log/infile cat < log/non_existing_file"
recipes "-r" "< log/infile cat < log/file_without_permissions"
recipes "-r" "< log/outfile < log/file1 < log/infile cat"
recipes "-r" "< log/outfile < log/non_existing_file < log/infile cat"
recipes "-r" "< log/non_existing_file < log/outfile < log/infile cat"
recipes "-r" "< log/file_without_permissions < log/outfile < log/infile cat"
recipes "-r" "< log/outfile < log/file_without_permissions < log/infile cat"
echo
recipes "-r" "whoami > log/file1 > log/file2 > log/outfile" "whoami > log/file1 > log/file2 >> log/outfile"
recipes "-r" "whoami > log/file1 > log/file_without_permissions > log/outfile" "whoami > log/file1 > log/file2 >> log/outfile"
recipes "-r" "whoami > log/file1 > log/file_without_permissions > log/outfile" "whoami > log/file_without_permissions > log/file2 >> log/outfile"
echo
recipes "-r" "< log/infile cat > log/outfile"
recipes "-r" "cat < log/infile > log/outfile"

# echo 
# echo "Environnement"
# echo 
#
# echo 
# echo "&& || ( )"
# echo 
#
echo 
echo "COMBO"
echo 
recipes "-r" "< log/outfile < log/file_without_permissions < log/infile cat | cat | cat | cat | wc -l | cat > log/file1 > log/outfile"
recipes "-r" "< log/infile cat | cat > log/outfile | cat | cat | wc -l | cat > log/file1"
recipes "-r" "< log/file1 cat | cat | < log/infile cat | cat | wc -l | cat > log/file1"
recipes "-r" "< log/infile cat | cat | < log/infile cat | cat | wc -l | cat > log/outfile"
#
# recipes "cat < log/infile > log/outfile | wc -l"
# recipes "whoami | cat | cat | cat < log/infile > log/outfile"
# recipes "whoami | cat < log/infile > log/outfile"
# echo 
# echo "Here_doc"
# echo 
#
# echo 
# echo "Expands"
# echo 
