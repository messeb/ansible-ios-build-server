
default: setup

install:
	brew install ansible

setup:
	ansible-playbook -i hosts site.yml
