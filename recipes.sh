
#!/bin/bash

YELLOW='\033[1;33m'

mkdir -p log

source cookware.sh

TIMEOUT_DURATION="${TIMEOUT_DURATION:-10}"

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
# cat recipes "--leaks".sh | grep "recipes "--leaks" \"--leaks\"" | shuf -n 1 | sed "s/recipes "--leaks" \"--leaks\" //g" | sed "s/\"//g"
#
# mkdir -p a/b/c; cd a/b/c; rm -rf ../../a; pwd; cd ..; pwd; cd ..; pwd; cd ..; pwd;
# exit
# SIGNAUX
# - done done dans le prompt
# - done dans un pipe
# - done dans un cat
# - done dans les here_docs
# - done cat | cat | ls : faire un CTRL+C / un CTRL+\ / CTRL+D 
# - done signaux : un CTRL + C dans un prompt puis des entrees normaux : on garde l'exit code 130 !!!
# - done << EOF + CTRLC : echo $? doit renvoyer 128 + 2 : 130
# - done signaux : volatile et atomic a vire si pas justifie
# - cat | << EOF : CTRL C CTRL \ CTRL D !
# - << EOF << EOF << EOF : EOF - tout explose
# - << EOF : ignorer le ctrl + \
# - << EOF << EOF << EOF : le ctrl + C doit TOUS les fermer 
# - il faut free dans le child lst_to_array + tokens + hd name + create here _doc + fermer le fd dans le child 
#
# Misc
#
# - done mkdir a / cd a / chmod 000 ./ cd .. : doit revenir en arriere en trimmant le dernier /.../ du pwd
#
# - unset PWD + cd : segfault
# - export HOL}A=bonjour ET export H`OLA=BONJOUR
# - wildcard comme node unique : afficher une erreur specifique
#
# - export PATH=$PWD":"$PATH : on a 3 char * au lieu de deux
# - si on a un binaire cat a deux endroits, qu'on a un permission denied sur le premier path, il faut aller checker les autres paths 
# - export a="o hello" /  ech$a : doit afficher hello (seb : d'abord expand, puis reparser et retokenizer")
# - decider pour le declare -x de export
# - redir qui ecris dans deux fichiers avec deux redirs : arbre est plus comme avant, la derniere redir est a droite normalement, la elle est la premiere a gauche
# - env -i : builtins pas reperes ? (env)
# - echo $ devrait afficher $ seulement
# - syntax error qui chie si tu mets des quotes a cheval 
#    - si on met des pipes : syntax error sur le pipe : echo | "d" | ""
#    -  echo test lol && 'echo' $? || echo trololo : 'echo' mal interprete
# - echo test lol : affiche sans espace !
#
#
#prompt :
# des tabulatations CTRL + M et Tab ? demander a Sammy
# des espaces dans le prompt
# minishell dans minishell
#
# recipes "--leaks" "cd log" "pwd" "mkdir -p test/b/c" "cd test/b/c" "pwd" "cd ../../../" "pwd" "rm -rf test" 
# encho "source /home/oelleaum/.minishellrc" > /home/oelleaum/.minishellrc -> ce test ne renvoie pas l'erreur ??
#
# contribution list : 
# - niroched
# - abidolet
# - jportier
# - ehosta
# - tom 
# - pnassaen
# - jmagand
# - Cyberwan
# - Thyanoui
# - Sammouche
# - secros
# - ibon
# - tsofien
#
#
echo 
echo -e "${YELLOW} == Booleans operators ==$NC"
echo 
recipes "--leaks" "true && whoami" 
recipes "--leaks" "true || whoami" 
recipes "--leaks" "false && whoami" 
recipes "--leaks" "false || whoami" 
echo 
echo -e "${YELLOW}basics$NC"
echo 
recipes "--leaks" "true && echo ok"      
recipes "--leaks" "false || echo ok"        
recipes "--leaks" "true && echo A || echo B"        
recipes "--leaks" "false || echo A && echo B"     
recipes "--leaks" "false && echo A || echo B"   
echo 
echo -e "${YELLOW}natural priority tests$NC"
echo 
recipes "--leaks" "true || echo A && echo B"      
recipes "--leaks" "false && echo A || echo B"     
recipes "--leaks" "true && false || echo Fallback"  
recipes "--leaks" "ls && echo LS_OK"                
recipes "--leaks" "notacommand || echo FAILED"      
recipes "--leaks" "mkdir test && rm -r test"       
# echo  MANUAL !!
echo -e "${YELLOW}parenthesis$NC"
echo 
recipes "--leaks" "(true && echo A) || echo B"      
recipes "--leaks" "(false || echo A) && echo B"     
recipes "--leaks" "true && (false || echo NESTED)"  
echo 
echo -e "${YELLOW}edges cases : syntax error$NC"
echo 
recipes "--leaks" "true &&"                         
recipes "--leaks" "true && true && true &&"                         
recipes "--leaks" "&& true"                         
recipes "--leaks" "&& true && true && true"                         
recipes "--leaks" "|| true"                         
recipes "--leaks" "|| true || true || true"                         
recipes "--leaks" "true ||"                         
recipes "--leaks" "true || true ||true ||"                         
# recipes "--leaks" "(true && echo OK"               
recipes "--leaks" "true && echo OK)"               
recipes "--leaks" "echo A && echo B || echo C"      
recipes "--leaks" "false || false || echo LAST"    
echo 
echo -e "${YELLOW}boolop and exit_code$NC"
echo 
recipes "--leaks" "false || echo \$?"               
recipes "--leaks" "true && echo \$?"
recipes "--leaks" "cd /root || echo \$?"
recipes "--leaks" "cd /root && echo \$?"
recipes "--leaks" "cd /no_exiting_folder && echo \$?"
recipes "--leaks" "(false && true) || echo \$?"               
recipes "--leaks" "(false || true) || echo \$?"               
recipes "--leaks" "(false || true) && echo \$?"               

