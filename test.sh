# Settings
export NIMTEROP=master

# Shortcuts
alias ix="curl -F 'f:1=<-' ix.io"
gclone() { git clone "https://github.com/$1" $2 $3 $4 $5 $6 $7 $8 $9; }
gco () { git checkout $1; }

# OSX setup
if [[ "$TRAVIS_OS_NAME" == "osx" ]]
then
  brew update
  brew install boehmgc
fi

set -e

if [[ "$TRAVIS_OS_NAME" == "osx" ]]
then
  unset -f cd
  shell_session_update() { :; }
fi

rm -rf test
mkdir test
cd test

# Nimterop setup
gclone nimterop/nimterop
cd nimterop
gco $NIMTEROP
nimble develop -y
nimble buildTimeit
nimble bt
cd ..

# Test wrappers
test() {
  gclone $1/$2
  cd $2
  if [[ "$3" != "" ]]; then
    gco $3
  fi
  nimble develop -y
  nimble test
  cd ..
}

# Extra test a branch
testBranch() {
  cd $1
  gco $2
  nimble test
  cd ..
}

gclone genotrance/nimarchive
cd nimarchive
gco nimteroptest1
nimble develop -y
cd ..

gclone dom96/choosenim
cd choosenim
nimble install -y -d
nimble test

# test genotrance nimpcre

# test genotrance nimarchive
# testBranch nimarchive nimteroptest1

# test genotrance nimgit2
# testBranch nimgit2 nimteroptest1

# test genotrance nimbass nimterop