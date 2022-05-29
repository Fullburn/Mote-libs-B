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
    state.WeaponsMode:options('None', 'Sword', 'DualSword', 'Dagger', 'DualDagger', 'Club')
    state.OffenseMode:options('Normal', 'Acc')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.DefenseMode:options('Evasion', 'PDT')
    state.CastingMode:options('Normal', 'Acc1', 'Potency')

    -- Augmented gear definitions
    gear.Sucellos = {}
    gear.Sucellos.Cures = { name = "Sucellos's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','MND+10','"Cure" potency +10',} }
    gear.Sucellos.Nuke = { name = "Sucellos's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10',} }

    -- Additional local binds    
    send_command('bind f11 gs c cycle castingmode')

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
        body="Vitiation Tabard +2",
    }

    -- Fast cast sets for spells
    sets.precast.FC = {
        head="Atro. Chapeau +2", -- 14
        body="Vitiation Tabard +2", -- 14
        hands="Volte Gloves", --6
        legs="Aya. Cosciales +2", -- 6
        left_ear="Loquacious Earring", -- 2
        waist="Embla Sash", -- 5
    }

    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.midcast.Enfeebling_MND = {
        main="Marin Staff +1",
        sub="Enki Strap",
        ammo="Ombre Tathlum +1",
        head="Viti. Chapeau +2",
        body="Atrophy Tabard +3",
        hands="Nyame Gauntlets",
        legs="Atrophy Tights +2",
        feet="Vitiation Boots +2",
        neck="Sanctity Necklace",
        waist="Salire Belt",
        left_ear="Snotra Earring",
        right_ear="Malignance Earring",
        left_ring="Metamorph Ring +1",
        right_ring="Levia. Ring",
        back=gear.Sucellos.Cures,
    }

    sets.midcast.Cure = set_combine(sets.midcast.Enfeebling_MND, {
        main="Chatoyant Staff", --10%?
        sub="Enki Strap",
        hands={ name="Weath. Cuffs +1", augments={'MP+45',}}, --9%
    })

    sets.midcast.Curaga = sets.midcast.Cure   
    sets.midcast.SelfCure = set_combine(sets.midcast.Cure, { left_ring="Vocane Ring" })

    sets.midcast.Enfeebling_INT = {
        main="Marin Staff +1",
        sub="Enki Strap",
        ammo="Ombre Tathlum +1",
        head="Viti. Chapeau +2",
        body="Atrophy Tabard +3",
        hands="Jhakri Cuffs +2",
        legs="Jhakri Slops +2",
        feet="Vitiation Boots +2",
        neck="Sanctity Necklace",
        waist="Acuity Belt +1",
        left_ear="Snotra Earring",
        right_ear="Malignance Earring",
        left_ring="Metamorph Ring +1",
        right_ring="Shiva Ring +1",
        back=gear.Sucellos.Nuke,
    }

    sets.midcast.Enfeebling_INT.Potency = set_combine(sets.midcast.Enfeebling_INT, {
        hands="Volte Gloves",
        feet="Jhakri Pigaches +2",
    })

    sets.midcast.BlackMagic = set_combine(sets.midcast.Enfeebling_INT, {
        head="Jhakri Coronal +2",
        body="Jhakri Robe +2",
        hands="Jhakri Cuffs +2",
        left_ear="Hecate's Earring",
        right_ear="Malignance Earring",
    })

    sets.midcast.BlackMagic.Acc1 = set_combine(sets.midcast.BlackMagic, {
        left_ear="Snotra Earring",
    })

    sets.midcast['Enhancing Magic'] = {
        body="Vitiation Tabard +2",
        hands="Atrophy Gloves +2",
        legs="Atrophy Tights +2",
        feet="Estq. Houseaux +1",
        waist="Embla Sash",
        back=gear.Sucellos.Cures,
    }

    sets.midcast.Refresh = set_combine(sets.midcast['Enhancing Magic'], {
        body="Atrophy Tabard +3",
        legs="Estqr. Fuseau +2",
    })

    --------------------------------------
    -- Idle / Resting sets
    --------------------------------------

    sets.resting = {
        main="Chatoyant Staff",
        sub="Enki Strap",
        ammo="Homiliary",
        head="Viti. Chapeau +2",
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
        head="Viti. Chapeau +2",
        body="Jhakri Robe +2",
        hands="Volte Gloves",
        legs="Carmine Cuisses +1",
        feet="Nyame Sollerets",
        neck="Sanctity Necklace",
        waist="Sailfi Belt +1",
        left_ear="Influx Earring",
        right_ear="Phawaylla Earring",
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
        head="Blistering Sallet +1", --8%
        body="Ayanmo Corazza +2", --4%
        hands="Aya. Manopolas +2", --4%
        legs="Jhakri Slops +2", --2%
        feet="Chironic Slippers", --3%
        neck="Sanctity Necklace",
        waist="Sailfi Belt +1", --9%
        left_ear="Brutal Earring",
        right_ear="Suppanomimi",
        left_ring="Cho'j Band",
        right_ring="Rajas Ring",
        back="Atheling Mantle",
    }

    sets.engaged.Acc1 = set_combine(sets.engaged, {
        feet="Nyame Sollerets",
    })

    sets.engaged.Acc2 = set_combine(sets.engaged.Acc1, {
        head="Aya. Zucchetto +2",
        feet="Aya. Gambieras +2",
    })

    --------------------------------------
    -- Weapon sets
    --------------------------------------

    sets.weapons.Sword = {
        main="Naegling",
        sub="Beatific Shield +1",
    }

    sets.weapons.DualSword = {
        main="Naegling",
        sub="Demersal Degen +1",
    }

    sets.weapons.Dagger = {
        main="Kaja Knife",
        sub="Beatific Shield +1",
    }

    sets.weapons.DualDagger = {
        main="Kaja Knife",
        sub="Demersal Degen +1",
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
        ammo="Ginsen",
        head="Viti. Chapeau +2", -- 3% WSD, 47 att
        body="Jhakri Robe +2",
        hands="Jhakri Cuffs +2",
        legs="Jhakri Slops +2",
        feet="Jhakri Pigaches +2",
        neck="Sanctity Necklace",
        waist="Sailfi Belt +1",
        left_ear="Brutal Earring",
        right_ear=Moonshade,
        left_ring="Cho'j Band",
        right_ring="Rajas Ring",
        back="Atheling Mantle",
    }

    -- prefers DEX, crit rate, and fTP
    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {
        head="Blistering Sallet +1",
        neck="Light Gorget",
        waist="Light Belt",
    })

    -- prefers DEX, crit rate, and fTP
    sets.precast.WS['Evisceration'] = sets.precast.WS['Chant dy Cygne']

    -- 183 MAB, INT, DEX
    sets.precast.WS['Aeolian Edge'] = set_combine(sets.midcast.BlackMagic, {
    })

    sets.precast.WS['Sanguine Blade'] = set_combine(sets.midcast.BlackMagic, {
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
        msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
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
    
    msg = msg .. ', TH: ' .. state.TreasureMode.value

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