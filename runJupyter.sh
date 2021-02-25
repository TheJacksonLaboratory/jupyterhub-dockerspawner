#!/bin/bash
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/snambur/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/snambur/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/snambur/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/snambur/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
conda activate base 
/home/snambur/miniconda3/bin/jupyterhub -f /etc/jupyterhub/jupyterhub_config.py 2>&1 | tee /home/jupyter/jupyterhub.log
