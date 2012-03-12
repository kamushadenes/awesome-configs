local setmetatable = setmetatable
local table        = table
local print        = print
local debug        = debug
local rawset       = rawset
local rawget       = rawget
local pairs        = pairs

module("ultiLayout.object_model")

local function warn_invalid()
    print("This is not a setter")
    debug.traceback()
end

local function setup_object(data, get_map, set_map, private_data,args)
    local data,args,private_data = data or {},args or {},private_data or {}
    local signals = {}
    
    function data:add_signal(name,func)
        signals[name] = signals[name] or {}
        table.insert(signals[name],func)
    end
    
    function data:remove_signal(name,func)
        for k,v in pairs(signals[name] or {}) do
            if v == func then
                signals[name][k] = nil
                return true
            end
        end
        return false
    end
    
    function data:emit_signal(name,...)
        for k,v in pairs(signals[name] or {}) do
            v(data,...)
        end
    end
    
    data.warn_invalid = warn_invalid
    
    local function return_data(table, key)
        if get_map[key] ~= nil then
            return get_map[key]()
        elseif args.autogen_getmap == true and private_data[key] ~= nil then
            return private_data[key]
        else
            return rawget(table,key)
        end
    end
    
    local function auto_signal(key)
        if args.autogen_signals == true then
            data:emit_signal(key.."::changed")
        end
    end
    
    local function catchGeoChange(table, key,value)
        if set_map[key] == false then
            warn_invalid()
        elseif (data[key] ~= value or (args.always_handle ~= nil and args.always_handle[key] == true)) and set_map[key] ~= nil then
            set_map[key](value)
            auto_signal(key)
        elseif (args.force_private or {})[key] == true then
            private_data[key] = value
            auto_signal(key)
        elseif set_map[key] == nil then
            rawset(data,key,value)
        end
    end
    
    setmetatable(data, { __index = return_data, __newindex = catchGeoChange, __len = function() return #data + #private_data end, })
    return data
end
setmetatable(_M, { __call = function(_, ...) return setup_object(...) end })