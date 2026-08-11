# odinclap

This repo is setup to pull the most recent version of [`clap`](https://github.com/free-audio/clap) every week. If it's a published version newer than `TRACKED_VERSION`, we pull the version content, generate odin bindings with [`odin-c-bindgen`](https://github.com/karl-zylinski/odin-c-bindgen) and open a pull request.

From the pull request, we run build validation with the files from `test/`, and then validate the produced `clap` plugin with [`clap-validator`](https://github.com/free-audio/clap-validator). This produces a small report containing the performed test results, which can be used for review.

Finally, once merged -- we create a tagged release, stripped of any non-bindings related files (like .git, bin, test, etc.) and publish it for use.
