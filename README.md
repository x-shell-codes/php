# PHP

PHP install script for Ubuntu 22.04

## Features

* Automatically local environment detection,
* OPCache enabled feature.

## Requirements

* Ubuntu (tested on Ubuntu 22.04, Ubuntu 20.04, Ubuntu 18.04, Ubuntu 16.04, Ubuntu 14.04)

## Installation

```
wget https://raw.githubusercontent.com/x-shell-codes/php/master/php.sh
sudo bash php.sh
```

#### Options
- -p | --php         PHP Version (8.1)
- -l&nbsp; | --isLocal     Is local env (auto-deject). Values: true, false"
- -o | --OPCache     Install OPCache. Values: true, false"

### OPCache Install

```
wget https://raw.githubusercontent.com/x-shell-codes/php/master/opcache_enable.sh
sudo bash opcache_enable.sh
```

#### Options
- -p | --php         PHP Version (8.1)

## Attentions

* When creating a swap area, there must be enough space for the file to be created.
* DO NOT RUN THIS SCRIPT ON YOUR PC OR MAC!

## Security Vulnerabilities

If you discover a security vulnerability within project, please send an e-mail to Mehmet ÖĞMEN
via [www@mehmetogmen.com.tr](mailto:www@mehmetogmen.com.tr). All security vulnerabilities will be promptly addressed.

## License

Copyright (C) 2022 [Mehmet ÖĞMEN](https://github.com/X-Adam)
This work is licensed under
the [Creative Commons Attribution-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/)  
Attribution Required: please include my name in any derivative and let me know how you have improved it!
