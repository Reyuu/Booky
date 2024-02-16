Booky = LibStub("AceAddon-3.0"):NewAddon("Booky", "AceConsole-3.0", "AceEvent-3.0")
local _, L = ...
local pageCounter = 0
local debug = false

function _DebugPrint(s)
    if debug then
        Booky:Print(s)
    end
end

function Booky:OnInitialize()
    -- when loaded
    _DebugPrint("Well, hello there!")
    local FrameBackdrop = {
        bgFile   = ('Interface\\AddOns\\%s\\Textures\\'):format(_)..'Backdrop_Talkbox.blp',
		edgeFile = ('Interface\\AddOns\\%s\\Textures\\'):format(_)..'Edge_Talkbox_BG.blp',
		edgeSize = 16,
		insets   = { left = 16, right = 16, top = 16, bottom = 16 }
    }
    BookyFrame:SetBackdrop(FrameBackdrop)
    BookyNextPageButton:SetBackdrop(FrameBackdrop)
    BookyPreviousPageButton:SetBackdrop(FrameBackdrop)
    self:RegisterEvent("ITEM_TEXT_BEGIN", "ReadingBegin")
    self:RegisterEvent("ITEM_TEXT_READY", "ReadingTextReady")
    self:RegisterEvent("ITEM_TEXT_CLOSED", "ReadingEnd")
end

function Booky:ReadingBegin()
    _DebugPrint("Reading begun")
    UIParent:SetAlpha(0)
    BookyFrame:Show()
end

function Booky:ReadingTextReady()
    pageCounter = ItemTextGetPage()
    _DebugPrint("Reading ready")
    local title = ItemTextGetItem()
    local text = ItemTextGetText()
    -- replace to entities, otherwise, text will display weird
    text = text:gsub("&", "&amp;")
    text = text:gsub("<", "&lt;")
    text = text:gsub(">", "&gt;")
    text = text:gsub("\"", "&quot;")
    text = text:gsub("&lt;", "\124cnORANGE_FONT_COLOR&:lt;")
    text = text:gsub("&gt;", "&gt;\124r")
    local new_text = ""
    for w in text:gmatch("([^\n\n]+)") do
        new_text = new_text .. "<p>"..w.."</p><br />"
    end
    _DebugPrint(title)
    _DebugPrint(new_text)
    _DebugPrint("<html><body><h1>"..title.."</h1><br />"..new_text.."</body></html>")
    BookySimpleHTML:SetText("<html><body><h1>"..title.."</h1><br />"..new_text.."</body></html>")
    ItemTextFrame:SetAlpha(0)
    if pageCounter == 1 then
        BookyPreviousPageButton:Hide()
    end
    if pageCounter > 1 then
        BookyPreviousPageButton:Show()
    end
    if ItemTextHasNextPage() then
        BookyNextPageButton:Show()
    end
    if not ItemTextHasNextPage() then
        BookyNextPageButton:Hide()
    end
end

function Booky:ReadingEnd()
    _DebugPrint("Reading end")
    BookyFrame:Hide()
    pageCounter = 0
    UIParent:SetAlpha(1)
end

function BookyNextPageButton_OnClick()
    ItemTextNextPage()
    pageCounter = ItemTextGetPage()
    _DebugPrint("pc = "..pageCounter)
end

function BookyPreviousPageButton_OnClick()
    ItemTextPrevPage()
    pageCounter = ItemTextGetPage()
    _DebugPrint("pc = "..pageCounter)
end

function Booky:OnEnable()
    -- when enabled
end

function Booky:OnDisable()
    -- when disabled
end

function BookyExitButton_OnClick()
    BookyFrame:Hide()
    CloseItemText()
end

function BookyShowDefaultUIButton_OnClick()
    if ItemTextFrame:GetAlpha() == 0 then
        ItemTextFrame:SetAlpha(1)
        UIParent:SetAlpha(1)
    else
        ItemTextFrame:SetAlpha(0)
        UIParent:SetAlpha(0)
    end
end