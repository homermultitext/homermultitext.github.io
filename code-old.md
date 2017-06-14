---
title: Code projects for HMT
layout: page
---

We depend on many code libaries, and especially on implementations of the [CITE architecture's generic data models](http://cite-architecture.github.io/), but sometimes we need programs addressing very specific needs of the HMT project.


## HMT project utilities ##


`hmt-utils` is a JVM library for analyzing texts following the specific editorial conventions of the HMT project. It includes code for tokenizing XML editions, and validating archival data following the HMT project guidelines.

 -  [web site](http://homermultitext.github.io/hmt-utils/)
 -  [github repository](https://github.com/homermultitext/hmt-utils)

## MOM ##


Mandatory On-going Maintenance (`hmt-mom`) is a gradle build project for validating and verifying editorial work for the HMT project.  It assembles a single archive from project data in various XML and `.csv` files, then uses the `hmt-utils` library to analyze the contents.

- [web site](http://homermultitext.github.io/hmt-mom)
- [github repository](https://github.com/homermultitext/hmt-mom)


## The HMT virtual machine for editors ##

The HMT virtual machine for editors is an Ubuntu virtual machine with all software needed to edit and validate material for the HMT project preinstalled.  The VM for the 2015-2016 academic year is available here:

- [web site](http://homermultitext.github.io/vm2015/)
- [github repository](https://github.com/homermultitext/vm2015)


## HMT archive ##

The `hmt-archive` git repository includes, in addition to all of our archival data, a build system for publishing release versions of our data.  The build system includes tasks for verifying the contents of the archive, assembling the individual components into publishable packages, and publishing the packages to a Nexus server where they can be retrieved by automated systems using maven coordinates.  The packages include an  expression of the entire contents of the HMT archive in a single RDF file that can be loaded into a SPARQL endpoint.

- [web site](http://homermultitext.github.io/hmt-archive)
-  [github repository](https://github.com/homermultitext/hmt-archive)

## HMT Digital services

`hmt-digital` is a servlet that understands the RDF vocabulary used by the HMT archive.  It supports the CITE architecture's service APIs, and also offers minimal end-user interfaces to the HMT project's material.

- web site (forthcoming: not yet online)
- [github repository](https://github.com/homermultitext/hmt-digital)



## In progress: an HMT Digital VM

`hmt-digital-vm` is a virtual machine with HMT Digital services and data preinstalled.  With this VM, anyone can host the complete HMT archive, and replicate the project's public installation at <http://www.homermultitext.org/hmt-digital>.
