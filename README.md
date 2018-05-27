# Amazon Linux 2 for Vagrant

From [Amazon Linux 2][al2]:

> Amazon Linux 2 is the next generation of Amazon Linux, a Linux server operating system from Amazon Web Services (AWS). It is designed to provide a secure, stable, and high performance execution environment for customers to develop and run a wide variety of cloud and enterprise applications. With Amazon Linux 2, customers get an application environment that offers long term support with access to the latest innovations in the Linux community.

## Using the Amazon Linux 2 Vagrant Box

If your intention is only to _use_ this box, you can open your `Vagrantfile` and set:

```ruby
config.vm.box = "skyzyx/amazon-linux"
```

* [Vagrant Cloud](https://app.vagrantup.com/skyzyx/boxes/amazon-linux)

## Why Amazon Linux 2?

Amazon Linux 2 (AL2) is the next-generation of Amazon Linux — a lighter-weight OS commonly used with Amazon EC2. Amazon Linux is a fork of CentOS, which in-turn is a fork of Red Hat Enterprise Linux (RHEL).

Previously, I maintained a CentOS 7 Vagrant box. Amazon Linux is a smaller, more focused variation of CentOS, and is a natural progression of the CentOS Vagrant box.

## Why Vagrant instead of Docker?

This is a **bad** question.

A better question is: Why run Docker inside of Vagrant instead of using [Docker for Mac][docker-mac] or [Docker for Windows][docker-win]?

There are a few answers to this:

* **Faster disk I/O** — Vagrant can be configured to use NFS. This results in objectively faster disk I/O than what "native" Docker provides.
* **Easier scripting around Docker tools** — If you want to generate scripts which wrap `docker` or `docker-compose`, it's easier to support a single OS.
* **Shared development environment** — Simplified onboarding for teams. Just install Vagrant, `vagrant up && vagrant ssh`, and you can get straight to work building your Docker images and testing your containers.
* **"Native" Docker isn't truly _native_, so much as _invisible_** — For both [Docker for Mac][docker-mac] or [Docker for Windows][docker-win], a miniature Linux VM is spun-up. This is because Docker leverages a feature that is native to the Linux kernel that does not exist natively in Darwin (macOS) or Windows. Since we have to spin-up a Linux VM anyway, why not take advantage and add some shared tooling that can make your team's development experience easier?

## Building a New Vagrant Box

All instructions were tested against macOS 10.13 “High Sierra”, VMware Fusion 10, VirtualBox 5.1, and Parallels Desktop 11.

  [al2]: https://aws.amazon.com/amazon-linux-2/
  [docker-mac]: https://www.docker.com/docker-mac
  [docker-win]: https://www.docker.com/docker-windows