# echo MANUAL TESTS !!
# echo -e "${YELLOW}syntax error : not required$NC"
# echo 
# recipes "--leaks" "(true && )(false || echo NESTED) > out"  
# recipes "--leaks" "(true || false) | (false || echo NESTED)"  
# recipes "--leaks" "(true && false) | (false || echo NESTED)"  
# recipes "--leaks" "(false && echo) ls (false || echo NESTED)"  
# recipes "--leaks" "true (false || echo NESTED)"  
# recipes "--leaks" "true > (false || echo NESTED)"  
# recipes "--leaks" "true >> (false || echo NESTED)"  
# recipes "--leaks" "true | (false || echo NESTED)"  
# recipes "--leaks" "cat < (false || echo NESTED)"  
# recipes "--leaks" "< (false || echo NESTED) cat"  
echo 
echo -e "${YELLOW}combined$NC"
echo
recipes "--leaks" "true && (false || (echo L1 && echo L2))"  # Devrait afficher "L1" puis "L2"
recipes "--leaks" "(false && echo A) || (true && echo B)"    # Devrait afficher "B"
recipes "--leaks" "false || (true && (false || echo DEEP))"  # Devrait afficher "DEEP"
recipes "--leaks" "false || echo \$?" 
echo -e "${YELLOW}======= BUILT_INS ======$NC"
echo
# ------------exit------------
echo
echo -e "${YELLOW}exit$NC"
echo
recipes "--leaks" "exit ghernjfw gthrnejwm" 
recipes "--leaks" "exit 256" 
recipes "--leaks" "exit 256999999999999999999999999999999999999999999999999999999999999999999999999999999999999999" 
recipes "--leaks" "exit 42" 
recipes "--leaks" "exit -1" 
recipes "--leaks" "exit -256" 
recipes "--leaks" "exit 1 2" 
recipes "--leaks" "exit not_numeric_argument" 
recipes "--leaks" "exit 1 not_numeric_argument" 
recipes "--leaks" "export EXIT=\"123\"" "exit \$EXIT"

echo -e "${YELLOW}export$NC"
echo

