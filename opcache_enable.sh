#!/bin/bash

########################################################################################################################
# Find Us                                                                                                              #
# Author: Mehmet ÖĞMEN                                                                                                 #
# Web   : https://x-shell.codes/scripts/php                                                                            #
# Email : mailto:php.script@x-shell.codes                                                                              #
# GitHub: https://github.com/x-shell-codes/php                                                                         #
########################################################################################################################
# Contact The Developer:                                                                                               #
# https://www.mehmetogmen.com.tr - mailto:www@mehmetogmen.com.tr                                                       #
########################################################################################################################

########################################################################################################################
# Constants                                                                                                            #
########################################################################################################################
NORMAL_LINE=$(tput sgr0)
RED_LINE=$(tput setaf 1)
YELLOW_LINE=$(tput setaf 3)
GREEN_LINE=$(tput setaf 2)
BLUE_LINE=$(tput setaf 4)
POWDER_BLUE_LINE=$(tput setaf 153)
BRIGHT_LINE=$(tput bold)
REVERSE_LINE=$(tput smso)
UNDER_LINE=$(tput smul)

########################################################################################################################
# Line Helper Functions                                                                                                #
########################################################################################################################
function ErrorLine() {
  echo "${RED_LINE}$1${NORMAL_LINE}"
}

function WarningLine() {
  echo "${YELLOW_LINE}$1${NORMAL_LINE}"
}

function SuccessLine() {
  echo "${GREEN_LINE}$1${NORMAL_LINE}"
}

function InfoLine() {
  echo "${BLUE_LINE}$1${NORMAL_LINE}"
}

########################################################################################################################
# Version                                                                                                              #
########################################################################################################################
function Version() {
  echo "php version 1.0.0"
  echo
  echo "${BRIGHT_LINE}${UNDER_LINE}Find Us${NORMAL}"
  echo "${BRIGHT_LINE}Author${NORMAL}: Mehmet ÖĞMEN"
  echo "${BRIGHT_LINE}Web${NORMAL}   : https://x-shell.codes/scripts/php"
  echo "${BRIGHT_LINE}Email${NORMAL} : mailto:php.script@x-shell.codes"
  echo "${BRIGHT_LINE}GitHub${NORMAL}: https://github.com/x-shell-codes/php"
}

########################################################################################################################
# Help                                                                                                                 #
########################################################################################################################
function Help() {
  echo "A tool you can use to generate SSL certificates."
  echo
  echo "Options:"
  echo "-p | --php         Php version (8.1)"
  echo "-h | --help        Display this help."
  echo "-V | --version     Print software version and exit."
  echo
  echo "For more details see https://github.com/x-shell-codes/php."
}

########################################################################################################################
# Arguments Parsing                                                                                                    #
########################################################################################################################
php=8.1
for i in "$@"; do
  case $i in
  -p=* | --php=*)
    php="${i#*=}"

    if [ "$php" != "8.1" ]; then
      ErrorLine "Invalid php version. Please use 8.1"
      exit
    fi

    shift
    ;;
  -h | --help)
    Help
    exit
    ;;
  -V | --version)
    Version
    exit
    ;;
  -* | --*)
    ErrorLine "Unexpected option: $1"
    echo
    echo "Help:"
    Help
    exit
    ;;
  esac
done

########################################################################################################################
# CheckRootUser Function                                                                                               #
########################################################################################################################
function CheckRootUser() {
  if [ "$(whoami)" != root ]; then
    ErrorLine "You need to run the script as user root or add sudo before command."
    exit 1
  fi
}

########################################################################################################################
# Main Program                                                                                                         #
########################################################################################################################
echo "${POWDER_BLUE_LINE}${BRIGHT_LINE}${REVERSE_LINE}OPCache Enable${NORMAL_LINE}"

CheckRootUser

export DEBIAN_FRONTEND=noninteractive

sed -i "s/;\?opcache\.enable=.*/opcache.enable = 1/" /etc/php/$php/fpm/php.ini
sed -i "s/;\?opcache\.enable =.*/opcache.enable = 1/" /etc/php/$php/fpm/php.ini
sed -i "s/;\?opcache\.memory_consumption.*/opcache.memory_consumption = 512/" /etc/php/$php/fpm/php.ini
sed -i "s/;\?opcache\.interned_strings_buffer.*/opcache.interned_strings_buffer = 64/" /etc/php/$php/fpm/php.ini
sed -i "s/;\?opcache\.max_accelerated_files.*/opcache.max_accelerated_files = 30000/" /etc/php/$php/fpm/php.ini
sed -i "s/;\?opcache\.validate_timestamps.*/opcache.validate_timestamps = 0/" /etc/php/$php/fpm/php.ini
sed -i "s/;\?opcache\.save_comments.*/opcache.save_comments = 1/" /etc/php/$php/fpm/php.ini
# sed -i "s/;\?opcache\.fast_shutdown.*/opcache.fast_shutdown = 1/" /etc/php/$php/fpm/php.ini
