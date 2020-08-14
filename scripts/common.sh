#!/usr/bin/env bash

get_version () {
  local APP_PATH="$1"
  # Get the current version from the app
  grep -o '^version = [0-9a-z.-]*' "${APP_PATH}/default/app.conf" | awk '{print $3}'
}

get_branch () {
  if [ "$TRAVIS" == "true" ]; then
    BRANCH=${TRAVIS_BRANCH}
  elif [ "$GITHUB_ACTIONS" == "true" ]; then
    BRANCH=${GITHUB_REF#refs/}
    BRANCH=${BRANCH#heads/}
    BRANCH=${BRANCH#heads/}
    BRANCH=${BRANCH%/merge}
  else
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
  fi
  BRANCH=${BRANCH//\//-}
  echo "$BRANCH"
}

get_build () {
  if [ "$TRAVIS" == "true" ]; then
    BUILD=${TRAVIS_BUILD_NUMBER}
  elif [ "$GITHUB_ACTIONS" == "true" ]; then
    BUILD=${GITHUB_RUN_ID}
  else
    BUILD="local"
  fi
  echo "$BUILD"
}

get_build_filename () {
    local app=$1
    local version=$2
    local branch=$3
    local build=$4
    if [ "$branch" == "master" ]; then
        echo "${app}-${version}.spl"
    else
        echo "${app}-${version}-${branch}-${build}.spl"
    fi
}