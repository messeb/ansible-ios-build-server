# Ansible iOS Build Server Provisioning

Status: in progress

The repository provides an Ansible Playbook for automated provisioning of macOS systems with Xcode, Homebrew and Ruby. Such a provisioned system can be used to build iOS apps via [Jenkins Pipelines](https://jenkins.io/solutions/pipeline/) or [GitLab CI/CD](https://about.gitlab.com/product/continuous-integration/). 

## Configuration steps

* Add nodes and their configuration to [hosts](./hosts)
* Add Apple Developer credentials to [ios-build-servers.yml](./group_vars/ios-build-servers.yml). It will be used for the Xcode download from the Apple Developer portal.
* Set Xcode and Ruby version in [ios-build-servers.yml](./group_vars/ios-build-servers.yml)

## Execution

```
ansible-playbook -i hosts site.yml
```

## What is Ansible?

Ansible is a software for the centralized management and administration of distributed servers. It helps to simplify the administration of servers and to automate their configuration processes. Instead of logging on to multiple macOS systems and manually installing the latest Xcode version, you can describe the execution steps in a YAML syntax and execute them remotely on various systems in parallel via SSH. The execution can always be repeated and still leads to the same result.

Ansible comes as a command line tool. This CLI will be executed on a controlling machine and sends shell commands to nodes via SSH. The controlling machine could be your computer (or a CI Runner), and the nodes are the macOS build servers.

On your computer, you execute via Ansible CLI predefined execution steps with a host file, which contains the hostname / IP addresses and individual SSH login information for the nodes. For each node, a connection is established between your computer and the node. On the node, the Ansible CLI is executing shell commands to install and configure the need components to get the desired configuration state. The results are the automated provisioned systems.

To get deeper into this topic have a look at the [Get Started](https://docs.ansible.com/ansible/latest/user_guide/intro_getting_started.html) guide of Ansible.

If you have a collection of different commands and expected configuration states, you will create an [Ansible Playbook](https://docs.ansible.com/ansible/latest/user_guide/playbooks.html) of it. 

## Required components on an iOS build server

An iOS build often consists of several steps. You install your dependencies with Cocoapods or Carthage, analyze the code with e.g. [Swiftlint](https://github.com/realm/SwiftLint), build the app with [fastlane](https://fastlane.tools/) and want to distribute the app via [HockeyApp](https://hockeyapp.net/), [Beta by Crashlytics](http://try.crashlytics.com/beta/) or the App Store.
Of course, you have to have Xcode installed on the build server, but that's usually not enough. However, only a basic set of tools should be installed, and the iOS project should bring the rest itself. A solution can be seen in my GitHub project: [Setup an iOS project environment - https://github.com/messeb/ios-project-env-setup](https://github.com/messeb/ios-project-env-setup)

The basic tools are:

* [Xcode](https://developer.apple.com/xcode/): Of course xcodebuild is needed to build an iOS app.

* [Homebrew](https://brew.sh): It is the missing package manager for macOS. This provides a basis for installing other packages within a project. For example, this could be SwiftLint or Carthage.

* [RVM](https://rvm.io/): The Ruby Version Manager allows you to install and change a Ruby from the command line. Ruby is the base for many iOS tools, such as Cocoapods and fastlane. 
