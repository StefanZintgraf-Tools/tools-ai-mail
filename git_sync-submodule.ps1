param(
    [string]$Message = "chore: update ai-mail.pocock submodule"
)

git add ai-mail.pocock
git commit -m $Message
git push
