import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'
import 'CoreLibs/ui'

import 'util'

-- Config
local prerenderLinesCount <const> = 10

-- Setup
local gfx <const> = playdate.graphics
local mathMax <const> = math.max
local mathMin <const> = math.min
local textAlignCenter <const> = kTextAlignment.center
local mathRound <const> = mathRound

local screenWidth <const> = playdate.display.getWidth()
local screenHeight <const> = playdate.display.getHeight()

local infinity <const> = 1 / 0
local emptyLineHeight <const> = 16
local leading <const> = 4
local textPadding <const> = 8
local sidebarWidth <const> = 64
local sidebarItemHeight <const> = 48
local textWidth <const> = screenWidth - (textPadding * 2) - sidebarWidth
local dPadScrollSpeed <const> = 4

local localYes <const> = gfx.getLocalizedText('yes')
local localNo <const> = gfx.getLocalizedText('no')

local nicoBold16 <const> = gfx.font.new('fonts/nico/nico-bold-16')

local text <const> = import 'text/en'
local textLines <const> = splitString(text, "\n")

local lineIndexToRender = prerenderLinesCount + 1
local nextLineY = textPadding

local hasScrolled = false
local showShouldCrankPrompt = false
local crankPromptTimer = playdate.timer.new(10000, function()
	showShouldCrankPrompt = true
end)
local isDownDown = false
local isUpDown = false

playdate.display.setRefreshRate(50)

gfx.setBackgroundColor(gfx.kColorWhite)
gfx.setFontFamily(gfx.font.newFamily({
	[gfx.font.kVariantNormal] = 'fonts/nico/nico-pups-16',
	[gfx.font.kVariantBold] = 'fonts/nico/nico-bold-16',
}))

local sidebarImage = gfx.image.new('img/sidebar')
local sidebarSprite = gfx.sprite.new(sidebarImage)
sidebarSprite:setCenter(1, 0)
sidebarSprite:setIgnoresDrawOffset(true)
sidebarSprite:add()
sidebarSprite:moveTo(screenWidth, 0)

local function scrollBy(scrollPx)
	local curOffX, curOffY = gfx.getDrawOffset()

	if not hasScrolled then
		hasScrolled = true
		showShouldCrankPrompt = false
		crankPromptTimer:pause()
		crankPromptTimer:remove()
	end

	gfx.setDrawOffset(
		curOffX,
		mathMax(
			mathMin(curOffY - scrollPx, 0),
			-(nextLineY - screenHeight + textPadding)
		)
	)
end

-- Bind controls
playdate.inputHandlers.push({
	cranked = function(change, acceleratedChange)
		scrollBy(change)
	end,

	downButtonDown = function()
		isDownDown = true
	end,

	downButtonUp = function()
		isDownDown = false
	end,

	upButtonDown = function()
		isUpDown = true
	end,

	upButtonUp = function()
		isUpDown = false
	end,
})

local function renderLine(line)
	if line == '' then
		nextLineY += emptyLineHeight
		return
	end

	local sprite = gfx.sprite.spriteWithText(
		line,
		textWidth,
		infinity,
		gfx.kColorClear,
		leading
	)
	sprite:add()
	sprite:setCenter(0, 0)
	sprite:moveTo(textPadding, nextLineY)

	local _spriteWidth, spriteHeight = sprite:getSize()
	nextLineY += spriteHeight
end

-- Prerender initial lines to prevent flash of no content
for i = 1, prerenderLinesCount do
	renderLine(textLines[i])
end

local function drawSidebarItem(title, content, slotIndex)
	gfx.pushContext()
	gfx.setDrawOffset(0, 0)

	gfx.drawTextAligned(
		title,
		screenWidth - (sidebarWidth / 2) + 2,
		(slotIndex - 1) * sidebarItemHeight + 6,
		textAlignCenter
	)

	gfx.pushContext()
	gfx.setFont(nicoBold16)
	gfx.drawTextAligned(
		content,
		screenWidth - (sidebarWidth / 2) + 2,
		(slotIndex - 1) * sidebarItemHeight + 26,
		textAlignCenter
	)
	gfx.popContext()
	gfx.popContext()
end

local function updatePower()
	local powerStatus = playdate.getPowerStatus()
	local batteryVoltage = playdate.getBatteryVoltage()
	local batteryPercent = playdate.getBatteryPercentage()

	drawSidebarItem(
		gfx.getLocalizedText('statusItem.charging'),
		powerStatus.charging and localYes or localNo,
		1
	)
	drawSidebarItem(
		gfx.getLocalizedText('statusItem.usb'),
		powerStatus.USB and localYes or localNo,
		2
	)
	drawSidebarItem(
		gfx.getLocalizedText('statusItem.screws'),
		powerStatus.screws and localYes or localNo,
		3
	)
	drawSidebarItem(
		gfx.getLocalizedText('statusItem.volts'),
		mathRound(batteryVoltage, 3),
		4
	)
	drawSidebarItem(
		gfx.getLocalizedText('statusItem.stateOfCharge'),
		mathRound(batteryPercent, 3),
		5
	)
end

function playdate.update()
	playdate.timer.updateTimers()

	if lineIndexToRender <= #textLines then
		local line = textLines[lineIndexToRender]

		renderLine(line)
		lineIndexToRender += 1
	end

	if isUpDown then
		scrollBy(-dPadScrollSpeed)
	elseif isDownDown then
		scrollBy(dPadScrollSpeed)
	end

	gfx.sprite.update()

	updatePower()

	if showShouldCrankPrompt then
		playdate.ui.crankIndicator:draw()
	end

	-- playdate.drawFPS(0, screenHeight - 12)
end
