
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
# recipes "cd log" "pwd" "mkdir -p test/b/c" "cd test/b/c" "pwd" "cd ../../../" "pwd" "rm -rf test" 
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
recipes "true && whoami" 
recipes "true || whoami" 
recipes "false && whoami" 
recipes "false || whoami" 
echo 
echo -e "${YELLOW}basics$NC"
echo 
recipes "true && echo ok"      
recipes "false || echo ok"        
recipes "true && echo A || echo B"        
recipes "false || echo A && echo B"     
recipes "false && echo A || echo B"   
echo 
echo -e "${YELLOW}natural priority tests$NC"
echo 
recipes "true || echo A && echo B"      
recipes "false && echo A || echo B"     
recipes "true && false || echo Fallback"  
recipes "ls && echo LS_OK"                
recipes "notacommand || echo FAILED"      
recipes "mkdir test && rm -r test"       
# echo  MANUAL !!
echo -e "${YELLOW}parenthesis$NC"
echo 
recipes "(true && echo A) || echo B"      
recipes "(false || echo A) && echo B"     
recipes "true && (false || echo NESTED)"  
echo 
echo -e "${YELLOW}edges cases : syntax error$NC"
echo 
recipes "true &&"                         
recipes "true && true && true &&"                         
recipes "&& true"                         
recipes "&& true && true && true"                         
recipes "|| true"                         
recipes "|| true || true || true"                         
recipes "true ||"                         
recipes "true || true ||true ||"                         
# recipes "(true && echo OK"               
recipes "true && echo OK)"               
recipes "echo A && echo B || echo C"      
recipes "false || false || echo LAST"    
echo 
echo -e "${YELLOW}boolop and exit_code$NC"
echo 
recipes "false || echo \$?"               
recipes "true && echo \$?"
recipes "cd /root || echo \$?"
recipes "cd /root && echo \$?"
recipes "cd /no_exiting_folder && echo \$?"
recipes "(false && true) || echo \$?"               
recipes "(false || true) || echo \$?"               
recipes "(false || true) && echo \$?"               

# echo MANUAL TESTS !!
# echo -e "${YELLOW}syntax error : not required$NC"
# echo 
# recipes "(true && )(false || echo NESTED) > out"  
# recipes "(true || false) | (false || echo NESTED)"  
# recipes "(true && false) | (false || echo NESTED)"  
# recipes "(false && echo) ls (false || echo NESTED)"  
# recipes "true (false || echo NESTED)"  
# recipes "true > (false || echo NESTED)"  
# recipes "true >> (false || echo NESTED)"  
# recipes "true | (false || echo NESTED)"  
# recipes "cat < (false || echo NESTED)"  
# recipes "< (false || echo NESTED) cat"  
echo 
echo -e "${YELLOW}combined$NC"
echo
recipes "true && (false || (echo L1 && echo L2))"  # Devrait afficher "L1" puis "L2"
recipes "(false && echo A) || (true && echo B)"    # Devrait afficher "B"
recipes "false || (true && (false || echo DEEP))"  # Devrait afficher "DEEP"
recipes "false || echo \$?" 
echo -e "${YELLOW}======= BUILT_INS ======$NC"
echo
# ------------exit------------
echo
echo -e "${YELLOW}exit$NC"
echo
recipes "exit ghernjfw gthrnejwm" 
recipes "exit 256" 
recipes "exit 256999999999999999999999999999999999999999999999999999999999999999999999999999999999999999" 
recipes "exit 42" 
recipes "exit -1" 
recipes "exit -256" 
recipes "exit 1 2" 
recipes "exit not_numeric_argument" 
recipes "exit 1 not_numeric_argument" 
recipes "export EXIT=\"123\"" "exit \$EXIT"

echo -e "${YELLOW}export$NC"
echo

