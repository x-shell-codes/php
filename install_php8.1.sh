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
  echo "-l | --isLocal     Is local env (auto-deject). Values: true, false"
  echo "-o | --OPCache     Install OPCache. Values: true, false"
  echo "-h | --help        Display this help."
  echo "-V | --version     Print software version and exit."
  echo
  echo "For more details see https://github.com/x-shell-codes/php."
}

########################################################################################################################
# Arguments Parsing                                                                                                    #
########################################################################################################################
isLocal=false
if [ -d "/vagrant" ]; then
  isLocal=true
fi

OPCache=false
for i in "$@"; do
  case $i in
  -l=* | --isLocal=*)
    isLocal="${i#*=}"

    if [ "$isLocal" != "true" ] && [ "$isLocal" != "false" ]; then
      ErrorLine "Is local value is invalid."
      Help
      exit
    fi

    shift
    ;;
  -o=* | --OPCache=*)
    OPCache="${i#*=}"

    if [ "$OPCache" != "true" ] && [ "$OPCache" != "false" ]; then
      ErrorLine "OPCache value is invalid."
      Help
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
echo "${POWDER_BLUE_LINE}${BRIGHT_LINE}${REVERSE_LINE}PHP 8.1 INSTALLATION${NORMAL_LINE}"

CheckRootUser

export DEBIAN_FRONTEND=noninteractive

apt-add-repository ppa:ondrej/php -y

apt install -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y --force-yes php8.1-fpm \
  php8.1-cli php8.1-dev php8.1-mysql php8.1-mongodb php8.1-sqlite3 php8.1-pgsql php8.1-sybase php8.1-dba php8.1-redis \
  php8.1-interbase php8.1-odbc php8.1-xml php8.1-gd php8.1-curl php8.1-memcached php8.1-imap php8.1-msgpack php8.1-dom \
  php8.1-tidy php8.1-mbstring php8.1-zip php8.1-bcmath php8.1-soap php8.1-intl php8.1-readline php8.1-gmp php8.1-bz2 \
  php8.1-xsl php8.1-igbinary php8.1-swoole php8.1-ldap php8.1-common php8.1-enchant php8.1-pspell php8.1-snmp

# Misc. PHP CLI Configuration
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.1/cli/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.1/cli/php.ini
sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/8.1/cli/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.1/cli/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.1/cli/php.ini

# Tweak Some PHP-FPM Settings
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.1/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = Off/" /etc/php/8.1/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/8.1/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.1/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.1/fpm/php.ini

# Configure FPM Pool Settings
sed -i "s/^user = www-data/user = deployer/" /etc/php/8.1/fpm/pool.d/www.conf
sed -i "s/^group = www-data/group = deployer/" /etc/php/8.1/fpm/pool.d/www.conf
sed -i "s/;listen\.owner.*/listen.owner = deployer/" /etc/php/8.1/fpm/pool.d/www.conf
sed -i "s/;listen\.group.*/listen.group = deployer/" /etc/php/8.1/fpm/pool.d/www.conf
sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/8.1/fpm/pool.d/www.conf
sed -i "s/;request_terminate_timeout.*/request_terminate_timeout = 60/" /etc/php/8.1/fpm/pool.d/www.conf

# Ensure PHPRedis Extension Is Available
echo "Configuring PHPRedis"
echo "extension=redis.so" >/etc/php/8.1/mods-available/redis.ini
yes '' | apt install -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y --force-yes php8.1-redis

# Ensure Imagick Is Available
echo "Configuring Imagick"
apt install -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y --force-yes libmagickwand-dev
echo "extension=imagick.so" >/etc/php/8.1/mods-available/imagick.ini
yes '' | apt install -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y --force-yes php8.1-imagick

# Configure FPM Pool Settings
sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/8.1/fpm/pool.d/www.conf
sed -i "s/;request_terminate_timeout.*/request_terminate_timeout = 60/" /etc/php/8.1/fpm/pool.d/www.conf

# Optimize FPM Processes
sed -i "s/^pm.max_children.*=.*/pm.max_children = 20/" /etc/php/8.1/fpm/pool.d/www.conf

# Ensure Sudoers Is Up To Date
ALL=NOPASSWD: /usr/sbin/service php8.1-fpm reload

# Configure Sessions Directory Permissions
chmod 733 /var/lib/php/sessions
chmod +t /var/lib/php/sessions

# Write Systemd File For Linode
update-alternatives --set php /usr/bin/php8.1

if [ "$isLocal" == "true" ]; then
  rm /etc/php/8.1/mods-available/xdebug.ini
  touch /etc/php/8.1/mods-available/xdebug.ini

  cat >>/etc/php/8.1/mods-available/xdebug.ini <<EOF
xdebug.idekey="PHPSTORM"
xdebug.remote_enable=1
xdebug.remote_connect_back=1
xdebug.remote_port=9000
xdebug.max_nesting_level=300
xdebug.scream=0
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF
fi

if [ -f "opcache_enable.sh" ]; then
  bash opcache_enable.sh --php=8.1
else
  wget https://raw.githubusercontent.com/x-shell-codes/php/master/opcache_enable
  bash opcache_enable.sh --php=8.1
  rm opcache_enable.sh
fi
