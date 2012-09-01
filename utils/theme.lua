local setmetatable = setmetatable
local button       = require( "awful.button" )
local beautiful    = require( "beautiful"    )
local naughty      = require( "naughty"      )
local tag          = require( "awful.tag"    )

local capi = { image  = image  ,
               widget = widget }

module("utils.theme")

function get_end_arrow(bg_color,fg_color,padding,direction)
    local img = capi.image.argb32(9+(padding or 0), 16, nil)
    img:draw_rectangle(padding or 0, 0, 9, 16, true, fg_color or beautiful.fg_normal)
    img:draw_rectangle(0, 0, padding or 0, 16, true, bg_color or beautiful.bg_normal)
    for i=0,(8) do
        img:draw_rectangle(padding or 0,i, i, 1, true, bg_color or beautiful.bg_normal)
        img:draw_rectangle(padding or 0,16- i,i, 1, true, bg_color or beautiful.bg_normal)
    end
    if direction == "left" then
        img:rotate(2)
    end
    return img
end

function get_beg_arrow(bg_color,fg_color,padding,direction)
    local img = capi.image.argb32((direction == "left") and 8 or 9+(padding or 0), 16, nil)
    img:draw_rectangle(0, 0, 9+(padding or 0), 16, true, bg_color or beautiful.bg_normal)
    for i=0,(8) do
        img:draw_rectangle((direction == "left") and 8-i+(padding or 0) or 0,i    , i, 1, true, fg_color or beautiful.fg_normal)
        img:draw_rectangle((direction == "left") and 8-i+(padding or 0) or 0,16- i, i, 1, true, fg_color or beautiful.fg_normal)
    end
    if direction == "left" then
        img:rotate(2)
    end
    return img
end

function new_arrow_widget(bg_color,fg_color,padding,direction)
    local wdg = capi.widget({type="imagebox"})
    wdg.image = get_end_arrow(bg_color,fg_color,padding,direction)
    return wdg
end

function get_beg_arrow_widget(bg_color,fg_color,padding,direction)
    local imgw = capi.widget({type="imagebox"})
    imgw.image = get_beg_arrow(bg_color,fg_color,padding,direction)
    return imgw
end