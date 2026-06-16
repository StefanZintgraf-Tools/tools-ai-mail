param(
    [string]$Message = "chore: update ai-mail.pocock submodule"
)

$ErrorActionPreference = "Stop"
$repoRoot = $PSScriptRoot
$submodulePath = Join-Path $repoRoot "ai-mail.pocock"
$submoduleUrl  = "https://github.com/StefanZintgraf-Tools/tools-ai-mail-pocock"

Set-Location $repoRoot

# --- 1. Clone or update the submodule ---
if (-not (Test-Path (Join-Path $submodulePath ".git"))) {
    Write-Host "Registering and cloning submodule ai-mail.pocock..."
    git submodule add $submoduleUrl ai-mail.pocock
    git submodule update --init --recursive ai-mail.pocock
} else {
    Write-Host "Pulling latest commits into ai-mail.pocock..."
    git submodule update --remote --merge ai-mail.pocock
}

# --- 2. Commit the updated pointer to the parent repo and push ---
$status = git status --porcelain ai-mail.pocock
if ($status) {
    Write-Host "Committing submodule pointer update..."
    git add ai-mail.pocock
    git commit -m $Message
    git push
    Write-Host "Done — submodule pointer pushed to remote."
} else {
    Write-Host "Done — submodule already up to date, nothing to commit."
}
