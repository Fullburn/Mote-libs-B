-------------------------------------------------------------------------------------------------------------------
-- Tables and functions for commonly-referenced gear that job files may need, but
-- doesn't belong in the global Mote-Include file since they'd get clobbered on each
-- update.
-- Creates the 'gear' table for reference in other files.
--
-- Note: Function and table definitions should be added to user, but references to
-- the contained tables via functions (such as for the obi function, below) use only
-- the 'gear' table.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- Modify the sets table.  Any gear sets that are added to the sets table need to
-- be defined within this function, because sets isn't available until after the
-- include is complete.  It is called at the end of basic initialization in Mote-Include.
-------------------------------------------------------------------------------------------------------------------

function define_global_sets()
	-- Special gear info that may be useful across jobs.

	-- Staffs
	gear.Staff = {}
	gear.Staff.HMP = 'Chatoyant Staff'
	gear.Staff.PDT = 'Earth Staff'
	
	-- Dark Rings
	gear.DarkRing = {}
	
	-- Default items for utility gear values.
	gear.default.weaponskill_neck = "Asperity Necklace"
	gear.default.weaponskill_waist = "Caudata Belt"
	gear.default.obi_waist = "Cognition Belt"
	gear.default.obi_back = "Toro Cape"
	gear.default.obi_ring = "Strendu Ring"
	gear.default.fastcast_staff = ""
	gear.default.recast_staff = ""

    gear.Moonshade = { name="Moonshade Earring", augments={'Accuracy+4','TP Bonus +250',}}

    gear.AdhemarJacket = {}
	gear.AdhemarJacket.Attack = { name="Adhemar Jacket +1", augments={'STR+12','DEX+12','Attack+20',}}

    gear.AdhemarWrists = {}
	gear.AdhemarWrists.Attack = { name="Adhemar Wrist. +1", augments = {'STR+12','DEX+12','Attack+20',} }

    gear.HerculeanFeet = {}
    gear.HerculeanFeet.FC = {name="Herculean Boots", augments={'Sklchn.dmg.+6%','DEX+5','"Fast Cast"+4','Mag. Acc.+19 "Mag.Atk.Bns."+19',}}

	-- Definitions for global functionality
	info.Incapacitated = S{ "terror", "petrification", "sleep", "stun"}
	info.Doomed = S{"doom"}
end

-------------------------------------------------------------------------------------------------------------------
-- Functions to set user-specified binds, generally on load and unload.
-- Kept separate from the main include so as to not get clobbered when the main is updated.
-------------------------------------------------------------------------------------------------------------------

-- Function to bind GearSwap binds when loading a GS script.
function global_on_load()
    -- ^ stands for the Ctrl key.
	-- ! stands for the Alt key. 
    -- @ stands for the Windows key.

	-- F9 manages defense
	send_command('bind f9 gs c cycle DefenseLevel')
	send_command('bind ^f9 gs c cycle DefenseMode')
	send_command('bind !f9 gs c toggle Kiting')

	-- F10 manages offense
	send_command('bind f10 gs c cycle WeaponsMode')
	send_command('bind ^f10 gs c cycle OffenseMode')
    send_command('bind !f10 gs c cycle WeaponskillMode')

	-- F11 manages job-specific toggles (found in job-specific files)

	-- F12 manages debug info and gear lock
    send_command('bind f12 gs c lockGear') -- Locks idle/engage to current gear until disabled.
	send_command('bind ^f12 gs c cycle EquipStop')
	send_command('bind !f12 gs c update user')

    -- send_command('bind !, fillmode 1')
    -- send_command('bind !. fillmode 0')
	send_command('bind numpad/ fillmode')

	-- oh shit spells for all jobs
	send_command('bind !, input /ma "Utsusemi: Ichi" <me>')
    send_command('bind !. input /ma "Utsusemi: Ni" <me>')
	send_command('bind !/ input /ma "Occultation" <me>')

    send_command('bind !e input /item "Echo Drops" <me>')
    send_command('bind !r input /item "Remedy" <me>')
    send_command('bind !p input /item "Panacea" <me>')
    send_command('bind !h input /item "Holy Water" <me>')
    send_command('bind !w input /equip ring2 "Warp Ring"; /echo Warping; wait 11; input /item "Warp Ring" <me>;')
    send_command('bind !q input /equip ring2 "Dim. Ring (Dem)"; /echo Reisenjima; wait 11; input /item "Dim. Ring (Dem)" <me>;')

	-- send_command('bind ^- gs c toggle selectnpctargets')
	-- send_command('bind ^= gs c cycle pctargetmode')
end

-- Function to revert binds when unloading.
function global_on_unload()
	send_command('unbind f9')
	send_command('unbind ^f9')
	send_command('unbind !f9')
	send_command('unbind f10')
	send_command('unbind ^f10')
	send_command('unbind !f10')
	send_command('unbind f12')
	send_command('unbind ^f12')
	send_command('unbind !f12')

	send_command('unbind !,')
	send_command('unbind !.')
	send_command('unbind !/')
	send_command('unbind numpad/')
	send_command('unbind !e')
	send_command('unbind !r')
	send_command('unbind !p')
	send_command('unbind !h')
	send_command('unbind !w')
	send_command('unbind !q')
end

-------------------------------------------------------------------------------------------------------------------
-- Global event-handling functions.
-------------------------------------------------------------------------------------------------------------------

function user_handle_equipping_gear (playerStatus, eventArgs)
	-- Always put defense set on if unable to act, even if defense mode isn't on.
	if has_any_buff_of(info.Incapacitated) then
		equip(apply_defense({}))
		eventArgs.handled = true

	-- And always put on the cursna set if doomed, as top priority
	elseif has_any_buff_of(info.Doomed) then
		equip(apply_cursna({}))
		eventArgs.handled = true
	end
end

-- Global intercept on precast.
function user_precast(spell, action, spellMap, eventArgs)
    cancel_conflicting_buffs(spell, action, spellMap, eventArgs)
    refine_waltz(spell, action, spellMap, eventArgs)
end

-- Global intercept on midcast.
function user_midcast(spell, action, spellMap, eventArgs)
	-- Default base equipment layer of fast recast.
	if spell.action_type == 'Magic' and sets.midcast and sets.midcast.FastRecast then
		equip(sets.midcast.FastRecast)
	end
end

-- Global intercept on buff change.
function user_buff_change(buff, gain, eventArgs)
    local name = string.lower(buff)

	-- Create a timer when we gain weakness.  Remove it when weakness is gone.
	if name == 'weakness' then
		if gain then
			send_command('timers create "Weakness" 300 up abilities/00255.png')
		else
			send_command('timers delete "Weakness"')
		end
	end

	if name == 'doom' then
		if gain then
			send_command('input /p <me> DOOMED! X_X')
		else
			send_command('input /p <me> SAFE!')
		end
	elseif name == 'charm' then
		if gain then
			send_command('input /p <me> CHARMED! @_@')
		else
			send_command('input /p <me> SAFE!')
		end
	end

	if not midaction() and (info.Incapacitated:contains(name) or info.Doomed:contains(name)) then
		handle_equipping_gear(player.status)
		eventArgs.handled = true
	end
end

