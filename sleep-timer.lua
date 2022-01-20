local sleepAfter = 0
local startSleep = nil
local increment = 15

function sleep()
    if (sleepAfter == 0) then
        mp.add_timeout(60, sleepBegin)
        sleepAfter = (sleepAfter + increment)
        mp.osd_message("Sleep in "..sleepAfter.." minutes")
    elseif (math.floor(sleepAfter / increment) == sleepAfter / increment) then
        sleepAfter = (sleepAfter + increment)
        mp.osd_message("Sleep in "..sleepAfter.." minutes")
    elseif (math.floor(sleepAfter / increment) < sleepAfter / increment) then
        startSleep:kill()
        startSleep = nil
        sleepAfter = 0
        mp.osd_message("Sleep cancelled")
    end
end

function sleepBegin()
    sleepAfter = sleepAfter - 1
    startSleep = mp.add_timeout(sleepAfter * 60, sleepPause)
end

function sleepPause()
    mp.set_property_native("pause", true)
    startSleep:kill()
    startSleep = nil
    sleepAfter = 0
end

mp.add_key_binding("Ctrl+SPACE", "sleep-timer", sleep)
