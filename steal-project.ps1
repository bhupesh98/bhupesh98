# I don't recommend this, this is written just for automation
# Just enter the required details and execute the script

$REPO_URL="Github URL of the owner"
$GITHUB_ID="Your Github ID"

$REPO_NAME = [System.IO.Path]::GetFileNameWithoutExtension($REPO_URL)

git clone $REPO_URL tmp && cd tmp

git filter-branch --env-filter '
CORRECT_NAME="Your name"
CORRECT_EMAIL="Your email"

export GIT_COMMITTER_NAME="$CORRECT_NAME"
export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
export GIT_AUTHOR_NAME="$CORRECT_NAME"
export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
' --tag-name-filter cat -- --branches --tags

git branch -m main

git remote set-url origin "https://github.com/$GITHUB_ID/$REPO_NAME.git"

git push origin main

#cd .. && rm -r -Force tmp
