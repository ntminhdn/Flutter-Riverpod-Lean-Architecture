#!/bin/bash
echo "super_lint is running..."
cmd=$( dart run custom_lint )
echo -e "$cmd"

if grep -q " • WARNING" <<< "$cmd"; then
    echo "super_lint: Warnings found."
    exit 1
fi

if grep -q " • ERROR" <<< "$cmd"; then
    echo "super_lint: Errors found."
    exit 1
fi

echo "*** super_lint: Success. ***"
