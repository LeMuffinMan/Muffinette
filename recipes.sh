
#!/bin/bash

YELLOW='\033[1;33m'

mkdir -p log

source cookware.sh

TIMEOUT_DURATION="${TIMEOUT_DURATION:-5}"

# recipes "--leaks" "pwd" "cd" "pwd"

#so make sure to gather arguments
# recipes "--leaks" "ls -l" "cd .." "ls -l"

#test pipe as an argument 
# recipes "--leaks" "ls -l | wc -l" "pwd"

#or even a redirection, but dont forget the flag as first argument !
# recipes "--leaks" "-r" "echo -e '180g milk' > log/outfile" 

#always put the --leaks as flag first !
# recipes "--leaks" "-r" "echo -e '5g vanilla' >> log/outfile"

#to use quotes, use \" or ' or \' ... 
# recipes "--leaks" "echo -e \"two eggs\"" "echo -e '100g sugar'" 

#test by yourself !
# recipes "--leaks" "your" "own"
# recipes "--leaks" "t" "e" "s" "t" "S"

# You can either add your own tests here manualy, or you can use the --add-recipe command, 
# the sequence in buffer will be added after this linesm ready to run with ./recipes "--leaks".sh or --recipes "--leaks" in CLI. 

# I recommend to keep this file clean and organized by sorting tests in categories here 
# Comments are your friends !
# recipes "--leaks" "pwd" "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" "cd .." 
#
#Manual tests
# 
# run a random test manualy :
# cat recipes "--leaks".sh | grep "recipes "--leaks" \"--leaks\"" | shuf -n 1 | sed "s/recipes "--leaks" \"--leaks\" //g" | sed "s/\"//g"
#
# mkdir -p a/b/c; cd a/b/c; rm -rf ../../a; pwd; cd ..; pwd; cd ..; pwd; cd ..; pwd;
# exit
# SIGNAUX
# des tabulatations CTRL + M et Tab ? demander a Sammy
# des espaces dans le prompt
# minishell dans minishell
# recipes "--leaks" "cd log" "pwd" "mkdir -p test/b/c" "cd test/b/c" "pwd" "cd ../../../" "pwd" "rm -rf test" 
#
# combo : pipes redirs && epands
echo 
echo "======= cmd ======="
echo 
recipes "--leaks" "whoami"
recipes "--leaks" "uname -a"
recipes "--leaks" "uname -m -n -r -s"
recipes "--leaks" "/usr/bin/uname -a"
recipes "--leaks" "non_existing_cmd"
# pour lancer une commande par son chemin relatif qui serait dans le cwd, on devrait faire ./ !
# recipes "--leaks" "/sbin/sudo"
# ------------echo------------
echo
echo "======= echo ======="
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
echo "======= exit ======="
echo
# echo "This test must be done manualy, STDOUT always differs because of bash non interactive behaviour"
# recipes "--leaks" "exit" 
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
echo "======= pwd ======="
echo
recipes "--leaks" "pwd" 
recipes "--leaks" "pwd with args" 
# ------------cd------------
echo
echo "======= cd ======="
echo
recipes "--leaks" "cd" 
recipes "--leaks" "cd /" "pwd" "cd /home" "pwd" "cd /home/oelleaum" "pwd" 
recipes "--leaks" "cd /non_existing_folder"
recipes "--leaks" "cd /egerg" 
recipes "--leaks" "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" 
recipes "--leaks" "pwd" "cd .." "pwd" 
recipes "--leaks" "cd .." "pwd" "cd " "pwd" 
recipes "--leaks" "cd log/ls_cpy" 
recipes "--leaks" "cd fwef feww" 
recipes "--leaks" "cd .." "cd -" 
recipes "--leaks" "cd -"
recipes "--leaks" "cd -" "cd -" 
recipes "--leaks" "cd .." "pwd" "cd -" "pwd" "cd .." "pwd" "cd -" "pwd" 
recipes "--leaks" "cd /home" "cd -" "cd -" 

