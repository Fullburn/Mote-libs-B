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
    state.WeaponsMode:options('None', 'Sword', 'Savage', 'Dagger', 'DualSword', 'Lance', 'Staff')
    state.OffenseMode:options('Tank', 'Normal')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.DefenseMode:options('Hybrid', 'None')
    state.CastingMode:options('Normal')

    state.DefenseLevel:set('On')

    -- Augmented gear definitions
    gear.Sucellos = {}

    -- Additional plugins

    -- Additional local binds

    -- Buff tracking
    state.Buff['Composure'] = buffactive['Composure'] or false

    select_default_macro_book()
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Called when this job file is unloaded (eg: job change)
function job_file_unload()
end

-- Define sets and vars used by this job file.
function init_gear_sets()
    --------------------------------------
    -- Special sets (required by rules)
    --------------------------------------

    sets.MaxHP = {
        head="Hjarrandi Helm",
        body="Hjarrandi Breastplate",
        hands="Nyame Gauntlets",
        legs="Carmine Cuisses +1",
        feet="Nyame Sollerets",
        neck="Unmoving Collar +1",
        waist="Eschan Stone",
        left_ear="Cryptic Earring",
        right_ear="Chevalier Earring +1",
        left_ring="Gelatinous Ring +1",
        right_ring="Regal Ring",
    }

    sets.Enmity = set_combine(sets.MaxHP, {
        head="Loess Barbuta +1", --~24
        feet="Chevalier's Sabatons", --5
        waist="Creed Baudrier", --5
        neck="Unmoving Collar +1", --10
        left_ear="Cryptic Earring", --4
        left_ring="Odium Ring", --4
    })

    sets.Kiting = { legs="Carmine Cuisses +1" }

    sets.Cursna = {
        neck="Nicander's Necklace",
        waist="Gishdubar Sash",
        left_ring="Blenmot's Ring",
    }

    sets.TreasureHunter = {
        ammo="Perfect Lucky Egg",
        head="White Rarab Cap +1",
        feet="Volte Boots",
        waist="Chaac Belt",
    }

    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA.Invincible = {
    }

    -- Fast cast sets for spells
    sets.precast.FC = {
        main="Sakpata's Sword", --10
        head="Carmine Mask +1", --14
        hands="Volte Gloves", --6
        left_ear="Loquacious Earring", -- 2
        right_ring="Kishar Ring", --4
        waist="Siegel Sash", -- 8 for enhancing
    }

    --------------------------------------
    -- Midcast sets
    --------------------------------------

    -- Cure sets
    sets.midcast.Cure = {
        
    }

    sets.midcast.Curaga = sets.midcast.Cure   
    sets.midcast.SelfCure = set_combine(sets.midcast.Cure, {
        waist="Gishdubar Sash",
        right_ear="Chevalier's Earring +1",
        left_ring="Vocane Ring",
    })

    --------------------------------------
    -- Idle / Resting sets
    --------------------------------------

    sets.idle = { 
        ammo="Homiliary",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Carmine Cuisses +1",
        feet="Nyame Sollerets",
        neck="Sibyl Scarf",
        waist="Gishdubar Sash",
        left_ear="Cryptic Earring",
        right_ear="Chevalier Earring +1",
        left_ring="Gelatinous Ring +1",
        right_ring="Vocane Ring",
    }

    --------------------------------------
    -- Combat sets
    --------------------------------------

    -- Normal melee group, max haste + DW + multiattack
    sets.engaged = {
        ammo="Coiste Bodhar",
        head="Nyame Helm",
        body="Flamma Korazin +2",
        hands="Flamma Manopolas +2",
        legs="Sulevia's Cuisses +2",
        feet="Flamma Gambieras +2",
        neck="Sibyl Scarf",
        waist="Sailfi Belt +1",
        left_ear="Cessance Earring",
        right_ear="Brutal Earring",
        left_ring="Flamma Ring",
        right_ring="Rajas Ring",
    }

    sets.engaged.Tank = {
        ammo="Coiste Bodhar",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Unmoving Collar +1",
        waist="Sailfi Belt +1",
        left_ear="Cryptic Earring",
        right_ear="Chevalier Earring +1",
        left_ring="Gelatinous Ring +1",
        right_ring="Vocane Ring",
    }

    --------------------------------------
    -- Weapon sets
    --------------------------------------

    sets.weapons.Sword = {
        main="Sakpata's Sword",
        sub="Duban",
    }

    sets.weapons.Savage = {
        main="Naegling",
        sub="Duban",
    }

    sets.weapons.Dagger = {
        main="Ternion Dagger +1",
        sub="Duban",
    }

    sets.weapons.DualSword = {
        main="Naegling",
        sub="Demersal Degen +1",
    }

    sets.weapons.Lance = {
        main="Shining One",
    }

    sets.weapons.Staff = {
        main="Malignance Pole",
    }

    --------------------------------------
    -- Weaponskill sets
    --------------------------------------

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo="Oshasha's Treatise",
        head="Blistering Sallet +1",
        body="Sulevia's Plate +2",
        hands="Sulevia's Gauntlets +2",
        legs="Sulevia's Cuisses +2",
        feet="Sulevia's Leggings +2",
        neck="Republic Platinum Medal",
        waist="Sailfi Belt +1",
        left_ear="Thrud Earring",
        right_ear="Moonshade Earring",
        left_ring="Regal Ring",
        right_ring="Beithir Ring",
    }

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        left_ring="Sroda Ring",
        right_ring="Metamorph Ring +1",
    })

    -- prefers DEX, crit rate, and fTP
    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {
        head="Blistering Sallet +1",
        body="Hjarrandi Breastplate",
        hands="Flamma Manopolas +2",
        neck="Fotia Gorget",
        waist="Fotia Belt",
    })

    -- Magical WS
    sets.precast.WS.ElementalWS = {
        ammo="Oshasha's Treatise",
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        waist="Eschan Stone",
        left_ear="Novio Earring",
        right_ear=gear.Moonshade,
        left_ring="Metamorph Ring +1",
        right_ring="Shiva Ring +1",
    }

    sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS.ElementalWS, {
        head="Pixie Hairpin +1",
        right_ring="Shiva Ring +1",
    })

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
        set_macro_page(1, 6)
    elseif player.sub_job == 'BLM' then
        set_macro_page(1, 6)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 6)
    else
        set_macro_page(1, 6)
    end
end