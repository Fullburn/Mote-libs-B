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
    include('Mote-TreasureHunter')

    state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
    state.Buff['Trick Attack'] = buffactive['trick attack'] or false
    state.Buff['Feint'] = buffactive['feint'] or false
    state.Buff['Conspirator'] = buffactive['conspirator'] or false

    -- For th_action_check():
    -- JA IDs for actions that always have TH: Provoke, Animated Flourish
    info.default_ja_ids = S{35, 204}
    -- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
    info.default_u_ja_ids = S{201, 202, 203, 205, 207}

    -- Mode definitions
    state.WeaponsMode:options('Dagger', 'Boomerang', 'Acid', 'Sword', 'TH', 'None')
    state.OffenseMode:options('Normal', 'Acc', 'Subtle')
    state.DefenseMode:options('Hybrid', 'None')
    state.DefenseLevel:options('Off', 'On')

    -- Augmented gear definitions
    gear.Toutatis = {}
    gear.Toutatis.DW = { name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dual Wield"+10','Phys. dmg. taken-10%',}}
    gear.Toutatis.WSD = { name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}}

    -- Additional local binds    
    send_command('bind f11 gs c cycle treasuremode')

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
    sets.precast.JA['Collaborator'] = { head="Skulker's Bonnet +2"}
    sets.precast.JA['Accomplice'] = { head="Skulker's Bonnet +2"}
    sets.precast.JA['Flee'] = { feet="Pillager's Poulaines +1" }
    sets.precast.JA['Hide'] = { body="Pillager's Vest +3"}
    sets.precast.JA['Conspirator'] = { body="Skulker's Vest +2" }
    sets.precast.JA['Steal'] = { head="Plunderer's Bonnet", hands="Pillager's Armlets +1", legs="Pillager's Culottes +3", feet="Pillager's Poulaines +1" }
    sets.precast.JA['Despoil'] = { legs="Skulker's Culottes +2", feet="Skulker's Poulaines +2"}
    sets.precast.JA['Perfect Dodge'] = { hands="Plunderer's Armlets +1"}
    sets.precast.JA['Feint'] = { legs="Plunderer's Culottes +1" }

    sets.precast.JA['Sneak Attack'] = {
        hands="Skulker's Armlets +2",
    }

    sets.precast.JA['Trick Attack'] = {
        hands="Pillager's Armlets +1",
    }

    -- Fast cast sets for spells
    sets.precast.FC = {
        ear2="Loquacious Earring",
    }

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, { neck="Magoraga Beads" })

    -- Ranged snapshot gear
    sets.precast.RA = {
    }   

    -- Waltz set (potency, chr and vit)
    sets.precast.Waltz = {
        head="Mummu Bonnet +2",
        body="Gleti's Cuirass",
    }

    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

    
    -- Actions we want to use to tag TH.
    sets.precast.Step = sets.TreasureHunter
    sets.precast.Flourish1 = sets.TreasureHunter
    sets.precast.JA.Provoke = sets.TreasureHunter

    --------------------------------------
    -- Idle / Resting sets
    --------------------------------------

    sets.idle = { 
        head="Gleti's Mask",
        body="Mekosuchinae harness",
        --body="Gleti's Cuirass",
        hands="Gleti's Gauntlets",
        legs="Gleti's Breeches",
        feet="Skadi's Jambeaux +1",
        neck="Sanctity Necklace",
        waist="Sailfi Belt +1",
        left_ear="Cessance Earring",
        right_ear="Brutal Earring",
        left_ring="Epona's Ring",
        right_ring="Vocane Ring",
        back=gear.Toutatis.DW,
    }

    --------------------------------------
    -- Combat sets
    --------------------------------------

    -- Normal melee group, max haste + DW + multiattack + stp
    sets.engaged = {
        ammo="Coiste Bodhar",
        head="Skulker's Bonnet +2", --8%
        body="Plunderer's Vest +3", --4%
        hands=gear.AdhemarWrists.Attack, --5%
        legs="Samnuha Tights", -- 6%, 3 DA 3 TA 7 STP
        feet="Plunderer's Poulaines +3", --4%
        neck="Anu Torque",
        waist="Sailfi Belt +1", --9%
        left_ear="Suppanomimi",
        right_ear="Skulker's Earring",
        left_ring="Epona's Ring",
        right_ring="Ilabrat Ring",
        back=gear.Toutatis.DW,
    }

    sets.engaged.Acc = set_combine(sets.engaged, {
        legs="Pillager's Culottes +3",
    })

    sets.engaged.DW = set_combine(sets.engaged, {
        body=gear.AdhemarJacket.Attack,
    })

    sets.engaged.Subtle = set_combine(sets.engaged, {
        head="Volte Tiara", --6
        feet="Mummu Gamash. +2", --9
        right_ring="Rajas Ring", --5
    })

    --------------------------------------
    -- Weapon sets
    --------------------------------------

    sets.weapons.Dagger = {
        main="Tauret",
        sub="Gleti's Knife",
    }

    sets.weapons.Boomerang = {
        main="Tauret",
        sub="Gleti's Knife",
        range="Raider's Bmrng.",
        ammo="", -- Force the slot clear
    }

    sets.weapons.Acid = {
        main="Tauret",
        sub="Gleti's Knife",
        range="Exalted Crossbow",
        ammo="Acid Bolt",
    }

    sets.weapons.Sword = {
        main="Naegling",
        sub="Gleti's Knife",
    }

    sets.weapons.TH = {
        main="Tauret",
        sub="Gleti's Knife",
        ammo="Perfect Lucky Egg",
    }

    --------------------------------------
    -- Weaponskill sets
    --------------------------------------

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo="Oshasha's Treatise",
        head="Pillager's Bonnet +3",
        body="Skulker's Vest +2",
        hands=gear.AdhemarWrists.Attack,
        legs="Pillager's Culottes +3",
        feet="Plunderer's Poulaines +3",
        neck="Republican Platinum Medal",
        waist="Sailfi Belt +1",
        left_ear=gear.Moonshade,
        right_ear="Skulker's Earring",
        left_ring="Ilabrat Ring",
        right_ring="Regal Ring",
        back=gear.Toutatis.WSD,
    }

    sets.precast.WS.SA = set_combine(sets.precast.WS, sets.precast.JA['Sneak Attack'])
    sets.precast.WS.TA = set_combine(sets.precast.WS, sets.precast.JA['Trick Attack'])

    sets.precast.WS.SATA = set_combine(sets.precast.WS.SA, {
        hands="Pillager's Armlets +1",
    })

    sets.precast.WS['Savage Blade'] = set_combine(sets.precast.WS, {
        left_ring="Sroda Ring",
    })

    -- sets.precast.WS['Mandalic Stab'] = set_combine(sets.precast.WS, {
    --     feet="Gleti's Boots",
    -- })

    -- prefers DEX, crit rate, and fTP
    sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
        body="Plunderer's Vest +3",
        legs="Pillager's Culottes +3",
        feet="Gleti's Boots",
        neck="Fotia Gorget",
        waist="Fotia Belt",
    })

    -- 183 MAB, INT, DEX
    sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
        head="Nyame Helm",
        body="Nyame Mail",
        hands="Nyame Gauntlets",
        legs="Nyame Flanchard",
        feet="Nyame Sollerets",
        neck="Sibyl Scarf",
        left_ear="Hecate's Earring",
        right_ear="Novio Earring",
        left_ring="Metamorph Ring +1",
        right_ring="Shiva Ring +1",
        waist="Eschan Stone",
        back=gear.Toutatis.WSD,
    })

    --------------------------------------
    -- Special sets (required by rules)
    --------------------------------------

    sets.TreasureHunter = {
        hands="Plunderer's Armlets +1", 
        feet="Skulker's Poulaines +2",
        waist="Chaac Belt",
    }

    sets.Kiting = { feet="Skadi's Jambeaux +1" }

    sets.Cursna = {
        neck="Nicander's Necklace",
        waist="Gishdubar Sash",
        left_ring="Blenmot's Ring",
    }

    -- buffactive sets for custom logic
    sets.custom = {}
    sets.custom.SA = sets.precast.JA['Sneak Attack']
    sets.custom.TA = sets.precast.JA['Trick Attack']
    sets.custom.SATA = set_combine(sets.custom.SA, sets.custom.TA)

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
        back=gear.Toutatis.DW, --10%
    }
    
    sets.defense.Hybrid = set_combine(sets.defense, {
        head="Malignance Chapeau",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
    })

