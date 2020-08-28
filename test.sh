# Settings
export NIMTEROP=
export NIM_SEMVER=(`echo $BRANCH | tr '.' ' '`)

# Shortcuts
alias ix="curl -F 'f:1=<-' ix.io"
gclone() { git clone "https://github.com/$1" $2 $3 $4 $5 $6 $7 $8 $9; }
gco () { git checkout $1; }

gcloneBranch() {
  gclone $1/$2
  cd $2
  if [[ "$3" != "" ]]; then
    gco $3
  fi
  nimble develop -y
  cd ..
}

test() {
  gcloneBranch $1 $2 $3
  cd $2
  nimble test
  cd ..
}

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
gcloneBranch nimterop nimterop $NIMTEROP
cd nimterop
nimble buildTimeit
nimble bt
cd ..

test genotrance nimpcre

test genotrance nimarchive

if [[ "$TRAVIS_CPU_ARCH" == "amd64" ]]
  then
  # amd64-only tests
  
  # nim >= 1.2.4 only, test choosenim
  if [[ \
      ( "${NIM_SEMVER[0]}" == 1 && "${NIM_SEMVER[1]}" == 2 && "${NIM_SEMVER[2]}" -ge 4 ) || \
      ( "${NIM_SEMVER[0]}" == 1 && "${NIM_SEMVER[1]}" -ge 3 ) || \
      "${NIM_SEMVER[0]}" -gt 1 \
    ]]
  then
    gclone dom96/choosenim
    cd choosenim
    nimble install -d -y  # Cannot nimble develop binary package
    nimble test
    cd ..
  fi

  test genotrance nimgit2

  # nim >= 1.0.0 only, test gittyup
  if [[ "${NIM_SEMVER[0]}" -gt 0 ]]
  then
    test disruptek gittyup
  fi
  
  # linux/macOS only, test nimbass
  if [[ "$TRAVIS_OS_NAME" != "windows" ]]
  then
    test genotrance nimbass
  fi
 
  # Test nimble master
  gcloneBranch nim-lang nimble
  cd nimble/tests
  nim c -r tester
  cd ..
  ./src/nimble install -y
  cd ..
fi
