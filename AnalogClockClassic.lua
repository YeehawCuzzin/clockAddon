--[[  AnalogClockClassic.lua  –  analog clock for Classic SoD for the illiterate raiders  ]]

local SIZE   = 140          -- overall diameter
local FACE   = "Interface/AddOns/AnalogClockClassic/Media/clockface"
local HAND_T = "Interface/AddOns/AnalogClockClassic/Media/hand"
local TAU    = math.pi * 2  -- full circle

-- anchor under the minimap (drag-to-move)
local clock = CreateFrame("Frame", "AnalogClockClassicFrame", UIParent)
clock:SetSize(SIZE, SIZE)
clock:SetPoint("TOP", Minimap, "BOTTOM", 0, -8)
clock:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 8})
clock:SetMovable(true); clock:EnableMouse(true)
clock:RegisterForDrag("LeftButton")
clock:SetScript("OnDragStart", clock.StartMoving)
clock:SetScript("OnDragStop",  clock.StopMovingOrSizing)

-- dial
clock.face = clock:CreateTexture(nil, "BACKGROUND")
clock.face:SetAllPoints()
clock.face:SetTexture(FACE)

-- helper for hands
local function NewHand(layer, w, h)
    local t = clock:CreateTexture(nil, layer)
    t:SetTexture(HAND_T)
    t:SetSize(w, h)
    t:SetPoint("CENTER")
    return t
end

clock.hour = NewHand("ARTWORK", 10, SIZE*0.28)
clock.min  = NewHand("ARTWORK",  8, SIZE*0.40)
clock.sec  = NewHand("OVERLAY",  4, SIZE*0.45)
clock.sec:SetVertexColor(1,0,0)

-- update every 0.1 s
clock:SetScript("OnUpdate", function(self, elapsed)
    self.accum = (self.accum or 0) + elapsed
    if self.accum < 0.1 then return end
    self.accum = 0

    -- local PC time (swap to realm time with date('*t', GetServerTime()))
    local t = date("*t", GetServerTime())
    local h, m, s = t.hour % 12, t.min, t.sec

    self.hour:SetRotation(-TAU * ((h + m/60) / 12))
    self.min:SetRotation ( -TAU * ( m           / 60))
    self.sec:SetRotation ( -TAU * ( s           / 60))
end)

-- /aclock to toggle
SLASH_ACLOCK1 = "/aclock"
SlashCmdList.ACLOCK = function() clock:SetShown(not clock:IsShown()) end