#tsofien tests :
recipes "--leaks" "-r" "export HOL}A=bonjour" 
recipes "--leaks" "-r" "export HO\`LA=bonjour" 
recipes "--leaks" "export TEST" "export | grep TEST" 
#Tom tests : 
recipes "--leaks" "export fdsfds fsdfdf 8 sdfsf"
# Abidolet tests :
recipes "--leaks" "export VAR=VAR @=VAR VAR1=VAR1 @=RAV" 
recipes "--leaks" "export VAR=VAR @=VAR VAR1=VAR1" 
recipes "--leaks" "export SHLVL+=1 | export grep SHLVL" 
recipes "--leaks" "export HOME=" "export | grep HOME" 
recipes "--leaks" "export VA1=\"COUCOU\"" 
recipes "--leaks" "export VAR=VAR" "export | grep VAR" 
recipes "--leaks" "export VAR=\"\"" "export | grep VAR" 
recipes "--leaks" "export VAR=\"\"" "export VAR+=\"123\"" "export | grep VAR" 
recipes "--leaks" "export VAR=\"123\"" "export | grep VAR" 
recipes "--leaks" "export VAR=\"123\"" "export | grep VAR" 
recipes "--leaks" "export VA1R=VAR" "export | grep VA1R" 
recipes "--leaks" "export VA+R=VAR" "export | grep VA+R" 
recipes "--leaks" "export VA*R=VAR" "export | grep VA*R" 
recipes "--leaks" "export VA-R=VAR" "export | grep VA-R" 
recipes "--leaks" "export VAR=VAR" "export | grep VAR" "unset VAT" "export | grep VAR" 
recipes "--leaks" "export VAR=VAR" "export | grep VAR" "unset VAR" "export | grep VAR" 
recipes "--leaks" "export VAR=VAR" "export VAR+=VAR" "export | grep VAR"
recipes "--leaks" "export SHLVL+=1" "export | grep SHLVL"
recipes "--leaks" "export VAR1=\"\" VAR2= VAR3=\"\$HOME\$USER\"" "export | grep VAR1" "export | grep VAR2" "export | grep VAR3"
recipes "--leaks" "export VAR=\"    .   V  A R    .   \"" "export | grep VAR" 
recipes "--leaks" "export VAR+=\"lolilol\"" "export | grep VAR" 
recipes "--leaks" "export =LOL" 
echo
echo -e "${YELLOW}unset$NC"
echo
echo -e "${YELLOW}expand avec UNSET ?$NC"
recipes "--leaks" "unset NOT_KNOWN_VALUE" 
recipes "--leaks" "unset USER" 
recipes "--leaks" "unset USER HOME SHLVL" 
recipes "--leaks" "unset USER HOME NOT_KNOWN_VALUE SHLVL" 
recipes "--leaks" "unset" 
echo 
echo -e "${YELLOW}cmd$NC"
echo 
recipes "--leaks" "whoami"
recipes "--leaks" "uname -a"
recipes "--leaks" "uname -m -n -r -s"
recipes "--leaks" "/usr/bin/uname -a"
recipes "--leaks" "non_existing_cmd"
recipes "--leaks" "/usr/bin/sudo"
recipes "--leaks" "/usr/bin/sudo -A"
recipes "--leaks" "/usr/bin/sudo -A apt update"
recipes "--leaks" "./usr/bin/sudo -A apt update"
recipes "--leaks" "cp /usr/bin/ls ." "./ls" "rm -rf ls"
# ------------echo------------
echo
echo -e "${YELLOW}echo$NC"
echo
recipes "--leaks" "echo" 
recipes "--leaks" "echo -n -nn e" 
recipes "--leaks" "echo -n -nn -z o" 
recipes "--leaks" "echo -nn o" 
recipes "--leaks" "echo -n -nna a" 
recipes "--leaks" "echo -nnnnnnnnnnnnnnnnnnnnnnnnnnn" 
recipes "--leaks" "echo -n nnnnnnnnnnnnnnnnnnnnnnnnn" 
recipes "--leaks" "echo -c" 
recipes "--leaks" "echo -n" 
recipes "--leaks" "echo -n hello" 
recipes "--leaks" "echo -n -n -n " 
recipes "--leaks" "echo -n -n hello" 
recipes "--leaks" "echo hello" 
recipes "--leaks" "echo hello world" 
recipes "--leaks" "echo \$HOME \$USER" 
recipes "--leaks" "echo \"\$HOME \$USER\"" 
recipes "--leaks" "echo \$HOME\$USER" 
recipes "--leaks" "echo \"\$HOME\$USER\""
recipes "--leaks" "echo \"\$HOME\$USER\""
recipes "--leaks" "echo \"\$HOME\"\$USER"
# a tester manuellement
# recipes "--leaks" "echo \'\$HOME\'\$USER"
recipes "--leaks" "echo \$NOTEXITING"
recipes "--leaks" "echo \"\$NOTEXITING\""
recipes "--leaks" "export VAR=\"    .    V  A  R    .    \"" "echo \"\$NOTEXITING\""
# ------------pwd------------
echo
echo -e "${YELLOW}pwd$NC"
echo
recipes "--leaks" "pwd" 
recipes "--leaks" "pwd with args" 
# ------------cd------------
echo
echo -e "${YELLOW}cd$NC"
echo
recipes "--leaks" "cd" 
recipes "--leaks" "cd \$HOME/.." "pwd" 
recipes "--leaks" "cd \$HOME/../." "pwd" 
recipes "--leaks" "cd ./././././././././././././log" "pwd" 
recipes "--leaks" "pwd .. ... ." 
recipes "--leaks" "cd test" "cat *.c" 
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
recipes "--leaks" "cd .." "cd \$HOME" "pwd" 
echo
echo -e "${YELLOW}combined builtins$NC"
echo
# echo -e "$YELLOW si je fais unset SHLVL USER HOME PATH, puis echo \$?, j'ai : minishell: Malloc failed in function \'extract_path\'$NC"
recipes "--leaks" "unset SHLVL USER HOME PATH" "export | grep SHLVL" "export | grep USER" "export | grep HOME" "export | grep PATH" 
recipes "--leaks" "export VAR=VAR" "unset VAR" "export | grep VAR" "env | grep VAR"
recipes "--leaks" "export HOME=\"/tmp\"" "cd \$HOME" "unset HOME" "export | grep HOME"
#
echo 
echo -e "${YELLOW}======= Pipes =======$NC"
echo 
recipes "--leaks" "whoami | cat"
recipes "--leaks" "uname -a | cat"
echo
recipes "--leaks" "whoami | grep"
recipes "--leaks" "whoami | cat | cat -e | cat | cat | cat"
recipes "--leaks" "whoami | cat | cat | cat | cat | cat"
recipes "--leaks" "whoami | cat | cat | wc -l | cat | cat"
recipes "--leaks" "whoami | cat | cat | wc -l | grep | cat"
recipes "--leaks" "whoami | cat | uname -a | wc -l | grep | cat"
recipes "--leaks" "|"
recipes "--leaks" "| wc -l"
recipes "--leaks" "uname -a | cat |"

