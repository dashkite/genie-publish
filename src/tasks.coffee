import * as Fn from "@dashkite/joy/function"
import M from "@dashkite/masonry"
import * as SNS from "@dashkite/dolores/sns"
import { invalidatePaths } from "@dashkite/dolores/cloudfront"
import { Module, File } from "@dashkite/masonry-module"
import configuration from "./configuration"
import defaults from "./defaults"
import { resolve } from "@dashkite/drn"
import "@dashkite/drn-sky"

notify = do ({ topic } = {}) ->
  Fn.tee ({ source, event, module }) -> 
    topic ?= await SNS.create await resolve configuration.topic
    SNS.publish topic, { event..., source, module: module?.name }

publish = ( Genie ) ->

  # defer reading configuration to ensure any DRN replacement
  # (ex: bucket name) has been done ...
  options = { defaults..., ( Genie.get "publish" )... }
  _invalidate = false
  invalidate = Fn.tee -> _invalidate = true

  await do M.concurrently [
    M.glob options.glob, root: options.root
    M.readBytes
    Module.data
    File.hash
    File.changed Fn.flow [
      File.publish
        template: options.target
        bucket: options.bucket
        # cache forever because path includes content hash
        cache: options.cache
      File.stamp
      invalidate
      notify
    ]       
  ]

  if _invalidate && options.domains?
    await Promise.all do ->
      for domain in options.domains
        invalidatePaths { domain, paths: [ "/*" ]}

clean = ( Genie ) -> File.reset()

export { publish, clean }
export default publish