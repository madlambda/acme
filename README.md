# ACME tools

This project aims to provide an easy way to have cool
tools to integrate on ACME, like code formatting, going to
definitions of functions, etc.

The idea is to do this on the ACME spirit, integrating
with external tools. So this is basically a collection
of tools to use on ACME.


# Dependencies

You will need the latest stable version of [nash](https://github.com/NeowayLabs/nash)
and [Go](https://golang.org/) to install and use the tools here.

You also need go get to install binaries that can be found on your operating system
(like adding $GOPATH/bin on your $PATH, or whatever works for you).


# Install

Just run:

```sh
./install.sh
```

We try to apply a pretty nifty idea from the
[ACME paper](http://www.vitanuova.com/inferno/papers/acme.pdf) here:

```
Acmes context rules find the appropriate binaries in
/acme/edit rather than /bin ;  the effect is to turn
/acme/edit into a  toolbox containing tools and instructions
(the guide file) for their use.

In fact, the source for these tools is also there,
in the directory /acme/edit/src . 

This setup allows some control of the file name space
for binary programs; not only does it group related programs,
it permits the use of common names for uncommon jobs.

For example,the single-letter names would be unwise in 
directory in everyone's search path;
here they are only visible when  running editing commands.
```

But instead of using /acme/edit we use $PLAN9/acme/edit.
This does not seem to be a problem since defining a **PLAN9** environment
is expected to install [plan9port](https://github.com/9fans/plan9port).

If you really don't like the idea you can run:

```sh
./install.sh <somedir>
```

And it will install the tools there.

# Tools

So what tools comes in this project ?

## Formatting

We have formatting available for the following languages:

* Go
* Nash

Just running **fmt** should automatically work. If you are having
problems with **fmt** you can use:

* **gofmt** for Go code
* **nshfmt** for Nash code

## Go

After installing you will have access to all the functionality
described [here](https://github.com/madlambda/A). We provide more
familiar aliases like:

* godoc = A doc
* godef = A def
* goref = A refs
* goren <name> = A rn <name>
* gocs = A cs
* gopeers = A peers
* goshare = A share
