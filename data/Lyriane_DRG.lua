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
    state.WeaponsMode:options('Lance', 'Sword', 'DualSword', 'Staff', 'None')
    state.OffenseMode:options('Normal', 'PDL', 'Acc', 'Subtle')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'PDL', 'Acc')
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
        body="Pteroslaver Mail +3",
        feet="Pteroslaver Greaves +3",
    }

    sets.precast.JA['Jump'] = {
        body="Pteroslaver Mail +3",
        hands="Vishap Finger Gauntlets +1",
        feet="Vishap Greaves +2",
        neck="Dragoon's Collar +1",
        right_ring="Regal Ring",
    }

    sets.precast.JA['High Jump'] = set_combine(sets.precast.JA.Jump, {
        legs="Pteroslaver Brais +3",
    })

    sets.precast.JA['Spirit Jump'] = set_combine(sets.precast.JA.Jump, {
        legs="Peltast's Cuissots +2",
        feet="Peltast's Schynbalds +2",
    })
    
    sets.precast.JA['Soul Jump'] = set_combine(sets.precast.JA.Jump, {
        body="Vishap Mail +1",
        legs="Peltast's Cuissots +2",
    })

    sets.precast.JA.Angon = {
        ammo="Angon",
        hands="Ptero. Fin. G. +3",
        right_ear="Dragoon's Earring",
    }

    sets.precast.JA['Call Wyvern'] = {
        body="Pteroslaver Mail +3",
        legs="Vishap Brais +3",
        feet="Gleti's Boots",
        neck="Dragoon's Collar +1",
        left_ring="Dreki Ring",
    }

    sets.precast.JA['Spirit Link'] = {
        legs="Vishap Brais +3",
        feet="Pteroslaver Greaves +3",
    }

    sets.precast.JA['Steady Wing'] = {
        legs="Vishap Brais +3",
        feet="Pteroslaver Greaves +3",
    }

    -- Fast cast sets for spells
    sets.precast.FC = {
        ear2="Loquacious Earring",
    }

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, { neck="Magoraga Beads" })

    --------------------------------------
    -- Idle / Resting sets
    --------------------------------------

    sets.idle = { 
        head="Gleti's Mask",
        body="Gleti's Cuirass",
        hands="Gleti's Gauntlets",
        legs="Carmine Cuisses +1",
        feet="Gleti's Boots",
        neck="Dragoon's Collar +1",
        waist="Sailfi Belt +1",
        left_ear="Cessance Earring",
        right_ear="Brutal Earring",
        left_ring="Dreki Ring",
        right_ring="Rajas Ring",
        back=gear.Brigantia.DA,
    }

    --------------------------------------
    -- Combat sets
    --------------------------------------

    -- Normal melee group, max haste + multiattack + STP
    -- 26 haste, 10 TA, 19 DA, 34 STP
    sets.engaged = {
        ammo="Coiste Bodhar", -- DA 3 / STP 3
        head="Pteroslaver Armet +3", --7% / TA 4
        body="Peltast's Plackart +2",
        hands="Flamma Manopolas +2", --4% / STP 6
        legs="Sulevia's Cuisses +2", --2% / TA 4
        feet="Flamma Gambieras +2", --2% / DA 6 / STP 6
        neck="Shulmanu Collar", -- DA 3
        waist="Sailfi Belt +1", --9% / TA 2 / DA 5
        left_ear="Cessance Earring",
        right_ear="Brutal Earring", -- DA 5
        left_ring="Dreki Ring", -- STP 5
        right_ring="Rajas Ring", -- STP 5
        back=gear.Brigantia.DA,
    }

    sets.engaged.Acc = set_combine(sets.engaged, {
        ammo="Falcon Eye",
        body="Vishap Mail +3",
        right_ring="Regal Ring",
    })

    sets.engaged.Subtle = set_combine(sets.engaged, {
        head="Volte Tiara", --6
        body="Flamma Korazin +2", --17
        hands="Sulevia's Gauntlets +2",
        legs="Sulevia's Cuisses +2", -- set bonus
        feet="Volte Spats", --6
        right_ear="Peltast's Earring", --5
    })

    --------------------------------------
    -- Weapon sets
    --------------------------------------

    sets.weapons.Lance = {
        main="Shining One",
        sub="Utu Grip",
    }

    sets.weapons.Sword = {
        main="Naegling",
        sub="Twinned Shield",
    }

    sets.weapons.DualSword = {
        main="Naegling",
        sub="Demersal Degen +1",
    }

    sets.weapons.Staff = {
        main="Malignance Pole",
        sub="Utu Grip",
    }

    --------------------------------------
    -- Weaponskill sets
    --------------------------------------

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo="Knobkierrie",
        head="Peltast's Mezail +2",
        body="Hjarrandi Breastplate", -- with Shining One ONLY
        hands="Pteroslaver Finger Gauntlets +3",
        legs="Vishap Brais +3",
        feet="Sulevia's Leggings +2",
        neck="Dragoon's Collar +1",
        waist="Sailfi Belt +1",
        left_ear=gear.Moonshade,
        right_ear="Thrud Earring",
        left_ring="Beithir Ring",
        right_ring="Regal Ring",
        back=gear.Brigantia.WSD,
    }

    sets.precast.WS.PDL = set_combine(sets.precast.WS, {
        body="Gleti's Cuirass",
        right_ear="Peltast's Earring",
    })

    sets.precast.WS["Savage Blade"] = set_combine(sets.precast.WS, {
        body="Gleti's Cuirass",
    })

    sets.precast.WS["Camlann's Torment"] = set_combine(sets.precast.WS, {
        neck="Fotia Gorget",
        waist="Fotia Belt",
    })

    -- prefers STR and fTP
    sets.precast.WS.Stardiver = set_combine(sets.precast.WS, {
        head="Pteroslaver Armet +3",
        legs="Sulevia's Cuisses +2",
        neck="Fotia Gorget",
        waist="Fotia Belt",
    })

    -- prefers STR and crit rate; negative attack mul
    sets.precast.WS.Drakesbane = set_combine(sets.precast.WS, {
        head="Blistering Sallet +1",
        hands="Gleti's Gauntlets",
        legs="Peltast's Cuissots +2",
        feet="Gleti's Boots",
    })

    --------------------------------------
    -- Special sets (required by rules)
    --------------------------------------

    sets.Kiting = { legs="Carmine Cuisses +1" }

    sets.Cursna = {
        waist="Gishdubar Sash",
        left_ring="Blenmot's Ring",
    }

    -- breath sets!
    sets.midcast.BreathTrigger = {
        head="Vishap Armet +1",
        hands="Despair Finger Gauntlets",
        legs="Vishap Brais +3",
        feet="Pteroslaver Greaves +3",
    }

    sets.midcast.Pet['Healing Breath'] = {
        head="Pteroslaver Armet +3",
        hands="Despair Finger Gauntlets",
        legs="Vishap Brais +3",
        feet="Pteroslaver Greaves +3",
    }

    sets.midcast.Pet['Elemental Breath'] = {
        head="Pteroslaver Armet +3",
        body="Peltast's Plackart +2",
        hands="Gleti's Gauntlets",
        legs="Vishap Brais +3",
        feet="Gleti's Boots",
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
        left_ring="Vocane Ring",
        back=gear.Brigantia.DA,
    }
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