echo 
echo "======= Pipes ======="
echo 
recipes "--leaks" "whoami | cat"
recipes "--leaks" "uname -a | cat"
echo
echo -e "${YELLOW}grep without arg fails and prints its error, but not in pipe !$NC"
recipes "--leaks" "whoami | grep"
echo -e "${YELLOW}cat -e doesn't work ?$NC"
recipes "--leaks" "whoami | cat | cat -e | cat | cat | cat"
echo -e "${YELLOW}BASH gere une syntax error ! : bash: syntax error near unexpected token \`|\'$NC"
recipes "--leaks" "|"
recipes "--leaks" "| wc -l"
echo -e "${YELLOW}bash opens a here_doc to complete the pipeline$NC"
recipes "--leaks" "uname -a | cat |"

echo 
echo "======= Redirections ======="
echo 
echo
echo -e "${YELLOW}syntax$NC"
recipes "--leaks" "-r" "> log/outfile"
echo -e "${YELLOW}bash: syntax error near unexpected token \`newline\'$NC"
recipes "--leaks" "-r" ">"
recipes "--leaks" "-r" "whoami >"
recipes "--leaks" "-r" "uname -a >>"
echo
echo -e "${YELLOW}permissions$NC"
recipes "--leaks" "-r" "whoami > log"
recipes "--leaks" "-r" "whoami > log/file_without_permissions"
recipes "--leaks" "-r" "whoami >> log/file_without_permissions"
recipes "--leaks" "-r" "whoami < log/file_without_permissions"
recipes "--leaks" "-r" "< log/file_without_permissions whoami"
echo
echo -e "${YELLOW}trunc$NC"
recipes "--leaks" "-r" "whoami > log/outfile"
echo
echo -e "${YELLOW}infile$NC"
recipes "--leaks" "-r" "< log/infile cat"
recipes "--leaks" "-r" "cat < log/infile"
recipes "--leaks" "-r" "< log/infile"
echo
echo -e "${YELLOW}append$NC"
recipes "--leaks" "-r" "whoami >> log/outfile"
recipes "--leaks" "-r" "whoami > log/outfile" "whoami >> log/outfile"
echo
echo -e "${YELLOW}multiple redirections$NC"
recipes "--leaks" "-r" "whoami > log/outfile" "whoami >> log/outfile"
recipes "--leaks" "-r" "< log/non_existing_file cat < log/infile"
recipes "--leaks" "-r" "< log/file_without_permissions cat < log/infile"
recipes "--leaks" "-r" "< log/infile cat < log/non_existing_file"
recipes "--leaks" "-r" "< log/infile cat < log/file_without_permissions"
recipes "--leaks" "-r" "< log/outfile < log/file1 < log/infile cat"
recipes "--leaks" "-r" "< log/outfile < log/non_existing_file < log/infile cat"
recipes "--leaks" "-r" "< log/non_existing_file < log/outfile < log/infile cat"
recipes "--leaks" "-r" "< log/file_without_permissions < log/outfile < log/infile cat"
recipes "--leaks" "-r" "< log/outfile < log/file_without_permissions < log/infile cat"
echo
recipes "--leaks" "-r" "whoami > log/file1 > log/file2 > log/outfile" "whoami > log/file1 > log/file2 >> log/outfile"
recipes "--leaks" "-r" "whoami > log/file1 > log/file_without_permissions > log/outfile" "whoami > log/file1 > log/file2 >> log/outfile"
recipes "--leaks" "-r" "whoami > log/file1 > log/file_without_permissions > log/outfile" "whoami > log/file_without_permissions > log/file2 >> log/outfile"
echo
recipes "--leaks" "-r" "< log/infile cat > log/outfile"
recipes "--leaks" "-r" "cat < log/infile > log/outfile"

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
recipes "--leaks" "-r" "< log/outfile < log/file_without_permissions < log/infile cat | cat | cat | cat | wc -l | cat > log/file1 > log/outfile"
recipes "--leaks" "-r" "< log/infile cat | cat > log/outfile | cat | cat | wc -l | cat > log/file1"
recipes "--leaks" "-r" "< log/file1 cat | cat | < log/infile cat | cat | wc -l | cat > log/file1"
recipes "--leaks" "-r" "< log/infile cat | cat | < log/infile cat | cat | wc -l | cat > log/outfile"
#
# recipes "--leaks" "cat < log/infile > log/outfile | wc -l"
# recipes "--leaks" "whoami | cat | cat | cat < log/infile > log/outfile"
# recipes "--leaks" "whoami | cat < log/infile > log/outfile"
# echo 
# echo "Here_doc"
# echo 
#
# echo 
# echo "Expands"
# echo 
