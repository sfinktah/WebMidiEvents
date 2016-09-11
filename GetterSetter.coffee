define [], () ->
  Function::getter = (prop, get) ->
    Object.defineProperty @prototype, prop, {get, configurable: yes}
    return
  Function::setter = (prop, set) ->
    Object.defineProperty @prototype, prop, {set, configurable: yes}
    return
  return
