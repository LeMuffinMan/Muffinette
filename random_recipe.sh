cat recipes.sh | grep "recipes \"--leaks\"" | shuf -n 1 | sed "s/recipes \"--leaks\" //g" 
