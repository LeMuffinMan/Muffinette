
#!/bin/bash

YELLOW='\033[1;33m'

mkdir -p log

source cookware.sh

TIMEOUT_DURATION="${TIMEOUT_DURATION:-10}"

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
#
#
#==============================================================================================================
#
#
#
#
#Manual tests
# 
# env sans args ou options 
#
# run a random test manualy :
# cat recipes.sh | grep "recipes \"--leaks\"" | shuf -n 1 | sed "s/recipes \"--leaks\" //g" | sed "s/\"//g"
#
# mkdir -p a/b/c; cd a/b/c; rm -rf ../../a; pwd; cd ..; pwd; cd ..; pwd; cd ..; pwd;
# exit
# SIGNAUX
# - dans le prompt
# - dans un pipe
# - dans un cat
# - dans les here_docs
#
#prompt :
# des tabulatations CTRL + M et Tab ? demander a Sammy
# des espaces dans le prompt
# minishell dans minishell
#
# recipes "cd log" "pwd" "mkdir -p test/b/c" "cd test/b/c" "pwd" "cd ../../../" "pwd" "rm -rf test" 
# encho "source /home/oelleaum/.minishellrc" > /home/oelleaum/.minishellrc -> ce test ne renvoie pas l'erreur ??
#
# combo : pipes redirs && epands
#
echo -e "${YELLOW}======= BUILT_INS ======$NC"
echo
echo -e "${YELLOW}export$NC"
echo
recipes "export VAR=VAR" "export | grep VAR" 
recipes "export VAR=\"\"" "export | grep VAR" 
recipes "export VAR=\"\"" "export VAR+=\"123\"" "export | grep VAR" 
# a tester manuellement
# recipes "export VAR=\"\"" "export VAR+=\'\$HOME\'" "export | grep VAR" 
recipes "export VAR=\"123\"" "export | grep VAR" 
recipes "export VAR=\"123\"" "export | grep VAR" 
recipes "export VA1R=VAR" "export | grep VA1R" 
recipes "export VA+R=VAR" "export | grep VA+R" 
recipes "export VA*R=VAR" "export | grep VA*R" 
recipes "export VA-R=VAR" "export | grep VA-R" 
recipes "export VAR=VAR" "export | grep VAR" "unset VAT" "export | grep VAR" 
recipes "export VAR=VAR" "export | grep VAR" "unset VAR" "export | grep VAR" 
recipes "export VAR=VAR" "export VAR+=VAR" "export | grep VAR"
recipes "export SHLVL+=1" "export | grep SHLVL"
recipes "export VAR1=\"\" VAR2= VAR3=\"\$HOME\$USER\"" "export | grep VAR1" "export | grep VAR2" "export | grep VAR3"
recipes "export VAR=\"    .   V  A R    .   \"" "export | grep VAR" 
recipes "export VAR+=\"lolilol\"" "export | grep VAR" 
recipes "export =LOL" 
echo
echo -e "${YELLOW}unset$NC"
echo
echo -e "${YELLOW}expand avec UNSET ?$NC"
recipes "unset NOT_KNOWN_VALUE" 
recipes "unset USER" 
recipes "unset USER HOME SHLVL" 
recipes "unset USER HOME NOT_KNOWN_VALUE SHLVL" 
recipes "unset" 
echo 
echo -e "${YELLOW}cmd$NC"
echo 
recipes "whoami"
recipes "uname -a"
recipes "uname -m -n -r -s"
recipes "/usr/bin/uname -a"
recipes "non_existing_cmd"
recipes "/usr/bin/sudo"
recipes "/usr/bin/sudo -A"
recipes "/usr/bin/sudo -A apt update"
# pour lancer une commande par son chemin relatif qui serait dans le cwd, on devrait faire ./ !
# recipes "/sbin/sudo"
# ------------echo------------
echo
echo -e "${YELLOW}echo$NC"
echo
recipes "echo" 
recipes "echo -n" 
recipes "echo -n hello" 
recipes "echo -n -n -n " 
recipes "echo -n -n hello" 
recipes "echo hello" 
recipes "echo hello world" 
recipes "echo \$HOME \$USER" 
recipes "echo \"\$HOME \$USER\"" 
recipes "echo \$HOME\$USER" 
recipes "echo \"\$HOME\$USER\""
recipes "echo \"\$HOME\$USER\""
recipes "echo \"\$HOME\"\$USER"
# a tester manuellement
# recipes "echo \'\$HOME\'\$USER"
recipes "echo \$NOTEXITING"
recipes "echo \"\$NOTEXITING\""
recipes "export VAR=\"    .    V  A  R    .    \"" "echo \"\$NOTEXITING\""
# ------------exit------------
echo
echo -e "${YELLOW}exit$NC"
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
recipes "export EXIT=\"123\"" "exit \$EXIT"
# ------------pwd------------
echo
echo -e "${YELLOW}pwd$NC"
echo
recipes "pwd" 
recipes "pwd with args" 
# ------------cd------------
echo
echo -e "${YELLOW}cd$NC"
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
recipes "cd .." "cd \$HOME" "pwd" 
echo
echo -e "${YELLOW}combined builtins$NC"
echo
echo -e "$YELLOW si je fais unset SHLVL USER HOME PATH, puis echo \$?, j'ai : minishell: Malloc failed in function \'extract_path\'$NC"
recipes "unset SHLVL USER HOME PATH" "export | grep SHLVL" "export | grep USER" "export | grep HOME" "export | grep PATH" 
recipes "export VAR=VAR" "unset VAR" "export | grep VAR" "env | grep VAR"
recipes "export HOME=\"/tmp\"" "cd \$HOME" "unset HOME" "export | grep HOME"

