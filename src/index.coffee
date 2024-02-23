export default ( Genie ) ->
    
    Genie.on "publish", ->
      publish = await import( "./tasks" )
      publish Genie

    Genie.before "watch", "publish:watch"

    Genie.define "publish:watch", ->
      Genie.after "build", "publish--"