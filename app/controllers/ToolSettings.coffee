Spine = require 'spine'

# Not sure if we need a second settings controller. Other one is for options dircetly exposed to the user.
# This one is for any and all settings passed to a tool.

# class ToolSettings extends Spine.Controller

#   constructor: (params) ->
#     super
#     @className: "#{params.name} tool" 
#     @index: params.count
#     @channel: "#{params.name}-#{params.count}"
#     @sources: params.sources
#     @channels: params.channels
#     @pos: params.pos
#     @z_index: params.z_index

#     return {
#         className: @className
#         index: @index
#         channel: @channel
#         sources: @sources
#         channels: @channels
#       }


