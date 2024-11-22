-- Debugging message to confirm the addon is loaded
print("Test Addon Loaded")

-- Create the frame for the interface
local frame = CreateFrame("Frame", "TestAddonFrame", UIParent, "BackdropTemplate")
frame:SetPoint("CENTER")
frame:SetSize(700, 500)
frame:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    edgeSize = 16,
})
frame:SetBackdropColor(0, 0, 0, 0.8)
frame:EnableMouse(true)
frame:SetMovable(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

-- Title text for the frame
local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -10)
title:SetText("Test Addon Interface")

-- Assign interrupts functionality
local interruptList = {} -- A table to hold interrupt assignments

-- Display frame for interrupts
local interruptDisplay = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
interruptDisplay:SetPoint("TOPLEFT", 10, -50)
interruptDisplay:SetSize(680, 400)
interruptDisplay:SetJustifyH("LEFT")
interruptDisplay:SetText("") -- Initialize empty text

-- Function to update interrupt text
local function updateInterruptDisplay()
    local text = "Interrupt Assignments:\n"
    for i, player in ipairs(interruptList) do
        text = text .. i .. ". " .. player .. "\n"
    end
    interruptDisplay:SetText(text) -- Update the text
end

-- Input box to add player names
local inputBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
inputBox:SetPoint("BOTTOMLEFT", 10, 30)
inputBox:SetSize(200, 30)
inputBox:SetAutoFocus(false)
inputBox:SetScript("OnEnterPressed", function(self)
    local playerName = self:GetText()
    if playerName and playerName ~= "" then
        table.insert(interruptList, playerName) -- Add player to the list
        updateInterruptDisplay()
        self:SetText("") -- Clear input box
    end
    self:ClearFocus()
end)

-- Add button to submit player name
local addButton = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
addButton:SetPoint("BOTTOMLEFT", inputBox, "BOTTOMRIGHT", 10, 0)
addButton:SetSize(80, 30)
addButton:SetText("Add")
addButton:SetScript("OnClick", function()
    local playerName = inputBox:GetText()
    if playerName and playerName ~= "" then
        table.insert(interruptList, playerName)
        updateInterruptDisplay()
        inputBox:SetText("")
    end
end)

-- Close button
local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", -5, -5)
closeButton:SetScript("OnClick", function()
    frame:Hide()
end)

-- Show frame on load
frame:Show()

-- Slash command to toggle the frame
SLASH_TESTADDON1 = "/testaddon"
SlashCmdList["TESTADDON"] = function()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
    end
end
