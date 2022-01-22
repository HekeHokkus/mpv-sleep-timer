local options = require "mp.options"

local o = {
    increment = 15,
    minimum = 15,
    maximum = 150
}

options.read_options(o)

local sleepAfter = o.minimum - o.increment
local startSleep = nil
local timeout = nil

function sleep()
    if (sleepAfter == o.minimum - o.increment) then
        timeout = mp.add_timeout(60, sleepBegin)
        sleepAfter = (sleepAfter + o.increment)
        mp.osd_message("Sleep in "..sleepAfter.." minutes")
    elseif (math.floor(sleepAfter / o.increment) < sleepAfter / o.increment) then
        startSleep:kill()
        startSleep = nil
        sleepAfter = o.minimum - o.increment
        mp.osd_message("Sleep cancelled")
    elseif (sleepAfter >= o.maximum) then
        timeout:kill()
        timeout = nil
        sleepAfter = o.minimum - o.increment
        mp.osd_message("Sleep cancelled")
    elseif (math.floor(sleepAfter / o.increment) == sleepAfter / o.increment) and (sleepAfter < o.maximum) then
        sleepAfter = (sleepAfter + o.increment)
        mp.osd_message("Sleep in "..sleepAfter.." minutes")
    end
end

function sleepBegin()
    timeout:kill()
    timeout = nil
    sleepAfter = sleepAfter - 1
    startSleep = mp.add_timeout(sleepAfter * 60, sleepPause)
end

function sleepPause()
    mp.set_property_native("pause", true)
    startSleep:kill()
    startSleep = nil
    sleepAfter = o.minimum - o.increment
end

mp.add_key_binding("Ctrl+SPACE", "sleep-timer", sleep)
