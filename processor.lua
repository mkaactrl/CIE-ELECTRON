-- Define the RemoteEvent (make sure this is set up in ReplicatedStorage)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local responseRemote = ReplicatedStorage:WaitForChild("ResponseRemote")

-- 1. Mock Links/Commands
local responses = {
    ["Chrome/FunnyCats"] = "Results: 1. Funny Cat Compilation | 2. Cat Memes Galore!",
    ["Chrome/HowToCook"] = "Results: 1. 5-Minute Recipes | 2. Beginner Cooking Guide",
    ["Search/TuxFacts"] = "Tux the Penguin was named after a type of swimming bird!"
}

local function handleLink(input)
    local response = responses[input]
    if response then
        -- Send response to the client via RemoteEvent
        responseRemote:FireClient(game.Players.LocalPlayer, response)
    else
        responseRemote:FireClient(game.Players.LocalPlayer, "Error: Page not found.")
    end
end

-- 2. Safe Calculator (BODMAS support)
local function simpleCalculate(expression)
    -- Ensure valid math expressions only
    if not expression:match("^[%d%s%+%-%*/%(%)%.]+$") then
        return "Error: Invalid expression."
    end

    local success, result = pcall(function()
        -- Lua respects BODMAS natively here
        return load("return " .. expression)()
    end)

    if success then
        return "Result: " .. tostring(result)
    else
        return "Error: Could not calculate."
    end
end

-- 3. Handle Commands from the User
local function handleCommand(input)
    if input:sub(1, 6) == "!calc " then
        local expression = input:sub(7) -- Remove the "!calc " part
        local result = simpleCalculate(expression)
        responseRemote:FireClient(game.Players.LocalPlayer, result)
    elseif input:sub(1, 7) == "Chrome/" then
        -- Handle mock link searches
        handleLink(input)
    else
        responseRemote:FireClient(game.Players.LocalPlayer, "Unknown command.")
    end
end

-- Example Usage for testing (Replace with actual user input in your game)
handleCommand("!calc 5+3*2") -- Sends: "Result: 11"
handleCommand("Chrome/FunnyCats") -- Sends: "Results: 1. Funny Cat Compilation | 2. Cat Memes Galore!"
handleCommand("Chrome/HowToCook") -- Sends: "Results: 1. 5-Minute Recipes | 2. Beginner Cooking Guide"
handleCommand("Search/TuxFacts") -- Sends: "Tux the Penguin was named after a type of swimming bird!"

