# odinclap

This repo is setup to pull the most recent version of [`clap`](https://github.com/free-audio/clap) every week. If it's a published version newer than `TRACKED_VERSION`, we pull the version content, generate odin bindings with [`odin-c-bindgen`](https://github.com/karl-zylinski/odin-c-bindgen) and open a pull request.

The final bindings are generated as a result of the following process:

1. Clone clap, as previously mentioned.
2. A set of "footers" are contained in `bindings/footers` which are manually maintained files that include constants from the original header files, these aren't normally included in the bindings generated with `odin-c-bindgen`.
3. The footer files are copied next to the source header files, `odin-c-bindgen` finds these and inserts their content near the bottom of the relevant source file.

From the pull request, we run build validation with the files from `test/`, and then validate the produced `clap` plugin with [`clap-validator`](https://github.com/free-audio/clap-validator). This produces a small report containing the performed test results, which can be used for review. Once merged -- we create a tagged release, stripped of any non-bindings related files (like .git, bin, test, etc.) and publish it for use.
