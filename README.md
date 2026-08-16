# odinclap
![GitHub Tag](https://img.shields.io/github/v/tag/cykreet/odinclap)

This repo is setup to pull the most recent version of [`clap`](https://github.com/free-audio/clap) every week. If it's a published version newer than our latest tag, we pull the version content, generate odin bindings with [`odin-c-bindgen`](https://github.com/karl-zylinski/odin-c-bindgen) and open a pull request.

## usage

### git (submodules)

Replace `deps/clap` with the directory you'd like to place the submodule in, and replace `1.2.10` with the relevant version (there is no `latest` branch, and `1.2.10` is the earliest branch available).

```
git submodule add git@github.com:cykreet/odinclap.git deps/clap
git submodule set-branch --branch 1.2.10 -- deps/clap
git submodule update --remote deps/clap/
```

## binding generation

The final bindings are generated as a result of the following process:

1. Clone clap, as previously mentioned.
2. A set of "footers" are contained in `bindings/footers` which are manually maintained files that include constants from the original header files, these aren't normally included in the bindings generated with `odin-c-bindgen`. The footer files are copied next to the source header files, `odin-c-bindgen` finds these and inserts their content near the bottom of the generated odin file.
3. We then generate the bindings with `odin-c-bindgen`, which outputs the odin files to the root of the repository.
4. 2 branches are setup for the pull request: `{version}` and `{version}-candidate`, where `{version}-candidate` contains the bindings to be merged into `{version}`.

From the pull request, we run build validation with the files from `test/`, and then validate the produced `clap` plugin with [`clap-validator`](https://github.com/free-audio/clap-validator). This produces a small report containing the performed test results, which can be used for review. Once merged -- we create a tagged release, stripped of any non-bindings related files (like .git, bin, test, etc.).
