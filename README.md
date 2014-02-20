zvm-jenkins
===========

ZeroVM Jenkins scripts and job configurations

Here you will find the various scripts used for continuous
integration/build/test. This scripts are currently in use at ci.oslab.cc.

Ubuntu Packaging
----------------

`packager.py` is a generic script to generate packages from single merge
commits. It does so by taking a snapshot of the git repo (sans the debian/
directory) in the current working directory and creating a source package. It
can optionally publish the package directly to a PPA. This is useful to
automate the production and publishing of packages for nightly builds.

NOTE: In order for full automation to work, a gpg key either with a) a running
gpg agent or b) no passphrase needs to be available to sign and publish a
package to the specified PPA.

A typical invocation of `packager.py` would look like this:

    $ python /path/to/packager.py "Lars Butler (larsbutler)" \
      lars.butler@gmail.com

To publish to a PPA, simply append the PPA path to the arguments:

    $ python /path/to/packager.py "Lars Butler (larsbutler)" \
      lars.butler@gmail.com ppa:lars-butler/zerovm-latest

NOTE: The name, nickname (in parentheses), and email need to match _exactly_
those in the packager's gpg key.
