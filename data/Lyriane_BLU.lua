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

    state.Buff['Chain Affinity'] = buffactive['chain affinity'] or false
    state.Buff['Burst Affinity'] = buffactive['burst affinity'] or false
    state.Buff['Efflux'] = buffactive['efflux'] or false
    state.Buff['Diffusion'] = buffactive['efflux'] or false

    -- Mode definitions
    state.WeaponsMode:options('Sword', 'Club', 'Nuke', 'Tank', 'None')
    state.OffenseMode:options('Normal', 'Acc', 'Subtle')
    state.RangedMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.DefenseMode:options('Hybrid', 'None')
    state.CastingMode:options('Normal', 'Acc1', 'Potency')

    -- Augmented gear definitions
    gear.Rosmerta = {}
    gear.Rosmerta.WSD = { name = "Rosmerta's Cape", augments = { 'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%',}}
    gear.Rosmerta.DA = { name = "Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}
    gear.Rosmerta.MAB = { name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}}
    gear.Rosmerta.Eva = { name="Rosmerta's Cape", augments={'AGI+20'}}-- Eva +45, MEva +20, FC +10%, (Counter +10 instead of 15 eva?)

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
--[[
TODO gearsets!
Fast Cast: 
    Amalric Coif +1   -- 16m also gives Refresh Potency!!!
    Rosmerta's

Defense mode full tank:
    Rosmerta's

Subtle Blow:
    Bathy Choker +1
    Expeditious Pinion
    Adhemar Bonnet +1

Cursna received set:

General:
    Stikini +1 (x1)
    Mirage Stole +2
    Pixie Hairpin +1
    Hachirin no Obi
    Aurist's Cape +1
--]]

    --------------------------------------
    -- Idle / Resting sets
    --------------------------------------

    sets.idle = { 
        head="Gleti's Mask",
        body="Hashishin Mintan +2",
        hands="Gleti's Gauntlets",
        legs="Carmine Cuisses +1",
        feet="Gleti's Boots",
        neck="Sibyl Scarf",
        waist="Sailfi Belt +1",
        left_ear="Brutal Earring",
        right_ear="Suppanomimi",
        left_ring="Epona's Ring",
        right_ring="Rajas Ring",
        back=gear.Rosmerta.DA,
    }

    sets.TreasureHunter = {
        head="White Rarab Cap +1",
        ammo="Perfect Lucky Egg", 
    }

    --------------------------------------
    -- Combat sets
    --------------------------------------

    -- Normal melee group, max haste + DW + multiattack + crit + attack
    sets.engaged = {
        ammo="Coiste Bodhar",
        head="Malignance Chapeau", --6%
        --head="Blistering Sallet +1", --8%
        body=gear.AdhemarJacket.Attack, --4%
        hands=gear.AdhemarWrists.Attack, --5%
        legs="Samnuha Tights", --6% / STP 7, DA 3, TA 3
        feet="Malignance Boots", --3%
        neck="Republican Platinum Medal",
        waist="Sailfi Belt +1", --9%
        left_ear="Cessance Earring",
        right_ear="Suppanomimi",
        left_ring="Epona's Ring",
        right_ring="Ilabrat Ring",
        back=gear.Rosmerta.DA,
    }

    sets.engaged.Acc1 = set_combine(sets.engaged, {
        head="Hashishin Kavuk +2",
        body="Ayanmo Corazza +2", 
    })

    sets.engaged.Acc2 = set_combine(sets.engaged.Acc1, {
        ammo="Falcon Eye",
    })

    sets.engaged.Acc3 = set_combine(sets.engaged.Acc2, {
        hands="Hashishin Bazubands +2",
    })

    sets.engaged.Subtle = set_combine(sets.engaged, {
        head="Volte Tiara", --6
        hands="Luhlaza Bazubands +1", --9
        right_ring="Rajas Ring", --5
        feet="Volte Spats" --9
    })

    --------------------------------------
    -- Weapon sets
    --------------------------------------

    sets.weapons.Sword = {
        main="Naegling",
        sub="Thibron",
    }

    sets.weapons.Club = {
        main="Kaja Rod",
        sub="Daybreak",
    }

    sets.weapons.Nuke = {
        main="Naegling",
        sub="Sakpata's Sword",
    }

    sets.weapons.Tank = {
        main="Sakpata's Sword",
        sub="Culminus",
    }

    --------------------------------------
    -- Weaponskill sets
    --------------------------------------

    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        ammo="Oshasha's Treatise",
        head="Hashishin Kavuk +2",
        body="Assim. Jubbah +3",
        hands="Jhakri Cuffs +2",
        legs="Luhlaza Shalwar +3",
        feet="Luhlaza Charuqs +2",
        neck="Republican Platinum Medal",
        waist="Sailfi Belt +1",
        left_ear="Brutal Earring",
        right_ear=gear.Moonshade,
        left_ring="Epona's Ring",
        right_ring="Beithir Ring",
        back=gear.Rosmerta.WSD,
    }

    -- prefers DEX, crit rate, and fTP
    sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, {
        head="Blistering Sallet +1",
        hands=gear.AdhemarWrists.Attack,
        feet="Ayanmo Gambieras +2",
        neck="Fotia Gorget",
        waist="Fotia Belt",
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
        neck="Unmoving Collar +1",
        right_ring="Vocane Ring",
        back=gear.Rosmerta.DA
    }

    sets.defense.Hybrid = set_combine(sets.defense, {
        head="Malignance Chapeau",
        hands="Malignance Gloves",
        legs="Malignance Tights",
        feet="Malignance Boots",
    })

    --------------------------------------
    -- Precast sets
    --------------------------------------

    -- Precast sets to enhance JAs
    sets.precast.JA['Azure Lore'] = { }

    -- Fast cast sets for spells - 15 from Erratic Flutter + JP gifts, 10 from Sakpata's
    sets.precast.FC = {
        body="Hashishin Mintan +2", -- 15
        hands="Hashishin Bazubands +2", -- (recast bonus if not replaced midcast)
        legs="Ayanmo Cosciales +2", -- 6
        feet="Herculean Boots", -- 7
        right_ring="Kishar Ring", -- 4
        right_ear="Loquacious Earring", -- 2
    }

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, { neck="Magoraga Beads" })

    --------------------------------------
    -- Midcast sets
    --------------------------------------

    sets.buff.ChainAffinity = {
        head="Hashishin Kavuk +2",
        feet="Assimilator's Charuqs +2",
    }

    sets.buff.Efflux = {
        legs="Hashishin Tayt +2",
    }

    sets.buff.BurstAffinity = {
        feet="Hashishin Basmak +2",
    }

    sets.buff.Diffusion = {
        feet="Luhlaza Charuqs +2",
    }

    sets.midcast.Blue_Physical_STR = set_combine(sets.precast.WS, {
        hands="Hashishin Bazubands +2",
        --ring/ear needed
    })

    sets.midcast.Blue_Physical_DEX = sets.midcast.Blue_Physical_STR
    sets.midcast.Blue_Physical_VIT = set_combine(sets.midcast.Blue_Physical_STR, sets.defense)
    sets.midcast.Blue_Physical_AGI = sets.midcast.Blue_Physical_STR
    sets.midcast.Blue_Physical_Other = sets.midcast.Blue_Physical_STR

    sets.midcast.Blue_Stun = {
        --ammo = "Pemphredo Tathlum",
        head="Hashishin Kavuk +2",
        body="Luhlaza Jubbah +3",
        hands="Hashishin Bazubands +2",
        legs="Hashishin Tayt +2",
        feet="Luhlaza Charuqs +2",
        neck="Sanctity Necklace",
        waist="Acuity Belt +1",
        left_ear = "Hermetic Earring",
        left_ring="Metamorph Ring +1",
        back=gear.Rosmerta.MAB,
    }

    sets.midcast.Blue_Magical_INTMAB = {
        ammo="Ghastly Tathlum +1",
        head="Hashishin Kavuk +2",
        body="Hashishin Mintan +2",
        hands="Hashishin Bazubands +2",
        legs="Hashishin Tayt +2",
        feet="Hashishin Basmak +2",
        neck="Sibyl Scarf",
        waist="Acuity Belt +1",
        left_ear="Hecate's Earring",
        right_ear="Novio Earring",
        left_ring="Metamorph Ring +1",
        right_ring="Shiva Ring +1",
        back=gear.Rosmerta.MAB,
    }

    sets.midcast.Blue_Magical_MACC = set_combine(sets.midcast.Blue_Magical_INTMAB, {
        neck="Erra Pendant",
        left_ear="Hermetic Earring",
    })

    sets.midcast.Blue_Magical_Light = sets.midcast.Blue_Magical_INTMAB
    sets.midcast.Blue_Magical_Dark = set_combine(sets.midcast.Blue_Magical_INTMAB, {
        head="Pixie Hairpin +1",
        neck="Erra Pendant",
    })

    sets.midcast.Blue_Magical_Earth = sets.midcast.Blue_Magical_INTMAB
    sets.midcast.Blue_Magical_Other = sets.midcast.Blue_Magical_INTMAB

    sets.midcast.Blue_Cure = {
        main="Daybreak",
        head="Hashishin Kavuk +2",
        body="Ayanmo Corazza +2",
        hands="Weath. Cuffs +1",
        legs="Hashishin Tayt +2",
        feet="Hashishin Basmak +2",
        left_ear="Influx Earring",
        left_ring="Metamorph Ring +1",
        right_ring="Naji's Loop",
    }

    sets.midcast.Blue_SelfCure = set_combine(sets.midcast.Blue_Cure, { left_ring="Vocane Ring" })
    sets.midcast.Cure = set_combine(sets.midcast.Blue_Cure, {})

    sets.midcast.Blue_Skill = {
        ammo="Mavi Tathlum",
        head="Luhlaza Keffiyeh +2",
        body="Assim. Jubbah +3",
        legs="Hashishin Tayt +2",
        feet="Luhlaza Charuqs +2",
    }

    sets.midcast.Occultation = set_combine(sets.midcast.Blue_Skill, {
        hands="Hashishin Bazubands +2",
    })

    -- Sanguine needs to inherit magical set
    sets.precast.WS.ELementalWS = set_combine(sets.midcast.Blue_Magical_INTMAB, {
        hands="Jhakri Cuffs +2",
        legs="Luhlaza Shalwar +3",
    })

    sets.precast.WS['Sanguine Blade'] = set_combine(sets.precast.WS.ELementalWS, {
        head="Pixie Hairpin +1",
        waist="Eschan Stone",
    })
    
    --------------------------------------
    -- Special sets (required by rules)
    --------------------------------------

    sets.Kiting = { legs="Carmine Cuisses +1" }

    sets.Cursna = {
        waist="Gishdubar Sash",
        left_ring="Blenmot's Ring",
    }
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- -- Run after the general precast() is done.
-- function job_post_precast(spell, action, spellMap, eventArgs)
-- end

