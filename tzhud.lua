local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudZoom"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
}

hook.Add("HUDShouldDraw", "DisableHL2HUD", function(name)
	if hide[name] then
		return false
	end

	-- Don't return anything here, it may break other addons that rely on this hook.
end)

-- Variables we need for properly positioning things around the screen
w = ScrW()
h = ScrH()

HealthWindowW = w / 6
HealthWindowH = h / 6

HPWindowHorizMargin = w - w + HealthWindowW / 8
HPWindowVertMargin = h - (ScrH() / 5)

AmmoWindowW = HealthWindowW
AmmoWindowH = HealthWindowH

AmmoWindowHorizMargin = ScrW() / 2 + ScrW() / 32
AmmoWindowVMargin = h - (ScrH() / 5)

print(w)
print(h)
-- Now we draw our own hud
hook.Add("HUDPaint", "TZHud_Draw", function()
	surface.SetDrawColor(0, 0, 0, 128)

	surface.DrawRect(50, 50, 128, 128)
	surface.DrawRect(HPWindowHorizMargin, HPWindowVertMargin, HealthWindowW, HealthWindowH)

	surface.DrawRect(AmmoWindowHorizMargin, AmmoWindowVMargin, AmmoWindowW, AmmoWindowH)
end)
