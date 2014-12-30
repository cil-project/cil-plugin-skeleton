# CIL plugin skeleton

Build skeleton and examples of simple CIL plugins.

**These instructions do not apply to CIL ≤ 1.7.3.**

## Prerequisites

You need [Ocaml](http://ocaml.org/) ≥ 3.12 and
[findlib](http://projects.camlcity.org/projects/findlib.html).

For instance, on Debian or Ubuntu:
```
apt-get install ocaml ocaml-findlib
```

Then, download and install the latest CIL snapshot:
```
git clone https://github.com/cil-project/cil
cd cil
./configure
make
make install
```

### Note for OPAM users

If you use [opam](http://opam.ocamlpro.com/), it is **strongly**
recommended to use the following `configure` invocation:

```
./configure --prefix=`opam config var prefix`
```

## Writing your plugin

This is very similar to writing a CIL feature for CIL ≤ 1.7.3.
See [countCalls.ml](countCalls.ml) for an example. The
significant changes in the API are:

+ `open Feature` in addition to `open Cil`;
+ `Cil.featureDescr` becomes `Feature.t`;
+ the field `fd_enabled` is now a `mutable bool` (instead of a `bool ref`);
+ features must be registered with `Feature.register`.

You do **not** need to copy you plugin inside CIL's tree or to use
`EXTRA_FEATURES` anymore.

## Compiling your plugin

Build a `.cma` and a `.cmxs` for your plugin:
```
ocamlbuild -use-ocamlfind -package cil countCalls.cma countCalls.cmxs
```

You can of course compile using any other tool (Makefile, CMake, oasis, etc.).

## Installing your plugin (optional)

To make your plugin globally available and use it more easily, you need
to write a [META](META) file. Then, install your plugin with
ocamlfind:
```
ocamlfind install countCalls META _build/countCalls.cma _build/countCalls.cmxs
```

To uninstall your plugin:
```
ocamlfind remove countCalls
```

### Note on plugin dependencies

It is possible to use `require` in your META file to indicate module
dependencies: CIL will then load the required dependencies before your
plugin. However, do **not** use `require="cil"` because it would load
CIL twice and your module would fail to register.

## Loading your plugin directly

To load your plugin, use the flag `--load=...`. It is possible to use
`--load` multiple times; plugins are loaded in the order given on the
command-line.

### Bytecode

```
cilly --bytecode --load=_build/countCalls.cma --help
```

### Native

```
cilly --load=_build/countCalls.cmxs --help
```

## Loading your plugin with ocamlfind

**This is the recommended way to load your plugin.**
You need to have installed it first (see above).

### Bytecode

```
cilly --load=countCalls --bytecode --help
```

### Native

```
cilly --load=countCalls --help
```

## Loading all features provided with CIL

By default, CIL loads `cil.default-features`. To load all features
provided with CIL, use:
```
cilly --load=cil.all-features --help
```

To list the available features, you can use:
```
ocamlfind list | grep ^cil
```

## Setting up your own default features

If you don't want to use `--load` each time you call `cilly`, you can
set the environment variable `CIL_FEATURES`:
```
CIL_FEATURES="cil.default-features,countCalls"
export CIL_FEATURES
cilly --help
```
You can also give absolute paths to your `.cma` or `.cmxs` in
`CIL_FEATURES` if you don't want to install your module.

Hint: if you don't need CIL default features, you can just set
`CIL_FEATURES="countCalls"`.
