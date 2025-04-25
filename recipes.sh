
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
#
# combo : pipes redirs && epands
echo 
echo "cmd"
echo 
recipes "--leaks" "whoami"
recipes "--leaks" "uname -a"
recipes "--leaks" "uname -m -n -r -s"
recipes "--leaks" "/usr/bin/uname -a"
recipes "--leaks" "non_existing_cmd"
recipes "--leaks" "/sbin/sudo"
# ------------echo------------
echo
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
recipes "--leaks" "pwd" "cd .." "pwd" 
recipes "--leaks" "cd .." "pwd" "cd " "pwd" 
recipes "--leaks" "cd minishell" 
recipes "--leaks" "cd fwef feww" 
recipes "--leaks" "cd .." "cd -" 
recipes "--leaks" "cd -"
recipes "--leaks" "cd -" "cd -" 
recipes "--leaks" "cd .." "pwd" "cd -" "pwd" "cd .." "pwd" "cd -" "pwd" 
recipes "--leaks" "cd /home" "cd -" "cd -" 

echo 
echo "Pipes"
echo 
recipes "--leaks" "whoami | cat"
recipes "--leaks" "uname -a | cat"
recipes "--leaks" "whoami | grep"
recipes "--leaks" "uname -a | cat |"
recipes "--leaks" "| wc -l"
recipes "--leaks" "uname -a | cat | cat -e | cat | cat | cat"
recipes "--leaks" "|"

echo 
echo "Redirections"
echo 
recipes "--leaks" ">"
recipes "--leaks" "> log/outfile"
recipes "--leaks" "whoami >"
recipes "--leaks" "whoami > log"
recipes "--leaks" "whoami > minishell"
recipes "--leaks" "whoami > root/"
recipes "--leaks" "whoami > log/file_without_permissions"
recipes "--leaks" "whoami > log/outfile"
recipes "--leaks" "whoami > new_file" "cat new_file" "rm new_file"
recipes "--leaks" "whoami > log/outfile" "whoami >> log/outfile"
recipes "--leaks" "whoami > file1 > file2 > log/outfile" "whoami > file1 > file2 >> log/outfile"
recipes "--leaks" "< log/infile cat"
recipes "--leaks" "cat < log/infile"
recipes "--leaks" "< log/infile cat > log/outfile"
recipes "--leaks" "cat < log/infile > log/outfile"
recipes "--leaks" "<"
recipes "--leaks" "< log/infile"
recipes "--leaks" "whoami >> new_file" "cat new_file" "rm new_file"
recipes "--leaks" "whoami >> log/outfile"
recipes "--leaks" "uname -a >>"

# echo 
# echo "Environnement"
# echo 
#
# echo 
# echo "&& || ( )"
# echo 
#
# echo 
# echo "COMBO"
# echo 
#
recipes "--leaks" "cat < log/infile > log/outfile | wc -l"
recipes "--leaks" "whoami | cat | cat | cat < log/infile > log/outfile"
recipes "--leaks" "whoami | cat < log/infile > log/outfile"
# echo 
# echo "Here_doc"
# echo 
#
# echo 
# echo "Expands"
# echo 
