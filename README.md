# Janus

![Build status](https://github.com/ARandomChap/janus/actions/workflows/build.yml/badge.svg?branch=main)

This repo houses all the configuration needed to provision a host development machine for current projects. It will cater for:

- Mac
- Windows Subsystem for Linux

The intention is to get your host machine ready to code by just running a single command in your terminal/prompt

## Mac

To use the Ansible scripts to provision your mac you will require the following pre-requisites:

- [Brew](https://brew.sh/)
- Ansible - install via Brew (`brew install ansible`)

There are two roles to setup a mac.

A generic mac role:

```shell
make provision-mac
```

This will:

- Get and apply all updates to your mac
- Setup a minimal bash profile
- Setup a minimal zsh and oh-my-zsh for terminal
- Install the following brew packages (not exhaustive)
  - [AWS CLI](https://aws.amazon.com/cli/)
  - [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html)
  - [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/)
  - [bash](https://www.gnu.org/software/bash/)
  - [bash completion](https://salsa.debian.org/debian/bash-completion)
  - [composer](https://getcomposer.org/)
  - [cowsay (Very important)](https://github.com/tnalpgge/rank-amateur-cowsay)
  - [CNF Lint](https://github.com/aws-cloudformation/cfn-python-lint/)
  - [curl](https://curl.haxx.se/docs/manpage.html)
  - [Docker CLI](https://www.docker.com/)
  - [git](https://git-scm.com/)
  - [GitHub CLI](https://github.com/cli/cli)
  - [gnu-sed](https://www.gnu.org/software/sed/) Please note: This will be set as default `sed` so you do not need to used `gsed`
  - [Go](https://golang.org/)
  - [jq](https://stedolan.github.io/jq/)
  - [jmeter](https://jmeter.apache.org/)
  - [Helm](https://helm.sh/)
  - [kubectl](https://kubernetes.io/docs/reference/kubectl/)
  - [k9s](https://k9scli.io/)
  - [minikube](https://minikube.sigs.k8s.io/docs/)
  - [Mono](https://www.mono-project.com/)
  - [node@16](https://nodejs.org/en/)
  - [pipenv](https://pipenv.pypa.io/en/latest/)
  - [pyenv](https://github.com/pyenv/pyenv)
  - [ShellCheck](https://www.shellcheck.net/)
  - [Terraform](https://www.terraform.io/)
  - [Terragrunt](https://terragrunt.gruntwork.io/)
  - [TFLint](https://github.com/terraform-linters/tflint)
  - [vim](https://www.vim.org/)
  - [wget](https://www.gnu.org/software/wget/)
  - [XMLStarlet](http://xmlstar.sourceforge.net/)
  - [yq](https://mikefarah.gitbook.io/yq/)
- Install the following brew casks
  - [.NET SDK 3.1, 5.0 & 6.0](https://github.com/isen-ng/homebrew-dotnet-sdk-versions)
  - [Multipass](https://multipass.run/)
  - [Open JDK](https://openjdk.java.net/)
  - [Postman](https://www.getpostman.com/)
  - [Slack](https://slack.com/)
  - [Visual Studio Code](https://code.visualstudio.com/)
- Install some gem bundles
  - Mainly for js documentation generation
- Install some node packages
  - [AWS CDK](https://aws.amazon.com/cdk/)
  - [galenframework-cli](https://github.com/hypery2k/galenframework-cli)
  - [grunt](https://gruntjs.com/)
  - [gulp-cli](https://gulpjs.com/)
  - [less](http://lesscss.org/)
  - [Typescript](https://www.typescriptlang.org/)
  - [underscore](https://github.com/ddopson/underscore-cli#readme)
- Python 3.7.3 via pyenv and set as global

### Multipass as a Docker Desktop replacement

[Docker Desktop](https://www.docker.com/products/docker-desktop) will require a paid subscription for business use from February 2022. Multipass is an alternative to Docker Desktop. The Ansible scripts will uninstall Docker Desktop and install Docker and Multipass with some additional config and script to start a [Multipass VM to host Docker](https://dev.to/benmatselby/use-docker-context-to-switch-between-different-solutions-3e0b). You will need to have [generated your SSH public key](https://git-scm.com/book/en/v2/Git-on-the-Server-Generating-Your-SSH-Public-Key) as these are used in the Multipass config to allow your host machine to `ssh` into the VM Multipass will create.

After you have provisioned your machine run the following commands to start the Multipass VM.

```shell
cd ~/.multipass
./create-docker-vm.sh
```

The following environment variables can be used in conjunction with the create-docker-vm.sh script:

- `MULTIPASS_CPU_COUNT` - CPU count (default 4)
- `MULTIPASS_MEMORY` - Memory (default 4G)
- `MULTIPASS_DISK_SPACE` - Disk space (default 40G)
- `MULTIPASS_UBUNTU_VERSION` - Ubuntu version (default 20.04)
- `MULTIPASS_INSTANCE_NAME` - Instance name (default `docker-multipass`)

You will need to `ssh` into the VM to accept the authenticity of the host.

```shell
ssh ubuntu@docker-multipass.local
```

NOTE: Replace `docker-multipass` if you did not use the default instance name.

You will then be able to use the [Docker CLI](https://docs.docker.com/engine/reference/commandline/cli/) to manage docker containers.

You can install [Portainer Community Edition](https://docs.portainer.io/) as an alternative to the Docker Desktop UI using the following script:

```shell
cd ~/.multipass
./install-portainer.sh
```

### OS X Quirks

#### Docker Hanging

When setting up a new instance with a different name; docker can stop working and hang when running any `docker ..` command. Adding the following to the `~/.zshrc` file resolved the issue. Make sure you replace `{instance}` with your given name - `export DOCKER_HOST="ssh://ubuntu@{instance}.local"`

### Error Obtaining Credentials

`docker-compose` can face issues accessing the credentials store within docker. This can be fixed by updating the docker config file; default `~/.docker/config.json`. Then editing or adding the config value `"credsStore": "osxkeychain",`

If the issue persists with `docker-compose` not using the correct `credsStore` property, installing the following package should fix this `brew install docker-credential-helper`.

Note: This was encountered while running `docker-compose`. Unclear if this is specific to `docker-compose` or `docker` its self.

## Windows Subsystem for Linux

This section is for provisioning Linux under the Windows Subsystem for Linux (WSL). It assumes you are installing the Ubuntu 20.04 distribution, which as of writing, is the latest [Ubuntu LTS](https://wiki.ubuntu.com/Releases).

First you need to [install the WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10). `wsl --install` will provide you with the latest LTS of Ubuntu. If you have already setup some of the common tools on your Windows machine you may also need to following this [guide](https://github.com/microsoft/WSL/issues/1640#issuecomment-335034046) to fix your Linux `$PATH` in WSL.

You will need to install some pre-requisites prior to running the provisioning scripts. Open the Ubuntu 20.04 WSL console and type the following commands:

```shell
sudo apt update
sudo apt upgrade
sudo apt install make
sudo apt install ansible
```

> Some may experince issues with DNS configuration that prevent apt resolving. In this case it is recommend to follow the steps [here](https://askubuntu.com/questions/91543/apt-get-update-fails-to-fetch-files-temporary-failure-resolving-error). If `resolv.conf` is overwrtten on each startup up of WSL then you can also follow the instructions [here](https://github.com/microsoft/WSL/issues/4285#issuecomment-522201021) for a persistent solution.

With `make` & `ansible` installed, clone this repo and run the provision command in the WSL console:

```shell
make provision-wsl
```

> Ansible uses [BECOME](https://docs.ansible.com/ansible/latest/user_guide/become.html) to execute root privileges, enter your `sudo` password when prompted for this. As a lot of these actions will require root privileges.

This will:

- Perform an `apt` update and upgrade
- Install the following `apt` packages:

  - [AWS CLI](https://aws.amazon.com/cli/) (NOTE: You will need to [configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) the AWS CLI in the WSL console)
  - [Azure CLI](https://github.com/Azure/azure-cli)
  - cowsay (very important)
  - [curl](https://curl.haxx.se/)
  - [Docker](https://www.docker.com/)
  - [Git](https://github.com/git/git)
  - [GitHub CLI](https://cli.github.com/manual/)
  - [Go](https://golang.org/)
  - [Helm](https://helm.sh/)
  - [jq](https://stedolan.github.io/jq/)
  - [.NET](https://docs.microsoft.com/en-us/dotnet/)
  - [Node.js 16](https://nodejs.org/)
  - [Shellcheck](https://github.com/koalaman/shellcheck)
  - [yq](https://mikefarah.gitbook.io/yq/)
  - [Zip](http://infozip.sourceforge.net/Zip.html)

- Install the following independently:
  - [Terraform](https://www.terraform.io/)
  - [Terragrunt](https://terragrunt.gruntwork.io/)

If you have already configured the AWS CLI on Windows you can use your AWS config in the WSL by creating the following environment variables:

```shell
AWS_CONFIG_FILE=/mnt/c/Users/<your-windows-username>/.aws/config
AWS_SHARED_CREDENTIALS_FILE=/mnt/c/Users/<your-windows-username>/.aws/credentials
```

If you using [Visual Studio Code](https://code.visualstudio.com/) on your host Windows machine I would also recommend following [this guide](https://code.visualstudio.com/docs/remote/wsl) to setup Visual Studio Code to use WSL.

### Docker on WSL

Most Linux distributions use `systemd` as the init system. It manages things like startup, shutdown & service monitoring, however WSL does not employ this. Docker for Linux should start by default, but since `systemd` is not used the usual startup routine is not initiated. This unfornunately means that there is no easy way to start it at startup of WSL. Therefore `sudo service docker start` will need to be run from every cold start of WSL.

If this is too much hard work for you, then you can follow some instruction [here](https://blog.nillsf.com/index.php/2020/06/29/how-to-automatically-start-the-docker-daemon-on-wsl2/) to do so as part of your `.bashrc`.

## Usage

To provision a Mac run the following:

```bash
make provision-mac
```

To provision the Windows Subsystem for Linux run the following:

```bash
make provision-wsl
```

## .NET versions

Janus installs multiple version of .NET via SDKs. When running a .NET command, .NET will attempt to determine the correct SDK version to use by reading this from a `global.json` file. .NET will look in the current directory and work up the tree to your root folder until it finds one, if none is found it will use the latest .NET version available.

The easiest way to fix a project to a version is to add the below into a `global.json` file within the projects root with the relevant version number.

```json
{
  "sdk": {
    "version": "5.0.404"
  }
}
```

To read more on `global.json` files, you can [find the docs here][dotnet-global-json].

[dotnet-global-json]: https://docs.microsoft.com/en-us/dotnet/core/tools/global-json?tabs=netcore3x
