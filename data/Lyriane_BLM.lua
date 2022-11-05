-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
    Custom commands:

    gs c cycle treasuremode (set on ctrl-= by default): Cycles through the available treasure hunter modes.
    
    Treasure hunter modes:
        None - Will never equip TH gear
        Tag - Will equip TH gear sufficient for initial contact with a mob (either melee, ranged hit, or Aeolian Edge AOE)
        SATA - Will equip TH gear sufficient for initial contact with a mob, and when using SATA
        Fulltime - Will keep TH gear equipped fulltime

--]]

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 3
    
    -- Load and initialize the include file.
    include('Mote-Include-B.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    -- Mode definitions
    state.WeaponsMode:options('None', 'Dagger', 'Staff', 'Club')
    state.OffenseMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.DefenseMode:options('None')
    state.CastingMode:options('Normal', 'MB', 'Potency', 'Macc')

    -- Augmented gear definitions
    gear.Sucellos = {}

    gear.ChironicHose = {}

    -- Additional local binds   
    send_command('bind f11 gs c cycle castingmode')
    send_command('bind ^insert input /ma "Stone IV" <t>')
    send_command('bind ^home input /ma "Water IV" <t>')
    send_command('bind ^pageup input /ma "Aero IV" <t>')
    send_command('bind ^delete input /ma "Fire IV" <t>')
    send_command('bind ^end input /ma "Blizzard IV" <t>')
    send_command('bind ^pagedown input /ma "Thunder IV" <t>')

    send_command('bind !insert input /ma "Stone VI" <t>')
    send_command('bind !home input /ma "Water VI" <t>')
    send_command('bind !pageup input /ma "Aero VI" <t>')
    send_command('bind !delete input /ma "Fire VI" <t>')
    send_command('bind !end input /ma "Blizzard VI" <t>')
    send_command('bind !pagedown input /ma "Thunder VI" <t>')

    -- Buff tracking
    --state.Buff['Composure'] = buffactive['Composure'] or false

    select_default_macro_book()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Called when this job file is unloaded (eg: job change)
function job_file_unload()
    send_command('unbind f11')
    send_command('unbind ^insert')
    send_command('unbind ^home')
    send_command('unbind ^pgup')
    send_command('unbind ^delete')
    send_command('unbind ^end')
    send_command('unbind ^pgdn')

    send_command('unbind !insert')
    send_command('unbind !home')
    send_command('unbind !pgup')
    send_command('unbind !delete')
    send_command('unbind !end')
    send_command('unbind !pgdn')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs

    -- Fast cast sets for spells
    sets.precast.FC = {
        main="Marin Staff +1", --3
        head="Nahtirah Hat", -- 10
        body="Shango Robe", -- 8
        hands="Volte Gloves", --6
        legs="Jhakri Slops +2", -- set bonus 1
        feet="Jhakri Pigaches +2", -- set bonus 1
        right_ear="Loquacious Earring", -- 2
        left_ring="Kishar Ring", --4
        right_ring="Jhakri Ring", --set bonus 1
        waist="Embla Sash", -- 5
    }

    sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {
        main="Daybreak",
    })

    --------------------------------------
    -- Midcast sets
    --------------------------------------

    -- Nuking sets

    sets.midcast.BlackMagic = {
        main="Marin Staff +1",
        sub="Enki Strap",
        ammo="Ghastly Tathlum +1",
        head="Jhakri Coronal +2",
        body="Jhakri Robe +2",
        hands="Jhakri Cuffs +2",
        legs="Jhakri Slops +2",
        feet="Jhakri Pigaches +2",
        neck="Sibyl Scarf",
        waist="Acuity Belt +1",
        left_ear="Malignance Earring",
        right_ear="Wicce Earring",
        left_ring="Metamorph Ring +1",
        right_ring="Shiva Ring +1",
        back="Bane Cape",
    }
    
    sets.midcast.BlackMagic.MB = set_combine(sets.midcast.BlackMagic, {
    })

    sets.midcast.BlackMagic.Macc = set_combine(sets.midcast.BlackMagic, {
        neck="Erra Pendant",
    })

    -- Enfeebling sets

    sets.midcast.Enfeebling_INT = set_combine(sets.midcast.BlackMagic, {
        neck="Erra Pendant",
        right_ring="Kishar Ring",
    })

    sets.midcast.Enfeebling_MND = set_combine(sets.midcast.Enfeebling_INT, {
    })

    sets.midcast.Cure = set_combine(sets.midcast.Enfeebling_MND, {
        main="Chatoyant Staff", --10% + weather bonus
        sub="Enki Strap",
        hands="Weath. Cuffs +1", --9%
    })

    sets.midcast.Curaga = sets.midcast.Cure   
    sets.midcast.SelfCure = set_combine(sets.midcast.Cure, { left_ring="Vocane Ring" })
    
    sets.midcast.Dispelga = set_combine(sets.midcast.Enfeebling_INT, {
        main="Daybreak",
    })

    sets.midcast['Enhancing Magic'] = {
        waist="Embla Sash",
    }

    sets.midcast.Regen = set_combine(sets.midcast['Enhancing Magic'], {
        main="Bolelabunga",
    })

    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
        waist="Siegel Sash",
    })

    sets.midcast.Spikes = set_combine(sets.midcast['Enhancing Magic'], {
    })

    sets.midcast['Dark Magic'] = set_combine(sets.midcast.BlackMagic, {
        head="Pixie Hairpin +1",
        neck = "Erra Pendant",
    })

    --------------------------------------
    -- Idle / Resting sets
    --------------------------------------

    sets.resting = {
        main="Chatoyant Staff",
        sub="Enki Strap",
        head="Nyame Helm",
        body="Jhakri Robe +2",
        hands="Volte Gloves",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Sibyl Scarf",
        left_ring="Metamorph Ring +1",
        right_ring="Metamorph Ring",
        back="Bane Cape",
    }

    sets.idle = { 
        main="Bolelabunga",
        sub="Culminus",
        ammo="Ghastly Tathlum +1",
        head="Nyame Helm",
        body="Jhakri Robe +2",
        hands="Volte Gloves",
        legs="Assid. Pants +1",
        feet="Herald's Gaiters",
        neck="Sibyl Scarf",
        waist="Acuity Belt +1",
        left_ear="Influx Earring",
        right_ear="Wicce Earring",
        left_ring="Metamorph Ring +1",
        right_ring="Vocane Ring",
        back="Bane Cape",
    }

    --------------------------------------
    -- Combat sets
    --------------------------------------

    -- Normal melee group, max haste + DW + multiattack
    sets.engaged = {
        ammo="Oshasha's Treatise",
        head="Blistering Sallet +1", --8
        body="Nyame Mail", --3
        hands="Nyame Gauntlets", --3 
        legs="Jhakri Slops +2", --2
        feet="Nyame Sollerets", --3
        neck="Subtlety Spectacles",
        waist="Eschan Stone",
        left_ear="Brutal Earring",
        right_ear="Cessance Earring",
        left_ring="Rajas Ring",
        right_ring="Vocane Ring",
        back="Bane Cape",
    }

    --------------------------------------
    -- Weapon sets
    --------------------------------------

    sets.weapons.Dagger = {
        main="Ternion Dagger +1",
        sub="Culminus",
    }

    sets.weapons.Staff = {
        main="Malignance Pole",
        sub="Enki Strap",
    }

    sets.weapons.Club = {
        main="Kaja Rod",
        sub="Culminus",
    }

    --------------------------------------
    -- Weaponskill sets
    --------------------------------------

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo="Oshasha's Treatise",
        head="Nyame Helm", 
        body="Nyame Mail",
        hands="Jhakri Cuffs +2", 
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Republican Platinum Medal",
        waist="Eschan Stone",
        left_ear="Brutal Earring",
        right_ear=gear.Moonshade,
        left_ring="Rajas Ring",
        right_ring="Metamorph Ring +1",
        back="Bane Cape",
    }

    -- prefers DEX, crit rate, and fTP
    sets.precast.WS.Evisceration = set_combine(sets.precast.WS, {
        head="Blistering Sallet +1",
        neck="Fotia Gorget",
        waist="Fotia Belt",
    })

    -- Magical WS
    sets.precast.WS.ElementalWS = set_combine(sets.midcast.BlackMagic, {
        hands="Jhakri Cuffs +2", --7% WSD, 43 att
        left_ear=gear.Moonshade,
    })

    sets.precast.WS.Cataclysm = set_combine(sets.precast.WS.ElementalWS, {
        head="Pixie Hairpin +1",
    })

    --------------------------------------
    -- Special sets (required by rules)
    --------------------------------------

    sets.Kiting = { feet="Herald's Gaiters" }

    sets.Cursna = {
         waist="Gishdubar Sash",
         left_ring="Blenmot's Ring",
    }

    --------------------------------------
    -- Defense sets
    --------------------------------------
    
    -- Capped PDT and high eva/m.eva/hp/def
    sets.defense = {
        head="Nyame Helm", --7%
        body="Nyame Mail", --9%
        hands="Nyame Gauntlets", --7%
        legs="Nyame Flanchard", --8%
        feet="Nyame Sollerets", --7%
        right_ring="Vocane Ring", --7%
    }
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- -- Run after the general precast() is done.
-- function job_post_precast(spell, action, spellMap, eventArgs)
-- end

