HOME ?= `$HOME`

explain:
	### Welcome
	#
	# Makefile for provisioning development machines
	#                                                                                    
	# 						jjjj                                                                       
	# 						j::::j                                                                      
	# 						jjjj                                                                       
	#																																												
	# 					jjjjjjj  aaaaaaaaaaaaa  nnnn  nnnnnnnn    uuuuuu    uuuuuu      ssssssssss   
	# 					j:::::j  a::::::::::::a n:::nn::::::::nn  u::::u    u::::u    ss::::::::::s  
	# 						j::::j  aaaaaaaaa:::::an::::::::::::::nn u::::u    u::::u  ss:::::::::::::s 
	# 						j::::j           a::::ann:::::::::::::::nu::::u    u::::u  s::::::ssss:::::s
	# 						j::::j    aaaaaaa:::::a  n:::::nnnn:::::nu::::u    u::::u   s:::::s  ssssss 
	# 						j::::j  aa::::::::::::a  n::::n    n::::nu::::u    u::::u     s::::::s      
	# 						j::::j a::::aaaa::::::a  n::::n    n::::nu::::u    u::::u        s::::::s   
	# 						j::::ja::::a    a:::::a  n::::n    n::::nu:::::uuuu:::::u  ssssss   s:::::s 
	# 						j::::ja::::a    a:::::a  n::::n    n::::nu:::::::::::::::uus:::::ssss::::::s
	# 						j::::ja:::::aaaa::::::a  n::::n    n::::n u:::::::::::::::us::::::::::::::s 
	# 						j::::j a::::::::::aa:::a n::::n    n::::n  uu::::::::uu:::u s:::::::::::ss  
	# 						j::::j  aaaaaaaaaa  aaaa nnnnnn    nnnnnn    uuuuuuuu  uuuu  sssssssssss    
	# 						j::::j                                                                      
	# 	jjjj      j::::j                                                                      
	# j::::jj   j:::::j                                                                      
	# j::::::jjj::::::j                                                                      
	# 	jj::::::::::::j                                                                       
	# 		jjj::::::jjj                                                                        
	# 				jjjjjj                                                                           
	#
	#
	### Setup
	#
	# -> $$ make setup
	#
	# To use the Ansible scripts to provision your Mac you will require the following:
	# - Brew (https://brew.sh/)
	# - Ansible (install via Brew)
	#
	### Installation
	#
	#  -> $$ make provision-[SYSTEM NAME]
	#
	### Targets
	@cat Makefile* | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

provision: setup-git-config ansible ## Provision your host machine

.PHONY: setup-git-config
setup-git-config: ## Setup the gitconfig in your home directory if not already configured
ifeq ("$(wildcard $(HOME)/.gitconfig)","")
	@echo "Enter your full name - This is how git will report your work";
	@read name; \
	git config --global user.name "$$name"

	@echo "Enter your work email address";
	@read email; \
	git config --global user.email $$email
endif

.PHONY: check-remote-container
check-remote-container:
ifdef REMOTE_CONTAINERS
	$(error "You're attempting to run inside a remote container. When provisioning with Janus")
endif

.PHONY: provision-mac
provision-mac: setup ## Run the ansible playbooks to provision your Mac
	ansible-playbook -i ansible/hosts ansible/mac.yml --verbose

.PHONY: provision-wsl
provision-wsl: setup ## Run the ansible playbooks to provision your Linux machine via the Windows Subsystem for Linux
	ansible-playbook -i ansible/hosts ansible/wsl.yml --extra-vars "linux_distro_codename=$(shell lsb_release -cs) linux_distro_version=$(shell lsb_release -rs)" --verbose --ask-become-pass

.PHONY: vet
vet:
	@echo "Vetting the mac playbook"
	ansible-playbook ansible/mac.yml --syntax-check
	@echo "✔ Done"

	@echo "Vetting the wsl playbook"
	ansible-playbook ansible/wsl.yml --syntax-check
	@echo "✔ Done"

.PHONY: lint
lint:
	@echo "Linting the mac playbook"
	docker run --rm -v $$PWD:/data cytopia/ansible-lint "ansible/mac.yml"

	@echo "Linting the wsl playbook"
	docker run --rm -v $$PWD:/data cytopia/ansible-lint "ansible/wsl.yml"

.PHONY: setup
setup: ## Set up githooks
	@echo "Set up Githooks"
	cp scripts/githooks/* .git/hooks/