echo 
echo -e "${YELLOW}======= Pipes =======$NC"
echo 
recipes "whoami | cat"
recipes "uname -a | cat"
echo
# echo -e "${YELLOW}grep without arg fails and prints its error, but not in pipe !$NC"
recipes "whoami | grep"
# echo -e "${YELLOW}cat -e doesn't work ?$NC"
recipes "whoami | cat | cat -e | cat | cat | cat"
recipes "whoami | cat | cat | cat | cat | cat"
recipes "whoami | cat | cat | wc -l | cat | cat"
recipes "whoami | cat | cat | wc -l | grep | cat"
recipes "whoami | cat | uname -a | wc -l | grep | cat"
# echo -e "${YELLOW}BASH gere une syntax error ! : bash: syntax error near unexpected token \`|\'$NC"
recipes "|"
recipes "| wc -l"
# echo -e "${YELLOW}bash opens a here_doc to complete the pipeline$NC"
recipes "uname -a | cat |"

echo 
echo -e "${YELLOW}======= Redirections =======$NC"
echo 
echo
echo -e "${YELLOW}syntax$NC"
recipes "-r" "> log/outfile"
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
echo -e "${YELLOW}combined pipes and redirections$NC"
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
echo 
echo -e "$YELLO MISC $NC"
echo 
recipes "mkdir a" "mkdir b" "cd a" "cd ../b" "rm -rf ../a" "cd -" "cd .." "rm -rf b" 
recipes "mkdir -p a/b/c" "cd a/b/c" "rm -rf ../../../a" "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" 
recipes "echo > /home/muffin/.file" 
recipes "." 
recipes ".." 
recipes "../.." 
recipes "../../" 
#
# Abidolet tests :
# recipes "echo -nnnnnnnnnnnnnnnnnnnnnnnnnnn" 
# recipes "export VAR=VAR @=lol VAR1=VAR1" 
# recipes "export VAR=VAR @=lol VAR1=VAR1 @=lolilol" 
# recipes "export VAR=\"echo hi | sleep 3\"" "export | grep VAR" 
recipes "< log/infile ." 
recipes "< log/infile .." 
