local ReplicatedStorage = game:GetService("ReplicatedStorage")
local responseRemote = ReplicatedStorage:WaitForChild("ResponseRemote")

responseRemote.OnClientEvent:Connect(function(response)
    -- Display the response to the player
    print(response)  -- You can replace this with any UI update method
    -- For example, use a TextLabel or a GUI element to display the response
end)