-- Run after the general midcast() set is constructed.
-- function job_post_midcast(spell, action, spellMap, eventArgs)
-- end

-- -- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- function job_aftercast(spell, action, spellMap, eventArgs)
-- end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
-- function job_buff_change(buff, gain)
--     if not midaction() then
--         handle_equipping_gear(player.status)
--     end
-- end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
    downgrade_spell(spell, action, spellMap, eventArgs)
end

-- Custom spell mapping, for when more than just the spell name matters (targets, buffs, etc.)
function job_get_spell_map(spell, default_spell_map)
    -- if spell.action_type == 'Magic' then
    --     if default_spell_map == 'Cure' or default_spell_map == 'Curaga' then
    --         if (world.weather_element == 'Light' or world.day_element == 'Light') then
    --             return 'CureWeather'
    --         end
    --     end
    -- end

    if default_spell_map == 'Cure' and spell.target.type == 'SELF' then
        return 'SelfCure'
    end
end

-- Called by the 'update' self-command.
-- function job_update(cmdParams, eventArgs)
-- end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
    local msg = 'Melee'
    
    if state.CombatForm.has_value then
        msg = msg .. ' (' .. state.CombatForm.value .. ')'
    end
    
    msg = msg .. ': '
    
    msg = msg .. state.OffenseMode.value
    msg = msg .. ', WS: ' .. state.WeaponskillMode.value
    
    if state.DefenseMode.value ~= 'None' then
        msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value
    end
    
    if state.Kiting.value == true then
        msg = msg .. ', Kiting'
    end

    if state.PCTargetMode.value ~= 'default' then
        msg = msg .. ', Target PC: '..state.PCTargetMode.value
    end

    if state.SelectNPCTargets.value == true then
        msg = msg .. ', Target NPCs'
    end

    add_to_chat(122, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WHM' then
        set_macro_page(1, 1)
    elseif player.sub_job == 'BLM' then
        set_macro_page(1, 1)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 1)
    else
        set_macro_page(1, 1)
    end
end