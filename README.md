# Amazon Linux 2 for Vagrant

From [Amazon Web Services][al2]:

> Amazon Linux 2 is the next generation of Amazon Linux, a Linux server operating system from Amazon Web Services (AWS). It is designed to provide a secure, stable, and high performance execution environment for customers to develop and run a wide variety of cloud and enterprise applications. With Amazon Linux 2, customers get an application environment that offers long term support with access to the latest innovations in the Linux community.

## Using the Amazon Linux 2 Vagrant Box

If your intention is only to _use_ this box, you can open your `Vagrantfile` and set:

```ruby
config.vm.box = "skyzyx/amazon-linux"
```

See [Vagrant Cloud](https://app.vagrantup.com/skyzyx/boxes/amazon-linux) for more information.

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

There are plenty of cases where "native" Docker is perfectly adequate, such as small projects with single-digit developers. But if you have a team of developers that you are supporting, disk I/O is important, or simply want to experiment with Amazon Linux 2 before pusing to production, the Amazon Linux 2 Vagrant box is intended to simplify your life.

### What do you install on top of the base image?

These images are based on a minimal install of Amazon Linux 2. On top of that base installation, we install the following:

* TBD

## Prerequisites

* [Packer](https://www.packer.io/downloads.html) 1.2.3 or newer.
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads), for building the VirtualBox Vagrant box.
  * [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest) plug-in to keep VirtualBox tools up-to-date.
* [VMware Fusion](http://www.vmware.com/products/fusion), for building the VMware Vagrant box.
  * [Vagrant Provider for VMware](https://www.vagrantup.com/docs/vmware/installation.html) plug-in to enable Vagrant to use VMware as a provider.
* [Parallels Desktop](http://www.parallels.com/products/desktop/download/), for building the Parallels Vagrant box.
  * [Parallels Virtualization SDK for Mac](http://www.parallels.com/download/pvsdk/) so that your Mac can talk to Parallels through Vagrant.
  * [vagrant-parallels](http://parallels.github.io/vagrant-parallels/) plug-in to enable Vagrant to use Parallels as a provider.
* [vagrant-cachier](http://fgrehm.viewdocs.io/vagrant-cachier/) plug-in to enable caching of `yum` packages.
* [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater) plug-in to automatically updated your hosts file.
* `openssl`
* `cdrtools`
* `gpg`

### Prerequisites for VMware (skip if building a different box)

If you are _building_ a Vagrant box for VMware Desktop (Fusion or Workstation), you need to follow these steps first.

1. Install `ovftool` from VMware. This is required in order to convert the image that AWS provides (for VMware ESX/ESXi Server) into a format that is compatible with VMware for Desktop.

1. After installation, you may need to add `ovftool` to your `$PATH`.

   ```bash
   export PATH="/Applications/VMware OVF Tool":$PATH
   ```

1. From the root of the repository, run `fetch-vmware-image.sh`.

   ```bash
   ./fetch-vmware-image.sh
   ```

## Updating your Plug-Ins

This is simply a good thing to do from time to time.

```bash
vagrant plugin update
```

## Installing Packer

I'm going to assume that you have already:

1. Installed Vagrant and its dependencies.
1. Installed (and paid for) the virtualization software of your choice.

You have two choices for installing Packer.

1. If you already have the [Homebrew](http://brew.sh) package manager installed, you can simply do:

 ```bash
 brew install packer
 ```

1. Otherwise, you can manually install it from <https://www.packer.io/downloads.html>.

See “[Install Packer](https://www.packer.io/intro/getting-started/setup.html)” for more information.

## Building Vagrant Boxes

### Build everything

This template has built-in support for VMware. You can build everything at the same time (assuming you have the relevant prerequisites installed) with:

```bash
packer build template.json
```

### Build only one

If you only want to build one particular Vagrant box, you can use the `--only` flag.

```bash
# VMware
packer build --only=vmware-vmx template.json
```

  [al2]: https://aws.amazon.com/amazon-linux-2/
  [cloud-init]: https://cloudinit.readthedocs.io
  [docker-mac]: https://www.docker.com/docker-mac
  [docker-win]: https://www.docker.com/docker-windows
