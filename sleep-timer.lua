local sleepAfter = 0
local startSleep = nil

function sleep()
    if sleepAfter == 0 then
        mp.add_timeout(60, sleepBegin)
    end
    sleepAfter = sleepAfter + 15
    mp.osd_message("Sleep in "..sleepAfter.." minutes")
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
