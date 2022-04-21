oh-my-posh init pwsh --config /opt/.poshthemes/$env:POSH_THEME_ENVIRONMENT.omp.json | Invoke-Expression
Import-Module "posh-git","PSReadLine","Terminal-Icons","posh-sshell"

# PSReadLine
Set-PSReadLineOption -EditMode Windows
Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadLineOption -PredictionSource History -PredictionViewStyle ListView
