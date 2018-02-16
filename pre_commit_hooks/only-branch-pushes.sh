#!/bin/bash
# Prevents force-pushing to given branches
# @see https://github.com/marick/pre-commit-hooks/blob/master/hooks/only-branch-pushes

required_arg=$1
pattern=$2

if [ "$required_arg" != "prevent" ]; then
    echo "Bad .pre-commit-config.yaml: you must use :args [prevent, x|y]"
    exit 1
fi

if [ "$pattern" == "" ]; then
    echo "Bad .pre-commit-config.yaml: no pattern in args"
    exit 1
fi

branch=`git rev-parse --abbrev-ref HEAD`

if [[ "$branch" =~ $pattern ]]; then
  echo "Prevented work on $branch."
  echo "If you really want to do this, use --no-verify to bypass this hook."
  exit 1
fi

exit 0