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
    state.WeaponsMode:options('None', 'Sword', 'Savage', 'DualSword', 'Seraph', 'Dagger', 'DualDagger', 'Club')
    state.OffenseMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.DefenseMode:options('Hybrid', 'None')
    state.CastingMode:options('Normal', 'MB', 'Potency', 'Macc')

    -- Augmented gear definitions
    gear.Sucellos = {}
    gear.Sucellos.Cures = { name = "Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Cure" potency +10',} }
    gear.Sucellos.Nuke = { name = "Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',} }
    gear.Sucellos.STP = { name = "Sucellos's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',} }
    gear.Sucellos.WSD = { name = "Sucellos's Cape", augments = { 'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',} }
    gear.Sucellos.ElementalWS = { name = "Sucellos's Cape", augments = { 'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','Weapon skill damage +10%',} }

    gear.ChironicHose = {}
    gear.ChironicHose.Macc = { name = "Chironic Hose", augments={'Mag. Acc.+28','Enmity-5','INT+14',}}

    -- Additional plugins
    send_command('lua l xivparty')

    -- Additional local binds   
    send_command('bind f11 gs c cycle castingmode')
    send_command('bind ^insert input /ma "Stone IV" <t>')
    send_command('bind ^home input /ma "Water IV" <t>')
    send_command('bind ^pageup input /ma "Aero IV" <t>')
    send_command('bind ^delete input /ma "Fire IV" <t>')
    send_command('bind ^end input /ma "Blizzard IV" <t>')
    send_command('bind ^pagedown input /ma "Thunder IV" <t>')

    send_command('bind !insert input /ma "Stone V" <t>')
    send_command('bind !home input /ma "Water V" <t>')
    send_command('bind !pageup input /ma "Aero V" <t>')
    send_command('bind !delete input /ma "Fire V" <t>')
    send_command('bind !end input /ma "Blizzard V" <t>')
    send_command('bind !pagedown input /ma "Thunder V" <t>')

    send_command('bind ~insert input /ma "Barstonra" <me>')
    send_command('bind ~home input /ma "Barwatera" <me>')
    send_command('bind ~pageup input /ma "Baraera" <me>')
    send_command('bind ~delete input /ma "Barfira" <me>')
    send_command('bind ~end input /ma "Barblizzara" <me>')
    send_command('bind ~pagedown input /ma "Barthundra" <me>')

    -- Buff tracking
    state.Buff['Composure'] = buffactive['Composure'] or false
    state.Buff['Saboteur'] = buffactive['Saboteur'] or false

    select_default_macro_book()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Called when this job file is unloaded (eg: job change)
function job_file_unload()
    send_command('lua u xivparty')

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

    send_command('unbind ~insert')
    send_command('unbind ~home')
    send_command('unbind ~pgup')
    send_command('unbind ~delete')
    send_command('unbind ~end')
    send_command('unbind ~pgdn')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA.Chainspell = {
        body="Vitiation Tabard +3",
    }

    -- Fast cast sets for spells
    sets.precast.FC = {
        main="Crocea Mors", -- 20
        head="Lethargy Chappel +2", -- 14 cast time? Does it stack?
        body="Vitiation Tabard +3", -- 16
        hands="Volte Gloves", --6
        legs="Ayanmo Cosciales +2", -- 6
        left_ear="Malignance Earring", -- 4
        right_ear="Lethargy Earring", -- 7
        waist="Embla Sash", -- 5
    }

    sets.precast.FC.Dispelga = set_combine(sets.precast.FC, {
        main="Daybreak",
    })

    sets.precast.FC.Regen = set_combine(sets.precast.FC, {
        main="Bolelabunga",
    })

    --------------------------------------
    -- Midcast sets
    --------------------------------------

    -- Enfeebling sets

    sets.midcast.Enfeebling_MND = {
        main="Crocea Mors",
        sub="Culminus",
        head="Vitiation Chapeau +3",
        body="Lethargy Sayon +2",
        hands="Lethargy Gantherots +2",
        legs=gear.ChironicHose.Macc,
        feet="Vitiation Boots +3",
        neck="Duelist's Torque +1",
        waist="Obstinate Sash",
        left_ear="Malignance Earring",
        right_ear="Snotra Earring",
        left_ring="Metamorph Ring +1",
        right_ring="Kishar Ring",
        back=gear.Sucellos.Cures,
    }

    sets.midcast.Enfeebling_MND.Macc = set_combine(sets.midcast.Enfeebling_MND, {
        body="Atrophy Tabard +3",
        right_ring="Regal Ring",
    })

    sets.midcast.Cure = set_combine(sets.midcast.Enfeebling_MND, {
        main="Chatoyant Staff", --10% + weather bonus
        sub="Enki Strap",
        head="Gendewitha Caubeen +1", --18%
        hands={ name="Weath. Cuffs +1", augments={'MP+45',}}, --9%
        legs="Atrophy Tights +2", --11%
        feet="Lethargy Houseaux +3", -- -11 enmity
    })

    sets.midcast.Curaga = sets.midcast.Cure   
    sets.midcast.SelfCure = set_combine(sets.midcast.Cure, { left_ring="Vocane Ring" })

    sets.midcast.Enfeebling_INT = {
        main="Crocea Mors",
        sub="Culminus",
        range="",
        ammo="Ghastly Tathlum +1",
        head="Vitiation Chapeau +3",
        body="Lethargy Sayon +2",
        hands="Lethargy Gantherots +2",
        legs=gear.ChironicHose.Macc,
        feet="Vitiation Boots +3",
        neck="Duelist's Torque +1",
        waist="Acuity Belt +1",
        left_ear="Malignance Earring",
        right_ear="Snotra Earring",
        left_ring="Metamorph Ring +1",
        right_ring="Kishar Ring",
        back=gear.Sucellos.Nuke,
    }

    sets.midcast.Enfeebling_INT.Potency = set_combine(sets.midcast.Enfeebling_INT, {
        right_ring="Shiva Ring +1",
    })

    sets.midcast.Enfeebling_INT.Macc = set_combine(sets.midcast.Enfeebling_INT, {
        body="Atrophy Tabard +3",
        right_ring="Regal Ring",
    })
    
    sets.midcast.Dispelga = set_combine(sets.midcast.Enfeebling_INT, {
        main="Daybreak",
    })

    sets.midcast.BlackMagic = set_combine(sets.midcast.Enfeebling_INT, {
        main="Marin Staff +1",
        sub="Enki Strap",
        range="",
        ammo="Sroda Tathlum",
        head="Lethargy Chappel +2",
        legs="Lethargy Fuseau +2",
        neck="Sibyl Scarf",
        left_ear="Malignance Earring",
        right_ear="Hecate's Earring",
        right_ring="Shiva Ring +1",
    })

    sets.midcast.BlackMagic.MB = set_combine(sets.midcast.BlackMagic, {
        feet="Jhakri Pigaches +2",
    })

    sets.midcast.BlackMagic.Macc = set_combine(sets.midcast.BlackMagic, {
        left_ear="Snotra Earring",
    })

    sets.midcast['Enhancing Magic'] = {
        head="Telchine Cap",
        body="Vitiation Tabard +3",
        hands="Atrophy Gloves +3",
        legs="Atrophy Tights +2",
        feet="Lethargy Houseaux +3",
        neck="Duelist's Torque +1",
        waist="Embla Sash",
        right_ear="Lethargy Earring",
        back="Ghostfyre Cape",
    }

    sets.midcast.ComposureOther = set_combine(sets.midcast['Enhancing Magic'], {
        head="Lethargy Chappel +2",
        body="Lethargy Sayon +2",
        legs="Lethargy Fuseau +2",
    })

    sets.midcast.Regen = set_combine(sets.midcast['Enhancing Magic'], {
        main="Bolelabunga",
        legs="Telchine Braconi",
    })

    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {
        body="Atrophy Tabard +3",
        legs="Lethargy Fuseau +2",
    })

    sets.midcast.Enspell = set_combine(sets.midcast['Enhancing Magic'], {
        head="Befouled Crown",
        hands="Vitiation Gloves +3",
    })

    sets.midcast.Temper = set_combine(sets.midcast.Enspell, {
        legs="Atrophy Tights +2",
    })

    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
        hands="Vitiation Gloves +3",
        waist="Siegel Sash",
    })

    sets.midcast.Gain = set_combine(sets.midcast['Enhancing Magic'], {
        hands="Vitiation Gloves +3",
    })

    sets.midcast.Spikes = set_combine(sets.midcast['Enhancing Magic'], {
        legs="Vitiation Tights +3",
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
        range="",
        ammo="Homiliary",
        head="Vitiation Chapeau +3",
        body="Lethargy Sayon +2",
        hands="Volte Gloves",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Sibyl Scarf",
        left_ring="Metamorph Ring +1",
        right_ring="Mephitas's Ring +1",
        back=gear.Sucellos.Cures,
    }

    sets.idle = { 
        range="",
        ammo="Homiliary",
        head="Vitiation Chapeau +3",
        body="Lethargy Sayon +2",
        hands="Volte Gloves",
        legs="Carmine Cuisses +1",
        feet="Nyame Sollerets",
        neck="Sibyl Scarf",
        waist="Sailfi Belt +1",
        left_ear="Influx Earring",
        right_ear="Lethargy Earring",
        left_ring="Metamorph Ring +1",
        right_ring="Vocane Ring",
        back=gear.Sucellos.Cures,
    }

    --------------------------------------
    -- Combat sets
    --------------------------------------

    -- Normal melee group, max haste + DW + multiattack
    sets.engaged = {
        range="",
        ammo="Sroda Tathlum",
        head="Malignance Chapeau",
        --head="Blistering Sallet +1", --8%
        body="Ayanmo Corazza +2", --4%
        hands="Ayanmo Manopolas +2", --4%
        legs="Malignance Tights", --9% STP 10
        feet="Malignance Boots", -- STP 9
        neck="Anu Torque",
        waist="Sailfi Belt +1", --9%
        left_ear="Suppanomimi",
        right_ear="Cessance Earring",
        left_ring="Ilabrat Ring",
        right_ring="Rajas Ring",
        back=gear.Sucellos.STP,
    }

    sets.engaged.Acc = set_combine(sets.engaged, {
        neck="Sanctity Necklace",
    })

    --------------------------------------
    -- Weapon sets
    --------------------------------------

    sets.weapons.Sword = {
        main="Crocea Mors",
        sub="Beatific Shield +1",
    }

    sets.weapons.Savage = {
        main="Naegling",
        sub="Beatific Shield +1",
    }

    sets.weapons.DualSword = {
        main="Crocea Mors",
        sub="Tauret",
    }

    sets.weapons.Seraph = {
        main="Crocea Mors",
        sub="Daybreak",
    }

    sets.weapons.Dagger = {
        main="Tauret",
        sub="Beatific Shield +1",
    }

    sets.weapons.DualDagger = {
        main="Tauret",
        sub="Crocea Mors",
    }

    sets.weapons.Club = {
        main="Kaja Rod",
        sub="Beatific Shield +1",
    }

    --------------------------------------
    -- Weaponskill sets
    --------------------------------------

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        range="",
        ammo="Oshasha's Treatise",
        head="Vitiation Chapeau +3", -- 6% WSD, 62 att
        body="Vitiation Tabard +3",
        hands="Jhakri Cuffs +2", --7% WSD, 43 att
        legs="Lethargy Fuseau +2",
        feet="Lethargy Houseaux +3", --12% WSD, 60 att
        neck="Republican Platinum Medal",
        waist="Sailfi Belt +1",
        left_ear="Brutal Earring",
        right_ear=gear.Moonshade,
        left_ring="Ilabrat Ring",
        right_ring="Rajas Ring",
        back=gear.Sucellos.Cures,
    }

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        left_ear="Malignance Earring",
        left_ring="Sroda Ring",
        right_ring="Metamorph Ring +1",
    })

    -- prefers DEX, crit rate, and fTP
    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {
        head="Blistering Sallet +1",
        feet="Ayanmo Gambieras +2",
        neck="Fotia Gorget",
        waist="Fotia Belt",
    })

    -- prefers DEX, crit rate, and fTP
    sets.precast.WS['Evisceration'] = sets.precast.WS['Chant du Cygne']

    -- Magical WS
    sets.precast.WS.ElementalWS = set_combine(sets.midcast.BlackMagic, {
        head="Vitiation Chapeau +3", -- 6% WSD
        hands="Jhakri Cuffs +2", --7% WSD
        feet="Lethargy Houseaux +3", --12% WSD, 50 MAB
        right_ear=gear.Moonshade,
        back=gear.Sucellos.ElementalWS,
    })

    sets.precast.WS["Seraph Blade"] = set_combine(sets.precast.WS.ElementalWS, {
        waist="Eschan Stone",
        back=gear.Sucellos.ElementalWS,
        right_ring="Sroda Ring",
    })

    sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS.ElementalWS, {
        head="Pixie Hairpin +1",
        waist="Eschan Stone",
        right_ring="Shiva Ring +1",
    })

    --------------------------------------
    -- Special sets (required by rules)
    --------------------------------------

    sets.Kiting = { legs="Carmine Cuisses +1" }

    sets.Cursna = {
        neck="Nicander's Necklace",
        waist="Gishdubar Sash",
        left_ring="Blenmot's Ring",
    }

    sets.TreasureHunter = {
        range="",
        ammo="Perfect Lucky Egg",
        head="White Rarab Cap +1",
        feet="Volte Boots",
        waist="Chaac Belt",
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

    sets.defense.Hybrid = set_combine(sets.defense, {
        head="Malignance Chapeau",
        body="Lethargy Sayon +2",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
    })
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
    if spell.skill == 'Enhancing Magic' and spell.target.type ~= 'SELF' and state.Buff['Composure'] then
        return 'ComposureOther'
    end

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

-- function customize_idle_set(idleSet)
--     if player.hpp < 80 then
--         idleSet = set_combine(idleSet, sets.ExtraRegen)
--     end

--     return idleSet
-- end

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

    if state.CastingMode.value ~= 'None' then
        msg = msg .. ', ' .. 'Magic: ' .. state.CastingMode.value
    end
    
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