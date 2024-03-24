# jq-play.kak

This is plugin to run JQ interactivly in kakoune. This was requested by
[jbrains](https://discuss.kakoune.com/u/jbrains/summary) on the
[kakoune forum](https://discuss.kakoune.com/u/jbrains/summary) recently.

Also this plugin is wery much WIP so please tell me if there is somthing
wrong with it or if there is some new feture you want.

## usage

after installation, load the plugin like so:
```
require-module jq
```
This will expose the command `jq-start` which you can run to mark the current
buffer as the one you want jq to read from. Then this buffer will be automaticly
filterd with the filter in the buffer `jq_filter` and placed in the buffer `jq_out`.

If you want to disable jq-play, run `jq-stop`. This will stop jq and delete the buffers
`jq_filter` and `jq_out`
