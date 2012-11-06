exports.let = (args, ret) ->
  context = {}
  args.forEach (arg) -> context[arg[0]] = arg[1].call Object.freeze(Object.create context)
  ret.call context if ret?
