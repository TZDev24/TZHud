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

-- Create variables for the HUD colors so we can more easily
-- control and modify them
local healthColor = Color(255, 0, 0)
local armorColor = Color(0, 128, 255)

local magazineColor = Color(255, 255, 0)
local reserveAmmoColor = Color(255, 160, 0)
local secondaryAmmoColor = Color(160, 0, 255)

function checkUsesAmmo(weapon)
	local ply = LocalPlayer()
	local clip = weapon:Clip1()
	local primAmmoType = weapon:GetPrimaryAmmoType()
	local secAmmoType = weapon:GetSecondaryAmmoType()
	local reserveAmmo = ply:GetAmmoCount(primAmmoType)
	local secondaryAmmo = ply:GetAmmoCount(secAmmoType)

	if
		clip == -1 and reserveAmmo <= 0 and secondaryAmmo <= 0
		or ply:GetActiveWeapon():GetClass() == "weapon_physcannon"
	then
		return false
	else
		return true
	end
end

-- Now we draw our own hud
hook.Add("HUDPaint", "TZHud_Draw", function()
	surface.SetDrawColor(0, 0, 0, 192)

	local ply = LocalPlayer()
	local health = ply:Health()
	local armor = ply:Armor()

	-- Check if the player is even alive before doing any of this
	if ply:Alive() then
		-- Health and Armor background panel
		surface.DrawRect(healthBoxPosX, healthBoxPosY, healthBoxW, healthBoxH)

		-- Health
		surface.SetFont("HudNumbersGlow")
		surface.SetTextPos(healthBoxPosX, healthBoxPosY)
		surface.SetTextColor(healthColor)
		surface.DrawText(health)

		surface.SetFont("HudNumbers")
		surface.SetTextPos(healthBoxPosX, healthBoxPosY)
		surface.DrawText(health)

		-- Armor
		-- Only draw Armor if the player has any
		if LocalPlayer():Armor() > 0 then
			surface.SetFont("HudNumbersGlow")
			surface.SetTextPos(healthBoxPosX, healthBoxPosY + 32)
			surface.SetTextColor(armorColor)
			surface.DrawText(armor)

			surface.SetFont("HudNumbers")
			surface.SetTextPos(healthBoxPosX, healthBoxPosY + 32)
			surface.DrawText(armor)
		end

		-- Ammo (magazine / clip)
		local weapon = ply:GetActiveWeapon()

		if checkUsesAmmo(weapon) then
			local clip = weapon:Clip1()

			surface.SetFont("HudNumbersGlow")
			surface.SetTextPos(healthBoxPosX + (healthBoxW - healthBoxW / 2.5), healthBoxPosY)
			surface.SetTextColor(magazineColor)
			surface.DrawText(clip)

			surface.SetFont("HudNumbers")
			surface.SetTextPos(healthBoxPosX + (healthBoxW - healthBoxW / 2.5), healthBoxPosY)
			surface.DrawText(clip)

			-- Ammo (Reserve)
			local ammoType = ply:GetActiveWeapon():GetPrimaryAmmoType()
			local secondAmmoType = weapon:GetSecondaryAmmoType()
			local reserveAmmo = ply:GetAmmoCount(ammoType)
			local secondaryAmmo = ply:GetAmmoCount(secondAmmoType)

			surface.SetFont("HudNumbersGlow")
			surface.SetTextPos(healthBoxPosX + (healthBoxW - healthBoxW / 4), healthBoxPosY)
			surface.SetTextColor(reserveAmmoColor)
			surface.DrawText(reserveAmmo)

			surface.SetFont("HudNumbers")
			surface.SetTextPos(healthBoxPosX + (healthBoxW - healthBoxW / 4), healthBoxPosY)
			surface.DrawText(reserveAmmo)

			-- Ammo (Secondary / Alt. Fire)
			-- Like armor, only draw if the player actually has any

			if secondaryAmmo > 0 then
				surface.SetFont("HudNumbersGlow")
				surface.SetTextPos(healthBoxPosX + (healthBoxW - healthBoxW / 4), healthBoxPosY + 32)
				surface.SetTextColor(secondaryAmmoColor)
				surface.DrawText(secondaryAmmo)

				surface.SetFont("HudNumbers")
				surface.SetTextPos(healthBoxPosX + (healthBoxW - healthBoxW / 4), healthBoxPosY + 32)
				surface.DrawText(secondaryAmmo)
			end
		end
	end
end)
