
PATH_FRAGMENTS=(
    ${HOME}/bin   
    ${HOME}/bin/bash/common 
)

for fragment in "${PATH_FRAGMENTS[@]}"; do 
    [[ -d $fragment ]] && PATH=${fragment}:$PATH
done
