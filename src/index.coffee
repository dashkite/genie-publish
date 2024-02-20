import * as Fn from "@dashkite/joy/function"
import M from "@dashkite/masonry"
import * as SNS from "@dashkite/dolores/sns"
import { Module, File } from "@dashkite/masonry-module"

defaults =
  glob: "build/browser/src/**/*"
  target: "${ module.name }/${ source.hash }/${ source.path }"

# TODO does this belong in Masonry Module? or ...?
notify = do ({ topic } = {}) ->
  Fn.tee ({ source, event, module }) -> 
    # TODO add source path
    topic ?= await SNS.create configuration.topic
    SNS.publish topic, { event..., source, module: module?.name }

export default ( Genie ) ->
    
    Genie.on "publish", ->

      # defer reading configuration to ensure any DRN replacement
      # (ex: bucket name) has been done ...
      options = { defaults..., ( Genie.get "publish" )... }

      do M.start [
        M.glob options.glob
        M.read
        Module.data
        File.hash
        File.changed Fn.flow [
          File.publish
            template: options.target
            bucket: options.bucket
            # cache forever because path includes content hash
            cache: "public, max-age=31536000"
          File.stamp
          notify
        ]
      ]

    Genie.before "watch", "publish:watch"
    Genie.define "publish:watch", ->
      Genie.after "build", "publish--"