-- Run after the general midcast() set is constructed.
-- Overwrites pieces for specific JA that buff spells.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spell.type == 'BlueMagic' then
        if state.Buff['Diffusion'] then
            equip(sets.buff.Diffusion)
        elseif state.Buff['Burst Affinity'] then
            equip(sets.buff.BurstAffinity)
        else
            if state.Buff['Chain Affinity'] then
                equip(sets.buff.ChainAffinity)
            end

            if state.Buff['Efflux'] then
                equip(sets.buff.Efflux)
            end
        end
    end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
    -- Attack spells wipe Chain/Burst//Efflux.  Turn those state vars off before default gearing is attempted.
    if spell.type == 'BlueMagic' and not spell.interrupted then
        state.Buff['Chain Affinity'] = false
        state.Buff['Burst Affinity'] = false
        state.Buff['Efflux'] = false
        state.Buff['Diffusion'] = false
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

-- Custom spell mapping, for when more than just the spell name matters (targets, buffs, etc.)
function job_get_spell_map(spell, default_spell_map)
    if default_spell_map == 'Blue_Cure' and spell.target.type == 'SELF' then
        return 'Blue_SelfCure'
    end
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


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'WAR' then
        set_macro_page(1, 5)
    elseif player.sub_job == 'NIN' then
        set_macro_page(1, 5)
    else
        set_macro_page(1, 5)
    end
end