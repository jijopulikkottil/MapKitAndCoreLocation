#!/bin/bash

commmitCount=$(git rev-list --count master)
echo $commitCount
export GIT_COMMIT_NUMBER=$commmitCount