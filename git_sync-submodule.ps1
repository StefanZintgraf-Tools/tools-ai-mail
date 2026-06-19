param(
    [string]$Message = "chore: update ai-mail.pocock submodule",
    [string]$Branch  = "master"
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
    # Pull the latest commits on the submodule's branch. We update inside the
    # submodule on an explicit branch instead of `git submodule update --remote`,
    # which fails ("Unable to find current origin/HEAD revision") when no
    # submodule.<name>.branch is configured and origin/HEAD is unset.
    Write-Host "Pulling latest commits into ai-mail.pocock ($Branch)..."
    Push-Location $submodulePath
    try {
        git fetch origin
        if ($LASTEXITCODE -ne 0) { throw "git fetch failed in submodule." }
        git checkout $Branch
        if ($LASTEXITCODE -ne 0) { throw "git checkout $Branch failed in submodule." }
        git merge --ff-only "origin/$Branch"
        if ($LASTEXITCODE -ne 0) { throw "git merge --ff-only origin/$Branch failed in submodule." }
    }
    finally {
        Pop-Location
    }
}

# --- 2. Commit the updated pointer to the parent repo and push ---
# Warn if the submodule has uncommitted working-tree changes: those must be
# committed/pushed *inside* the submodule (e.g. .\git_push.ps1) first — they do
# not move the pointer the parent records.
$submoduleDirty = git -C $submodulePath status --porcelain
if ($LASTEXITCODE -ne 0) { throw "git status failed in submodule." }
if ($submoduleDirty) {
    Write-Warning "ai-mail.pocock has uncommitted changes. Commit/push them inside the submodule first; they won't be captured by the pointer update."
}

# Stage the submodule and check whether the recorded pointer actually changed,
# rather than trusting `git status`, which also flags a merely-dirty submodule.
git add ai-mail.pocock
if ($LASTEXITCODE -ne 0) { throw "git add failed." }
git diff --cached --quiet -- ai-mail.pocock
$pointerChanged = ($LASTEXITCODE -ne 0)

if ($pointerChanged) {
    Write-Host "Committing submodule pointer update..."
    git commit -m $Message
    if ($LASTEXITCODE -ne 0) { throw "git commit failed." }
    git push
    if ($LASTEXITCODE -ne 0) { throw "git push failed." }
    Write-Host "Done — submodule pointer pushed to remote."
} else {
    Write-Host "Done — submodule pointer already up to date, nothing to commit."
}
