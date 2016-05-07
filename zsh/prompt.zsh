# Load themes from the prompts directory
autoload promptinit
fpath=(${0:a:h}/prompts $fpath)
promptinit
