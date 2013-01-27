root = this

root.namespace = (ns) ->
    parts = ns.split '.'
    parent = root
    for part in parts
        parent[part] ?= {}
        parent = parent[part]
    parent

depender = namespace "depender"

depender.missing = (dependency) ->
    path = dependency.split '.'
    parent = root
    for name in path
        parent = parent[name]
        return true if not parent?
    return false

depender.__deferred__ = []

root.define = () ->
    switch arguments.length
        when 2
            [dependencies, callback] = arguments
            namespace = window
        when 3 
            [path, dependencies, callback] = arguments
            namespace = root.namespace path
        else
            throw "Invalid `define` arguments"

    if not dependencies.some depender.missing
        actions = [callback]
        while actions.length > 0
            action.call namespace for action in actions
            actions = []
            procesding = depender.__deferred__
            depender.__deferred__ = []
            for defer in procesding
                if not defer.dependencies.some depender.missing
                    actions.push defer.callback
                else
                    depender.__deferred__.push defer
    else
        depender.__deferred__.push
            dependencies: dependencies
            callback: callback

    depender.__deferred__.length is 0