end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
    if state.TreasureMode.value ~= 'None' and (spell.english == 'Aeolian Edge' or spell.english == 'Cyclone') then
        equip(sets.TreasureHunter)
    elseif state.TreasureMode.value == 'SATA' and (spell.english=='Sneak Attack' or spell.english=='Trick Attack') then
        equip(sets.TreasureHunter)
    end
end

-- Run after the general midcast() set is constructed.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if state.TreasureMode.value ~= 'None' and (spell.action_type == 'Ranged Attack' or spell.action_type == "Magic") then
        TH_for_first_hit(true)
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Weaponskills wipe SATA/Feint.  Turn those state vars off before default gearing is attempted.
    if spell.type == 'WeaponSkill' and not spell.interrupted then
        state.Buff['Sneak Attack'] = false
        state.Buff['Trick Attack'] = false
        state.Buff['Feint'] = false
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if not midaction() then
        handle_equipping_gear(player.status)
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function customize_melee_set(meleeSet)
    if state.Buff['Conspirator'] then
        meleeSet = set_combine(meleeSet, sets.precast.JA['Conspirator'])
    end

    local sata = get_sata_map()
    if sata ~= '' then
        meleeSet = set_combine(meleeSet, sets.custom[sata])

        if state.TreasureMode.value == 'SATA' then
            meleeSet = set_combine(meleeSet, sets.TreasureHunter)
        end
    end

    if state.TreasureMode.value == 'Fulltime' then
        meleeSet = set_combine(meleeSet, sets.TreasureHunter)
    end
    
    return meleeSet
end

function get_custom_wsmode(spell, spellMap, defaut_wsmode)
    return get_sata_map()
end

function customize_idle_set(idleSet)
    if player.hpp < 80 then
        idleSet = set_combine(idleSet, sets.ExtraRegen)
    end

    return idleSet
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    th_update(cmdParams, eventArgs)
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
    
    msg = msg .. ', TH: ' .. state.TreasureMode.value

    add_to_chat(122, msg)

    eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Gets the subset name for SA/TA/SATA by current buff state.
function get_sata_map()
    local sata = ''

    if state.Buff['Sneak Attack'] then
        sata = 'SA'
    end
    if state.Buff['Trick Attack'] then
        sata = sata .. 'TA'
    end

    return sata
end

-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
    if category == 2 or -- any ranged attack
        --category == 4 or -- any magic action
        (category == 3 and param == 30) or -- Aeolian Edge
        (category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
        (category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
        then return true
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(1, 4)
    elseif player.sub_job == 'WAR' then
        set_macro_page(1, 4)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 4)
    else
        set_macro_page(1, 4)
    end
end