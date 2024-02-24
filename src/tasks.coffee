import * as Fn from "@dashkite/joy/function"
import M from "@dashkite/masonry"
import * as SNS from "@dashkite/dolores/sns"
import { Module, File } from "@dashkite/masonry-module"
import configuration from "./configuration"
import defaults from "./defaults"
import { resolve } from "@dashkite/drn"
import "@dashkite/drn-sky"

# TODO does this belong in Masonry Module? or ...?
notify = do ({ topic } = {}) ->
  Fn.tee ({ source, event, module }) -> 
    # TODO add source path
    topic ?= await SNS.create resolve configuration.topic
    SNS.publish topic, { event..., source, module: module?.name }


publish = ( Genie ) ->

  # defer reading configuration to ensure any DRN replacement
  # (ex: bucket name) has been done ...
  options = { defaults..., ( Genie.get "publish" )... }

  do M.concurrently [
    M.glob options.glob, root: options.root
    M.read
    Module.data
    File.hash
    File.changed Fn.flow [
      File.publish
        template: options.target
        bucket: options.bucket
        # cache forever because path includes content hash
        cache: options.cache
      File.stamp
      notify
    ]       
  ]

export default publish