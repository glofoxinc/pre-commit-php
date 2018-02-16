#!/bin/bash
################################################################################
#
# Bash PHP Mess Detector
#
# This will prevent a commit if the tool has detected violations of the
# rulesets specified
#
# Exit 0 if no errors found
# Exit 1 if errors were found
#
# Requires
# - php
#
################################################################################

# Plugin title
title="PHP Mess Detector"

# Possible command names of this tool
local_command="phpmd.phar"
vendor_command="vendor/bin/phpmd"
global_command="phpmd"

# Print a welcome and locate the exec for this tool
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/helpers/colors.sh
source $DIR/helpers/formatters.sh
source $DIR/helpers/welcome.sh
source $DIR/helpers/locate.sh

# Build our list of files, and our list of args by testing if the argument is
# a valid path
# setting args to phpmd.xml which must be present to get the rules from, also exclude is hardcoded - figure out a way
# to put this in if condition where file list is generated
args="phpmd.xml --exclude app/AppKernel.php"
files=()
for arg in ${*}
do
    if [ -e $arg ]; then
        files+=("$arg")
    else
        args+=" $arg"
    fi
done;

exec_command="php ${local_command}"

if [ -f "${vendor_command}" ]; then
	exec_command=${vendor_command}
else
    if hash phpcs 2>/dev/null; then
        exec_command=${global_command}
    else
        if ! [ -f "${local_command}" ]; then
            echo "No valid PHPMD executable found! Please have one available as either ${vendor_command}, ${global_command} or ${local_command}"
            exit 1
        fi
    fi
fi

# Run the command on each file
echo -e "${txtgrn} $exec_command ${args} ${txtrst}"
php_errors_found=false
error_message=""
for path in "${files[@]}"
do
    OUTPUT="$(${exec_command} ${path} text ${args})"
    RETURN=$?
    if [ $RETURN -eq 1 ]; then
        # Return 1 means that PHPMD crashed
        error_message+="  - ${bldred}PHPMD failed to evaluate ${path}${txtrst}"
        error_message+="${OUTPUT}\n\n"
        php_errors_found=true
    elif [ $RETURN -eq 2 ]; then
        # Return 2 means it ran successfully, but found issues.
        error_message+="  - ${txtylw}${path}${txtrst}"
        error_message+="$OUTPUT\n\n"
        php_errors_found=true
    fi
done;

if [ "$php_errors_found" = true ]; then
    echo -en "\n${txtylw}${title} found issues in the following files:${txtrst}\n\n"
    echo -en "${error_message}"
    echo -en "${bldred}Please review and commit.${txtrst}\n"
    exit 1
fi

exit 0
