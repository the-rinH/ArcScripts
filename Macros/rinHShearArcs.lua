--[[
    Macro to shear arcs to a specified direction.
    A good example use case for this macro is to make spinny arc patterns move in a specified direction.

    REQUIRES rinHHelper.lua
]]

require "rinHHelper"

--Helper function to get interpolation at timing
function getPointAtTiming(startPoint, endPoint, startTiming, endTiming, atTiming, easingX, easingY)
    local timeBetweenStartAndEnd = endTiming - startTiming
    local timeFraction = ((atTiming - startTiming) / timeBetweenStartAndEnd)
    local x = lerpEasing(startPoint["x"], endPoint["x"], timeFraction, easingX)
    local y = lerpEasing(startPoint["y"], endPoint["y"], timeFraction, easingY)
    return xy(x,y)
end

function getEndPoint(arcs)
    local greatestTiming = 0
    for i = 1, #arcs, 1 do
        if arcs[i].endTiming > greatestTiming then greatestTiming = arcs[i].endTiming end
    end
    return greatestTiming
end

-- Request inputs
function shearArcsInit()
    -- Easing Dialog
    local easeXField = DialogField.create("x_easing")
                            .setLabel("X Easing")
                            .setHint("Select the X axis easing")
                            .dropdownMenu("s", "si", "so", "b", "ci", "co", "cio", "qi", "qo", "qio", "circin", "circout", "circinout", "backin", "backout", "backinout")
                            .defaultTo("s")

    local easeYField = DialogField.create("y_easing")
                            .setLabel("Y Easing")
                            .setHint("Select the Y axis easing")
                            .dropdownMenu("s", "si", "so", "b", "ci", "co", "cio", "qi", "qo", "qio", "circin", "circout", "circinout", "backin", "backout", "backinout")
                            .defaultTo("s")

    local descriptionField = DialogField.create("description")
                            .description()
                            .setLabel("Set up easings for X and Y axes, defaults to linear easing (s). \n It is advised to select the arcs beforehand for ease of use.")

    local dialogInput = DialogInput.withTitle("Set up easing")
                            .requestInput({
                                descriptionField,
                                easeXField,
                                easeYField
                            })
    coroutine.yield()

    -- Get Arcs
    local arcRequest = EventSelectionInput.requestEvents(
        EventSelectionConstraint.create().any(),
        "Select arcs")
    coroutine.yield()

    -- No arcs were selected...
    if #arcRequest.result["arc"] == 0 then
        notifyError ("/!\\ ERROR: No arcs were selected, please select arcs before using the macro.")
        return
    end

    -- Get start and end positions of the shear
    local startPosRequest = TrackInput.requestPosition(
        arcRequest.result["arc"][1].timing,
        "Select start position of the shear")
    coroutine.yield()

    local endPosRequest = TrackInput.requestPosition(
        arcRequest.result["arc"][#arcRequest.result["arc"]].endTiming,
        "Select end position of the shear")
    coroutine.yield()

    -- Start and end positions are the same, no need to shear
    if startPosRequest.result == endPosRequest.result then
        notifyWarn("Start and end positions are the same: No action is done.")
        return
    end

    --Do stuff
    shearArcs(arcRequest.result["arc"], startPosRequest.result, endPosRequest.result, dialogInput.result["x_easing"], dialogInput.result["y_easing"])

end

-- Perform shearing
function shearArcs(selectedArcs, startPos, endPos, easingX, easingY)
    local command = Command.create("Shear Arcs")
    -- notify Select end position of the shear
    --[[
    notify(
        "Start: " .. startPos["x"] .. "," .. startPos["y"] ..
        "|| End: " .. endPos["x"] .. "," .. endPos["y"])
    ]]
    local selectedStartTiming = selectedArcs[1].timing
    local selectedEndTiming = getEndPoint(selectedArcs)

    for i = 1, #selectedArcs, 1 do
        local arcStartTiming = selectedArcs[i].timing
        local arcEndTiming = selectedArcs[i].endTiming
        local arcStartPosition = selectedArcs[i].startXY
        local arcEndPosition = selectedArcs[i].endXY

        local shearCenterAtStartTiming = getPointAtTiming(
            startPos, 
            endPos,
            selectedStartTiming,
            selectedEndTiming,
            arcStartTiming,
            easingX,
            easingY)
        local shearCenterAtEndTiming = getPointAtTiming(
            startPos, 
            endPos,
            selectedStartTiming,
            selectedEndTiming,
            arcEndTiming,
            easingX,
            easingY)
        local deltaStartXYFromStart = arcStartPosition - xy(startPos["x"], startPos["y"])
        local deltaEndXYFromStart = arcEndPosition - xy(startPos["x"], startPos["y"])

        local newXYStart = shearCenterAtStartTiming + deltaStartXYFromStart
        local newXYEnd = shearCenterAtEndTiming + deltaEndXYFromStart

        selectedArcs[i].startXY = newXYStart
        selectedArcs[i].endXY = newXYEnd

        command.add(selectedArcs[i].save())
    end
    command.commit()
    --notify("Arcs has been sheared")
    --notify(getPointAtTiming(xy(1,1),xy(0,0),0,1000,500))

end

addMacro(nil, "shearArcs", "Shear Arcs",  shearArcsInit)