function job_precast(spell, action, spellMap, eventArgs)
    refine_jump(spell, action, spellMap, eventArgs)
end

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

-- Replace Jump with a Spirit Jump, or Soul Jump, if the others are on cooldown.
function refine_jump(spell, action, spellMap, eventArgs)
    if spell.name ~= "Jump" then
        return
    end

    local abil_recasts = windower.ffxi.get_ability_recasts()
    if (abil_recasts[spell.recast_id] > 0) then
        eventArgs.cancel = true

        -- ID 166 is Spirit Jump, 167 is Soul Jump.
        local newJump = nil
        if (abil_recasts[166] == 0) then
            newJump = "Spirit Jump"
        elseif (abil_recasts[167] == 0) then
            newJump = "Soul Jump"
        end
        
        if (newJump ~= nil) then
            send_command('@input /ja "'..newJump..'" '..tostring(spell.target.raw))
        else
            add_to_chat(123,'Abort: Ability waiting on recast.')
        end
    end
end

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
    if player.sub_job == 'SAM' then
        set_macro_page(1, 3)
    elseif player.sub_job == 'WAR' then
        set_macro_page(1, 3)
    elseif player.sub_job == 'NIN' then
        set_macro_page(3, 3)
    elseif player.sub_job == 'BLU' then
        set_macro_page(2, 3)
    else
        set_macro_page(1, 3)
    end
end