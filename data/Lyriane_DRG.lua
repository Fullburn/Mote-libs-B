-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 3
    
    -- Load and initialize the include file.
    include('Mote-Include-B.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    -- Mode definitions
    state.WeaponsMode:options('Lance', 'Sword', 'DualSword', 'None')
    state.OffenseMode:options('Normal', 'Acc')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.DefenseMode:options('Evasion', 'PDT')
    state.DefenseLevel:options('Off', 'On')

    -- Augmented gear definitions
    gear.Brigantia = {}
    gear.Brigantia.WSD = { name = "Brigantia's Mantle", augments = { 'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}
    gear.Brigantia.DA = { name = "Brigantia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',} }

    -- Healing Breath trigger info
    info.MageSubs = S{'WHM', 'BLM', 'RDM', 'BLU', 'SCH', 'GEO'}
    info.HybridSubs = S{'PLD', 'DRK', 'BRD', 'NIN', 'RUN'}

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
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Spirit Surge'] = {
        body="Pteroslaver Mail +1",
    }

    sets.precast.JA['Jump'] = {
        body="Vishap Mail +1",
    }

    sets.precast.JA['High Jump'] = set_combine(sets.precast.JA.Jump, {})
    sets.precast.JA['Spirit Jump'] = set_combine(sets.precast.JA.Jump, {})
    sets.precast.JA['Soul Jump'] = set_combine(sets.precast.JA.Jump, {})

    sets.precast.JA.Angon = {
        ammo="Angon",
        hands="Ptero. Fin. G. +1",
        right_ear="Dragoon's Earring",
    }

    sets.precast.JA['Call Wyvern'] = {
        body="Pteroslaver Mail +1",
    }

    sets.precast.JA['Spirit Link'] = {
        feet="Pteroslaver Greaves +1",
    }

    -- Fast cast sets for spells
    sets.precast.FC = {
        ear2="Loquacious Earring",
    }

    --------------------------------------
    -- Idle / Resting sets
    --------------------------------------

    sets.idle = { 
        ammo="Coiste Bodhar",
        head="Sulevia's Mask +2",
        body="Sulevia's Platemail +2",
        hands="Sulevia's Gauntlets +2",
        legs="Carmine Cuisses +1",
        feet="Sulevia's Leggings +2",
        neck="Sanctity Necklace",
        waist="Sailfi Belt +1",
        left_ear="Thrud Earring",
        right_ear="Brutal Earring",
        left_ring="Dreki Ring",
        right_ring="Rajas Ring",
        back=gear.Brigantia.DA,
    }

    --------------------------------------
    -- Combat sets
    --------------------------------------

    -- Normal melee group, max haste + DW + multiattack
    sets.engaged = {
        ammo="Coiste Bodhar",
        head="Flamma Zucchetto +2", --4%
        body="Flamma Korazin +2", --2%
        hands="Flamma Manopolas +2", --4%
        legs="Flamma Dirs +2", --4%
        feet="Flamma Gambieras +2", --2%
        neck="Sanctity Necklace",
        waist="Sailfi Belt +1", --9%
        left_ear="Thrud Earring",
        right_ear="Brutal Earring",
        left_ring="Dreki Ring",
        right_ring="Rajas Ring",
        back=gear.Brigantia.DA,
    }

    sets.engaged.Acc = set_combine(sets.engaged, {
        ammo="Ginsen"
    })

    --------------------------------------
    -- Weapon sets
    --------------------------------------

    sets.weapons.Lance = {
        main="Kaja Lance",
        sub="Pole Grip",
    }

    sets.weapons.Sword = {
        main="Naegling",
    }

    sets.weapons.DualSword = {
        main="Naegling",
        sub="Demersal Degen +1",
    }

    sets.weapons.Staff = {
        main="Malignance Pole",
        sub="Tokko Grip",
    }

    --------------------------------------
    -- Weaponskill sets
    --------------------------------------

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo="Knobkierrie",
        head="Sulevia's Mask +2",
        body="Sulevia's Platemail +2",
        hands="Sulevia's Gauntlets +2",
        legs="Sulevia's Cuisses +2",
        feet="Sulevia's Leggings +2",
        neck="Sanctity Necklace",
        waist="Sailfi Belt +1",
        left_ear="Thrud Earring",
        right_ear=gear.Moonshade,
        left_ring="Dreki Ring",
        right_ring="Rajas Ring",
        back=gear.Brigantia.WSD,
    }

    -- prefers DEX, crit rate, and fTP
    sets.precast.WS['Stardiver'] = set_combine(sets.precast.WS, {
        neck="Light Gorget",
        waist="Light Belt",
    })

    -- 183 MAB, INT, DEX
    sets.precast.WS['Drakesbane'] = set_combine(sets.precast.WS, {
        head="Blistering Sallet +1",
        neck="Light Gorget",
        waist="Light Belt",
    })

    --------------------------------------
    -- Special sets (required by rules)
    --------------------------------------

    -- breath sets!
    sets.midcast.BreathTrigger = {
        head="Vishap Armet +1",
    }

    sets.midcast.Pet['Healing Breath'] = {
        head="Pteroslaver Armet +1",
        legs="Flamma Dirs +2", --cure received 9%
    }

    sets.midcast.Pet['Elemental Breath'] = {
        head="Pteroslaver Armet +1",
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
        neck="Twilight Torque",
        left_ring="Vocane Ring",
        back=gear.Brigantia.DA,
    }
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general midcast() set is constructed.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if is_healing_breath_trigger(spell) then
        equip(sets.midcast.BreathTrigger)
    end
end

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

-- Function to check whether we are able to trigger healing breath on this cast.
function is_healing_breath_trigger(spell)
    if spell.action_type == 'Magic' then
        if info.MageSubs:contains(player.sub_job) then -- player.hpp <= 50 and 
            return true
        elseif player.hpp <= 33 then --and info.HybridSubs:contains(player.sub_job) then
            return true
        end
    end

    return false
end

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

    add_to_chat(122, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'SAM' then
        set_macro_page(1, 3)
    elseif player.sub_job == 'WAR' then
        set_macro_page(1, 3)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 3)
    else
        set_macro_page(1, 3)
    end
end