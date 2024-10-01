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

healthBoxW = w / 6
healthBoxH = h / 16

healthBoxPosX = w / 2 - (healthBoxW / 2)
healthBoxPosY = h - (ScrH() / 12)

-- Now we draw our own hud
hook.Add("HUDPaint", "TZHud_Draw", function()
	surface.SetDrawColor(0, 0, 0, 192)

	-- Health and Armor background panel
	surface.DrawRect(healthBoxPosX, healthBoxPosY, healthBoxW, healthBoxH)

	-- Health
	surface.SetFont("HudNumbersGlow")
	surface.SetTextPos(healthBoxPosX, healthBoxPosY)
	surface.SetTextColor(255, 0, 0)
	surface.DrawText(LocalPlayer():Health())

	surface.SetFont("HudNumbers")
	surface.SetTextPos(healthBoxPosX, healthBoxPosY)
	surface.DrawText(LocalPlayer():Health())

	--Armor
	surface.SetFont("HudNumbersGlow")
	surface.SetTextPos(healthBoxPosX, healthBoxPosY + 32)
	surface.SetTextColor(0, 96, 255)
	surface.DrawText(LocalPlayer():Armor())

	surface.SetFont("HudNumbers")
	surface.SetTextPos(healthBoxPosX, healthBoxPosY + 32)
	surface.DrawText(LocalPlayer():Armor())

	-- Ammo (magazine / clip)
	surface.SetFont("HudNumbersGlow")
	surface.SetTextPos(healthBoxPosX + (healthBoxW - healthBoxW / 2.5), healthBoxPosY)
	surface.SetTextColor(255, 255, 0)
	surface.DrawText(LocalPlayer():GetActiveWeapon():Clip1())

	surface.SetFont("HudNumbers")
	surface.SetTextPos(healthBoxPosX + (healthBoxW - healthBoxW / 2.5), healthBoxPosY)
	surface.DrawText(LocalPlayer():GetActiveWeapon():Clip1())

	-- Ammo (Reserve)
	surface.SetFont("HudNumbersGlow")
	surface.SetTextPos(healthBoxPosX + (healthBoxW - healthBoxW / 4), healthBoxPosY)
	surface.SetTextColor(255, 160, 0)
	ammoType = LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()
	reserveAmmo = LocalPlayer():GetAmmoCount(ammoType)
	surface.DrawText(reserveAmmo)

	surface.SetFont("HudNumbers")
	surface.SetTextPos(healthBoxPosX + (healthBoxW - healthBoxW / 4), healthBoxPosY)
	surface.DrawText(reserveAmmo)

	-- Ammo (Secondary / Alt. Fire)
	surface.SetFont("HudNumbersGlow")
	surface.SetTextPos(healthBoxPosX + (healthBoxW - healthBoxW / 4), healthBoxPosY + 32)
	surface.SetTextColor(128, 0, 255)
	secondaryAmmoType = LocalPlayer():GetActiveWeapon():GetSecondaryAmmoType()
	secondaryAmmo = LocalPlayer():GetAmmoCount(secondaryAmmoType)
	surface.DrawText(secondaryAmmo)

	surface.SetFont("HudNumbers")
	surface.SetTextPos(healthBoxPosX + (healthBoxW - healthBoxW / 4), healthBoxPosY + 32)
	surface.DrawText(secondaryAmmo)
end)
