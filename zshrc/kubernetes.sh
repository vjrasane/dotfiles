alias kb="kubectl"
alias kn="kubens"

export KUBECONFIG=$(printf ":%s" "$HOME"/.kube/config* | cut -c2-)