echo 
echo -e "${YELLOW}======= Redirections =======$NC"
echo 
echo
echo -e "${YELLOW}syntax$NC"
recipes "--leaks" "-r" "> log/outfile"
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
echo 
echo -e "${YELLOW}combined pipes and redirections$NC"
echo 
recipes "--leaks" "-r" "< log/outfile < log/file_without_permissions < log/infile cat | cat | cat | cat | wc -l | cat > log/file1 > log/outfile"
recipes "--leaks" "-r" "< log/infile cat | cat > log/outfile | cat | cat | wc -l | cat > log/file1"
recipes "--leaks" "-r" "< log/file1 cat | cat | < log/infile cat | cat | wc -l | cat > log/file1"
recipes "--leaks" "-r" "< log/infile cat | cat | < log/infile cat | cat | wc -l | cat > log/outfile"
recipes "--leaks" "-r" "cat < log/infile > log/outfile | wc -l"
recipes "--leaks" "-r" "whoami | cat | cat | cat < log/infile > log/outfile"
recipes "--leaks" "-r" "whoami | cat < log/infile > log/outfile"
# echo 
# echo "Expands"
# echo 
echo 
echo -e  "${YELLOW}TO FIX$NC"
echo 
recipes "--leaks" "mkdir a" "mkdir b" "cd a" "cd ../b" "rm -rf ../a" "cd -" "cd .." "rm -rf b" 
recipes "--leaks" "mkdir -p a/b/c" "cd a/b/c" "rm -rf ../../../a" "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" 
recipes "--leaks" "." 
recipes "--leaks" ".." 
recipes "--leaks" "../.." 
recipes "--leaks" "../../" 
recipes "--leaks" "< log/infile ." 
recipes "--leaks" "< log/infile .." 
recipes "--leaks" "mkdir a" "mkdir b" "cd a" "cd ../b" "rm -rf ../a" "cd -" "rm -rf ../b" 
echo
echo -e  "${YELLOW}TO FIX$NC"
echo
recipes "--leaks" "echo \$" 
recipes "--leaks" "unset PWD" "cd " 
recipes "--leaks"  "echo test lol" 
recipes "--leaks" "cd | pwd | exit | export VAR=VAR | export | grep VAR | unset VAR | exprot | grep VAR | cd .. | cd / | exit" 
echo 
echo -e  "${YELLOW}TOO MUCH ?$NC"
echo 
recipes "--leaks" "echo | \"d\" | \"\"" 
recipes "--leaks" "export a=\"o hello\"" "ech\$a" 
recipes "--leaks" "export PATH=\$PWD\":\"\$PATH" 
recipes "--leaks" "unset PATH" "unset USER" 
# recipes "--leaks" "export VAR=\"echo hi | sleep 3\"" "export | grep VAR" "\$VAR" 
recipes "--leaks" "cp minishell cat" "cat Makefile" "rm -rf cat"
recipes "--leaks" "cp /usr/bin/ls ." "chmod 000 ls" "ls" "chmod 777 ls" "rm -rf ls" 
