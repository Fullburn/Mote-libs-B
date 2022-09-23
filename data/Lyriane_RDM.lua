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
    state.WeaponsMode:options('None', 'Sword', 'Savage', 'DualSword', 'Dagger', 'DualDagger', 'Club')
    state.OffenseMode:options('Normal', 'Acc1', 'Acc2')
    state.RangedMode:options('Normal', 'Acc')
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

    -- Additional local binds    
    send_command('bind f11 gs c cycle castingmode')

    -- Buff tracking
    state.Buff['Composure'] = buffactive['Composure'] or false

    select_default_macro_book()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Called when this job file is unloaded (eg: job change)
function job_file_unload()
    send_command('unbind f11')
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
        right_ear="Lethargy Earring", -- 7
        waist="Embla Sash", -- 5
    }

    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.Enfeebling_MND = {
        main="Crocea Mors",
        
        head="Vitiation Chapeau +3",
        body="Lethargy Sayon +2",
        hands="Lethargy Gantherots +2",
        legs=gear.ChironicHose.Macc,
        feet="Vitiation Boots +3",
        neck="Duelist's Torque +1",
        waist="Obstinate Sash",
        left_ear="Snotra Earring",
        right_ear="Malignance Earring",
        left_ring="Metamorph Ring +1",
        right_ring="Kishar Ring",
        back=gear.Sucellos.Cures,
    }

    sets.midcast.Enfeebling_MND.Macc = set_combine(sets.midcast.Enfeebling_MND, {
        body="Atrophy Tabard +3",
    })

    sets.midcast.Cure = set_combine(sets.midcast.Enfeebling_MND, {
        main="Chatoyant Staff", --10%?
        sub="Enki Strap",
        hands={ name="Weath. Cuffs +1", augments={'MP+45',}}, --9%
        feet="Lethargy Houseaux +2",
        right_ring="Naji's Loop",
    })

    sets.midcast.Curaga = sets.midcast.Cure   
    sets.midcast.SelfCure = set_combine(sets.midcast.Cure, { left_ring="Vocane Ring" })

    sets.midcast.Enfeebling_INT = {
        main="Crocea Mors",
        ammo="Ghastly Tathlum +1",
        head="Vitiation Chapeau +3",
        body="Lethargy Sayon +2",
        hands="Lethargy Gantherots +2",
        legs=gear.ChironicHose.Macc,
        feet="Vitiation Boots +3",
        neck="Duelist's Torque +1",
        waist="Acuity Belt +1",
        left_ear="Snotra Earring",
        right_ear="Malignance Earring",
        left_ring="Metamorph Ring +1",
        right_ring="Kishar Ring",
        back=gear.Sucellos.Nuke,
    }

    sets.midcast.Enfeebling_INT.Potency = set_combine(sets.midcast.Enfeebling_INT, {
        right_ring="Shiva Ring +1",
    })

    sets.midcast.Enfeebling_INT.Macc = set_combine(sets.midcast.Enfeebling_INT, {
        body="Atrophy Tabard +3",
    })

    sets.midcast.BlackMagic = set_combine(sets.midcast.Enfeebling_INT, {
        main="Marin Staff +1",
        sub="Enki Strap",
        ammo="Ghastly Tathlum +1",
        head="Lethargy Chappel +2",
        body="Lethargy Sayon +2",
        hands="Lethargy Gantherots +2",
        legs="Lethargy Fuseau +2",
        neck="Sibyl Scarf",
        left_ear="Hecate's Earring",
        right_ear="Malignance Earring",
        right_ring="Shiva Ring +1",
    })

    sets.midcast.BlackMagic.MB = set_combine(sets.midcast.BlackMagic, {
        feet="Jhakri Pigaches +2",
    })

    sets.midcast.BlackMagic.Macc = set_combine(sets.midcast.BlackMagic, {
        left_ear="Snotra Earring",
    })

    sets.midcast['Enhancing Magic'] = {
        body="Vitiation Tabard +3",
        hands="Atrophy Gloves +3",
        legs="Atrophy Tights +2",
        feet="Lethargy Houseaux +2",
        waist="Embla Sash",
        right_ear="Lethargy Earring",
        back=gear.Sucellos.Cures,
    }

    sets.midcast.ComposureOther = set_combine(sets.midcast['Enhancing Magic'], {
        head="Lethargy Chappel +2",
        body="Lethargy Sayon +2",
        legs="Lethargy Fuseau +2",
    })

    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {
        body="Atrophy Tabard +3",
        legs="Lethargy Fuseau +2",
    })

    sets.midcast.Enspell = set_combine(sets.midcast['Enhancing Magic'], {
        hands="Vitiation Gloves +3",
        back="Ghostfyre Cape",
    })

    sets.midcast.Temper = sets.midcast.Enspell

    sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], {
        hands="Vitiation Gloves +3",
        waist="Siegel Sash",
    })

    sets.midcast.Gain = set_combine(sets.midcast['Enhancing Magic'], {
        hands="Vitiation Gloves +3",
    })

    sets.midcast.Spikes = set_combine(sets.midcast['Enhancing Magic'], {
        legs="Vitiation Tights +2",
    })

    sets.midcast['Dark Magic'] = set_combine(sets.midcast.BlackMagic, {
        neck = "Erra Pendant",
    })

    --------------------------------------
    -- Idle / Resting sets
    --------------------------------------

    sets.resting = {
        main="Chatoyant Staff",
        sub="Enki Strap",
        ammo="Homiliary",
        head="Vitiation Chapeau +3",
        body="Jhakri Robe +2",
        hands="Volte Gloves",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Sanctity Necklace",
        left_ring="Metamorph Ring +1",
        right_ring="Metamorph Ring",
        back=gear.Sucellos.Cures,
    }

    sets.idle = { 
        ammo="Homiliary",
        head="Vitiation Chapeau +3",
        body="Jhakri Robe +2",
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
        ammo="Coiste Bodhar",
        head="Malignance Chapeau",
        --head="Blistering Sallet +1", --8%
        body="Ayanmo Corazza +2", --4%
        hands="Ayanmo Manopolas +2", --4%
        legs="Malignance Tights", --9%
        feet="Chironic Slippers", --3%
        neck="Anu Torque",
        waist="Sailfi Belt +1", --9%
        left_ear="Brutal Earring",
        right_ear="Cessance Earring",
        left_ring="Ilabrat Ring",
        right_ring="Rajas Ring",
        back=gear.Sucellos.STP,
    }

    sets.engaged.Acc1 = set_combine(sets.engaged, {
        feet="Nyame Sollerets",
        neck="Sanctity Necklace",
    })

    sets.engaged.Acc2 = set_combine(sets.engaged.Acc1, {
        head="Ayanmo Zucchetto +2",
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
        ammo="Coiste Bodhar",
        head="Vitiation Chapeau +3", -- 6% WSD, 62 att
        body="Vitiation Tabard +3",
        hands="Jhakri Cuffs +2",
        legs="Lethargy Fuseau +2",
        feet="Lethargy Houseaux +2",
        neck="Republican Platinum Medal",
        waist="Sailfi Belt +1",
        left_ear="Brutal Earring",
        right_ear=gear.Moonshade,
        left_ring="Ilabrat Ring",
        right_ring="Rajas Ring",
        back=gear.Sucellos.Cures,
    }

    -- prefers DEX, crit rate, and fTP
    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {
        head="Blistering Sallet +1",
        neck="Fotia Gorget",
        waist="Fotia Belt",
    })

    -- prefers DEX, crit rate, and fTP
    sets.precast.WS['Evisceration'] = sets.precast.WS['Chant dy Cygne']

    -- Magical WS
    sets.precast.WS.ElementalWS = set_combine(sets.midcast.BlackMagic, {
        -- neck="Fotia Gorget",
        -- waist="Fotia Belt",
        left_ear=gear.Moonshade,
        back=gear.Sucellos.ElementalWS,
    })

    sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS.ElementalWS, {
        neck="Sibyl Scarf",
        waist="Eschan Stone",
    })

    --------------------------------------
    -- Special sets (required by rules)
    --------------------------------------

    sets.Kiting = { legs="Carmine Cuisses +1" }

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
        neck="Inquisitor Bead Necklace",
        right_ring="Vocane Ring", --7%
        back="Shadow Mantle",
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

function customize_idle_set(idleSet)
    if player.hpp < 80 then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
    end

    return idleSet
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