#tsofien tests :
recipes "-r" "export HOL}A=bonjour" 
recipes "-r" "export HO\`LA=bonjour" 
recipes "export TEST" "export | grep TEST" 
#Tom tests : 
recipes "export fdsfds fsdfdf 8 sdfsf"
# Abidolet tests :
recipes "export VAR=VAR @=VAR VAR1=VAR1 @=RAV" 
recipes "export VAR=VAR @=VAR VAR1=VAR1" 
recipes "export SHLVL+=1 | export grep SHLVL" 
recipes "export HOME=" "export | grep HOME" 
recipes "export VA1=\"COUCOU\"" 
recipes "export VAR=VAR" "export | grep VAR" 
recipes "export VAR=\"\"" "export | grep VAR" 
recipes "export VAR=\"\"" "export VAR+=\"123\"" "export | grep VAR" 
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
recipes "./usr/bin/sudo -A apt update"
recipes "cp /usr/bin/ls ." "./ls" "rm -rf ls"
# ------------echo------------
echo
echo -e "${YELLOW}echo$NC"
echo
recipes "echo" 
recipes "echo -n -nn e" 
recipes "echo -n -nn -z o" 
recipes "echo -nn o" 
recipes "echo -n -nna a" 
recipes "echo -nnnnnnnnnnnnnnnnnnnnnnnnnnn" 
recipes "echo -n nnnnnnnnnnnnnnnnnnnnnnnnn" 
recipes "echo -c" 
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
recipes "cd \$HOME/.." "pwd" 
recipes "cd \$HOME/../." "pwd" 
recipes "cd ./././././././././././././log" "pwd" 
recipes "pwd .. ... ." 
recipes "cd test" "cat *.c" 
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
# echo -e "$YELLOW si je fais unset SHLVL USER HOME PATH, puis echo \$?, j'ai : minishell: Malloc failed in function \'extract_path\'$NC"
recipes "unset SHLVL USER HOME PATH" "export | grep SHLVL" "export | grep USER" "export | grep HOME" "export | grep PATH" 
recipes "export VAR=VAR" "unset VAR" "export | grep VAR" "env | grep VAR"
recipes "export HOME=\"/tmp\"" "cd \$HOME" "unset HOME" "export | grep HOME"
#
echo 
echo -e "${YELLOW}======= Pipes =======$NC"
echo 
recipes "whoami | cat"
recipes "uname -a | cat"
echo
recipes "whoami | grep"
recipes "whoami | cat | cat -e | cat | cat | cat"
recipes "whoami | cat | cat | cat | cat | cat"
recipes "whoami | cat | cat | wc -l | cat | cat"
recipes "whoami | cat | cat | wc -l | grep | cat"
recipes "whoami | cat | uname -a | wc -l | grep | cat"
recipes "|"
recipes "| wc -l"
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
echo 
echo -e "${YELLOW}combined pipes and redirections$NC"
echo 
recipes "-r" "< log/outfile < log/file_without_permissions < log/infile cat | cat | cat | cat | wc -l | cat > log/file1 > log/outfile"
recipes "-r" "< log/infile cat | cat > log/outfile | cat | cat | wc -l | cat > log/file1"
recipes "-r" "< log/file1 cat | cat | < log/infile cat | cat | wc -l | cat > log/file1"
recipes "-r" "< log/infile cat | cat | < log/infile cat | cat | wc -l | cat > log/outfile"
recipes "-r" "cat < log/infile > log/outfile | wc -l"
recipes "-r" "whoami | cat | cat | cat < log/infile > log/outfile"
recipes "-r" "whoami | cat < log/infile > log/outfile"
# echo 
# echo "Expands"
# echo 
echo 
echo -e  "${YELLOW}TO FIX$NC"
echo 
recipes "mkdir a" "mkdir b" "cd a" "cd ../b" "rm -rf ../a" "cd -" "cd .." "rm -rf b" 
recipes "mkdir -p a/b/c" "cd a/b/c" "rm -rf ../../../a" "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" "cd .." "pwd" 
recipes "." 
recipes ".." 
recipes "../.." 
recipes "../../" 
recipes "< log/infile ." 
recipes "< log/infile .." 
recipes "mkdir a" "mkdir b" "cd a" "cd ../b" "rm -rf ../a" "cd -" "rm -rf ../b" 
echo
echo -e  "${YELLOW}TO FIX$NC"
echo
recipes "echo \$" 
recipes "unset PWD" "cd " 
recipes  "echo test lol" 
recipes "cd | pwd | exit | export VAR=VAR | export | grep VAR | unset VAR | exprot | grep VAR | cd .. | cd / | exit" 
echo 
echo -e  "${YELLOW}TOO MUCH ?$NC"
echo 
recipes "echo | \"d\" | \"\"" 
recipes "export a=\"o hello\"" "ech\$a" 
recipes "export PATH=\$PWD\":\"\$PATH" 
recipes "unset PATH" "unset USER" 
# recipes "export VAR=\"echo hi | sleep 3\"" "export | grep VAR" "\$VAR" 
recipes "cp minishell cat" "cat Makefile" 
recipes "cp /usr/bin/ls ." "chmod 000 ls" "ls" 
