-------------------------------------------------------------------------------------------------------------------
-- Common variables and functions to be included in job scripts, for general default handling.
--
-- Include this file in the get_sets() function with the command:
-- include('Mote-Include.lua')
--
-- It will then automatically run its own init_include() function.
--
-- IMPORTANT: This include requires supporting include files:
-- Mote-Utility
-- Mote-Mappings
-- Mote-SelfCommands
-- Mote-Globals
--
-- Place the include() directive at the start of a job's get_sets() function.
--
-- Included variables and functions are considered to be at the same scope level as
-- the job script itself, and can be used as such.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- Initialization function that defines variables to be used.
-- These are accessible at the including job lua script's scope.
--
-- Auto-initialize after defining this function.
-------------------------------------------------------------------------------------------------------------------

current_mote_include_version = 3

function init_include()
    -- Modes is the include for a mode-tracking variable class.  Used for state vars, below.
    include('Modes')

    -- Used to define misc utility functions that may be useful for this include or any job files.
    include('Mote-Utility-B')

    -- Used to define various types of data mappings.  These may be used in the initialization, so load it up front.
    include('Mote-Mappings-B')

    -- Var for tracking state values
    state = {}

    -- General melee offense/defense modes, as well as idle/resting/weaponskill.
    -- This just defines the vars and sets the descriptions.  List modes with no values automatically
    -- get assigned a 'Normal' default value.
    state.WeaponsMode         = M{['description'] = 'Weapons Mode'}
    state.OffenseMode         = M{['description'] = 'Offense Mode'}
    state.RangedMode          = M{['description'] = 'Ranged Mode'}
    state.WeaponskillMode     = M{['description'] = 'Weaponskill Mode'}
    state.CastingMode         = M{['description'] = 'Casting Mode'}
    state.IdleMode            = M{['description'] = 'Idle Mode'}
    state.RestingMode         = M{['description'] = 'Resting Mode'}

    -- New Defense cycling mechanism
    -- Off: unused. On: Engaged or idle. Pluscasting: engaged, idle, or midcast
    state.DefenseLevel        = M{['description'] = 'Defense Level', 'Off', 'EngagedOnly', 'On', 'PlusCasting', 'Fulltime'}
    state.DefenseMode         = M{['description'] = 'Defense Mode', 'Physical', 'Magical'}

    state.Kiting              = M(false, 'Kiting')
    state.SelectNPCTargets    = M(false, 'Select NPC Targets')
    state.PCTargetMode        = M{['description'] = 'PC Target Mode', 'default', 'stpt', 'stal', 'stpc'}

    state.EquipStop           = M{['description'] = 'Stop Equipping Gear', 'off', 'precast', 'midcast', 'pet_midcast'}

    state.CombatForm          = M{['description']='Combat Form', ['string']=''}

    -- Non-mode vars that are used for state tracking.
    state.Buff = {}

    -- Classes describe a 'type' of action.  They are similar to state, but
    -- may have any free-form value, or describe an entire table of mapped values.
    classes = {}
    -- Basic spell mappings are based on common spell series.
    -- EG: 'Cure' for Cure, Cure II, Cure III, Cure IV, Cure V, or Cure VI.
    classes.SpellMaps = invert_mapping_table(spell_maps)
    -- List of spells and spell maps that don't benefit from greater skill (though
    -- they may benefit from spell-specific augments, such as improved regen or refresh).
    -- Spells that fall under this category will be skipped when searching for
    -- spell.skill sets.
    classes.NoSkillSpells = no_skill_spells_list
    classes.SkipSkillCheck = false
    -- Custom, job-defined class, like the generic spell mappings.
    -- Takes precedence over default spell maps.
    -- Is reset at the end of each spell casting cycle (ie: at the end of aftercast).
    classes.JAMode = nil
    classes.CustomClass = nil
    -- Custom groups used for defining melee and idle sets.  Persists long-term.
    classes.CustomMeleeGroups = L{}
    classes.CustomRangedGroups = L{}
    classes.CustomIdleGroups = L{}
    classes.CustomDefenseGroups = L{}

    -- Class variables for time-based flags
    classes.Daytime = false
    classes.DuskToDawn = false

    -- Var for tracking misc info
    info = {}
    options = {}

    -- Special control flags.
    mote_vars = {}
    mote_vars.set_breadcrumbs = L{}
    mote_vars.res_buffs = S{}
    for index,struct in pairs(gearswap.res.buffs) do
        mote_vars.res_buffs:add(struct.en)
    end

    -- Sub-tables within the sets table that we expect to exist, and are annoying to have to
    -- define within each individual job file.  We can define them here to make sure we don't
    -- have to check for existence.  The job file should be including this before defining
    -- any sets, so any changes it makes will override these anyway.
    sets.precast = {}
    sets.precast.FC = {}
    sets.precast.JA = {}
    sets.precast.WS = {}
    sets.precast.RA = {}
    sets.midcast = {}
    sets.midcast.RA = {}
    sets.midcast.Pet = {}
    sets.idle = {}
    sets.resting = {}
    sets.weapons = {}
    sets.engaged = {}
    sets.defense = {}
    sets.buff = {}

    gear = {}
    gear.default = {}

    gear.ElementalGorget = {name=""}
    gear.ElementalBelt = {name=""}
    gear.ElementalObi = {name=""}
    gear.ElementalCape = {name=""}
    gear.ElementalRing = {name=""}
    gear.FastcastStaff = {name=""}
    gear.RecastStaff = {name=""}


    -- Load externally-defined information (info that we don't want to change every time this file is updated).

    -- Used for all self-command handling.
    include('Mote-SelfCommands-B')

    -- Include general user globals, such as custom binds or gear tables.
    -- Load Mote-Globals first, followed by User-Globals, followed by <character>-Globals.
    -- Any functions re-defined in the later includes will overwrite the earlier versions.
    include('Mote-Globals-B')
    optional_include({'user-globals.lua'})
    optional_include({player.name..'-globals.lua'})

    -- *-globals.lua may define additional sets to be added to the local ones.
    if define_global_sets then
        define_global_sets()
    end

    -- Global default binds (either from Mote-Globals or user-globals)
    (binds_on_load or global_on_load)()

    -- Load a sidecar file for the job (if it exists) that may re-define init_gear_sets and file_unload.
    load_sidecar(player.main_job)

    -- General var initialization and setup.
    if job_setup then
        job_setup()
    end

    -- User-specific var initialization and setup.
    if user_setup then
        user_setup()
    end

    -- Load up all the gear sets.
    init_gear_sets()
end

if not mote_include_version or mote_include_version < current_mote_include_version then
    add_to_chat(123,'Warning: Your job file is out of date.  Please update to the latest repository baseline.')
    add_to_chat(123,'For details, visit https://github.com/Kinematics/GearSwap-Jobs/wiki/Upgrading')
    rev = mote_include_version or 1
    include_path('rev' .. tostring(rev))
    include('Mote-Include-B')
    return
end

-- Auto-initialize the include
init_include()

-- Called when this job file is unloaded (eg: job change)
-- Conditional definition so that it doesn't overwrite explicit user
-- versions of this function.
if not file_unload then
    file_unload = function()
        if user_unload then
            user_unload()
        elseif job_file_unload then
            job_file_unload()
        end
        _G[(binds_on_unload and 'binds_on_unload') or 'global_on_unload']()
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Generalized functions for handling precast/midcast/aftercast for player-initiated actions.
-- This depends on proper set naming.
-- Global hooks can be written as user_xxx() to override functions at a global level.
-- Each job can override any of these general functions using job_xxx() hooks.
-------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------
-- Generic function to map a set processing order to all action events.
------------------------------------------------------------------------


-- Process actions in a specific order of events:
-- Filter  - filter_xxx() functions determine whether to run any of the code for this action.
-- Global  - user_xxx() functions get called first.  Define in Mote-Globals or User-Globals.
-- Local   - job_xxx() functions get called next. Define in JOB.lua file.
-- Default - default_xxx() functions get called next. Defined in this file.
-- Cleanup - cleanup_xxx() functions always get called before exiting.
--
-- Parameters:
-- spell - standard spell table passed in by GearSwap
-- action - string defining the function mapping to use (precast, midcast, etc)
function handle_actions(spell, action)
    -- Init an eventArgs that allows cancelling.
    local eventArgs = {handled = false, cancel = false}
    
    mote_vars.set_breadcrumbs:clear()

    -- Get the spell mapping, since we'll be passing it to various functions and checks.
    local spellMap = get_spell_map(spell)

    -- General filter checks to see whether this function should be run.
    -- If eventArgs.cancel is set, cancels this function, not the spell.
    if _G['filter_'..action] then
        _G['filter_'..action](spell, spellMap, eventArgs)
    end

    -- If filter didn't cancel it, process user and default actions.
    if not eventArgs.cancel then
        -- Global user handling of this action
        if _G['user_'..action] then
            _G['user_'..action](spell, action, spellMap, eventArgs)
            
            if eventArgs.cancel then
                cancel_spell()
            end
        end
        
        -- Job-specific handling of this action
        if not eventArgs.cancel and not eventArgs.handled and _G['job_'..action] then
            _G['job_'..action](spell, action, spellMap, eventArgs)
            
            if eventArgs.cancel then
                cancel_spell()
            end
        end
    
        -- Default handling of this action
        if not eventArgs.cancel and not eventArgs.handled and _G['default_'..action] then
            _G['default_'..action](spell, spellMap)
            display_breadcrumbs(spell, spellMap, action)
        end
        
        -- Global post-handling of this action
        if not eventArgs.cancel and _G['user_post_'..action] then
            _G['user_post_'..action](spell, action, spellMap, eventArgs)
        end

        -- Job-specific post-handling of this action
        if not eventArgs.cancel and _G['job_post_'..action] then
            _G['job_post_'..action](spell, action, spellMap, eventArgs)
        end
    end

    -- Cleanup once this action is done
    if _G['cleanup_'..action] then
        _G['cleanup_'..action](spell, spellMap, eventArgs)
    end
end


--------------------------------------
-- Action hooks called by GearSwap.
--------------------------------------

function pretarget(spell)
    handle_actions(spell, 'pretarget')
end

function precast(spell)
    if state.Buff[spell.english] ~= nil then
        state.Buff[spell.english] = true
    end
    
    handle_actions(spell, 'precast')
end

function midcast(spell)
    handle_actions(spell, 'midcast')
end

function aftercast(spell)
    if state.Buff[spell.english] ~= nil then
        state.Buff[spell.english] = not spell.interrupted or buffactive[spell.english]
    end

    handle_actions(spell, 'aftercast')
end

function pet_midcast(spell)
    handle_actions(spell, 'pet_midcast')
end

function pet_aftercast(spell)
    handle_actions(spell, 'pet_aftercast')
end

--------------------------------------
-- Default code for each action.
--------------------------------------

function default_pretarget(spell, spellMap)
    auto_change_target(spell, spellMap)
end

function default_precast(spell, spellMap)
    equip(get_precast_set(spell, spellMap))
end

function default_midcast(spell, spellMap)
    equip(get_midcast_set(spell, spellMap))
end

function default_aftercast(spell, spellMap)
    if not pet_midaction() then
        handle_equipping_gear(player.status)
    end
end

function default_pet_midcast(spell, spellMap)
    equip(get_pet_midcast_set(spell, spellMap))
end

function default_pet_aftercast(spell, spellMap)
    handle_equipping_gear(player.status)
end

--------------------------------------
-- Filters for each action.
-- Set eventArgs.cancel to true to stop further processing.
-- May show notification messages, but should not do any processing here.
--------------------------------------

function filter_midcast(spell, spellMap, eventArgs)
    if state.EquipStop.value == 'precast' then
        eventArgs.cancel = true
    end
end

function filter_aftercast(spell, spellMap, eventArgs)
    if state.EquipStop.value == 'precast' or state.EquipStop.value == 'midcast' or state.EquipStop.value == 'pet_midcast' then
        eventArgs.cancel = true
    elseif spell.name == 'Unknown Interrupt' then
        eventArgs.cancel = true
    end
end

function filter_pet_midcast(spell, spellMap, eventArgs)
    -- If we have show_set active for precast or midcast, don't try to equip pet midcast gear.
    if state.EquipStop.value == 'precast' or state.EquipStop.value == 'midcast' then
        add_to_chat(104, 'Show Sets: Pet midcast not equipped.')
        eventArgs.cancel = true
    end
end

function filter_pet_aftercast(spell, spellMap, eventArgs)
    -- If show_set is flagged for precast or midcast, don't try to equip aftercast gear.
    if state.EquipStop.value == 'precast' or state.EquipStop.value == 'midcast' or state.EquipStop.value == 'pet_midcast' then
        eventArgs.cancel = true
    end
end

--------------------------------------
-- Cleanup code for each action.
--------------------------------------

function cleanup_precast(spell, spellMap, eventArgs)
    -- If show_set is flagged for precast, notify that we won't try to equip later gear.
    if state.EquipStop.value == 'precast' then
        add_to_chat(104, 'Show Sets: Stopping at precast.')
    end
end

function cleanup_midcast(spell, spellMap, eventArgs)
    -- If show_set is flagged for midcast, notify that we won't try to equip later gear.
    if state.EquipStop.value == 'midcast' then
        add_to_chat(104, 'Show Sets: Stopping at midcast.')
    end
end

function cleanup_aftercast(spell, spellMap, eventArgs)
    -- Reset custom classes after all possible precast/midcast/aftercast/job-specific usage of the value.
    -- If we're in the middle of a pet action, pet_aftercast will handle clearing it.
    if not pet_midaction() then
        reset_transitory_classes()
    end
end

function cleanup_pet_midcast(spell, spellMap, eventArgs)
    -- If show_set is flagged for pet midcast, notify that we won't try to equip later gear.
    if state.EquipStop.value == 'pet_midcast' then
        add_to_chat(104, 'Show Sets: Stopping at pet midcast.')
    end
end

function cleanup_pet_aftercast(spell, spellMap, eventArgs)
    -- Reset custom classes after all possible precast/midcast/aftercast/job-specific usage of the value.
    reset_transitory_classes()
end

-- Clears the values from classes that only exist til the action is complete.
function reset_transitory_classes()
    classes.CustomClass = nil
    classes.JAMode = nil
end



-------------------------------------------------------------------------------------------------------------------
-- High-level functions for selecting and equipping gear sets.
-------------------------------------------------------------------------------------------------------------------

-- Central point to call to equip gear based on status.
-- Status - Player status that we're using to define what gear to equip.
function handle_equipping_gear(playerStatus, petStatus)
    -- init a new eventArgs
    local eventArgs = {handled = false}

    -- Allow jobs to override this code
    if job_handle_equipping_gear then
        job_handle_equipping_gear(playerStatus, eventArgs)
    end

    if not eventArgs.handled and user_handle_equipping_gear then
        user_handle_equipping_gear(playerStatus, eventArgs)
    end

    -- Equip default gear if job didn't handle it.
    if not eventArgs.handled then
        -- Use the manually locked set if it exists
        if state.LockedEquipSet ~= nil then
            equip(state.LockedEquipSet)
        else
            equip_gear_by_status(playerStatus, petStatus)
        end
    end
end


-- Function to wrap logic for equipping gear on aftercast, status change, or user update.
-- @param status : The current or new player status that determines what sort of gear to equip.
function equip_gear_by_status(playerStatus, petStatus)
    if _global.debug_mode then add_to_chat(123,'Debug: Equip gear for status ['..tostring(status)..'], HP='..tostring(player.hp)) end

    playerStatus = playerStatus or player.status or 'Idle'
    
    -- If status not defined, treat as idle.
    -- Be sure to check for positive HP to make sure they're not dead.
    if (playerStatus == 'Idle' or playerStatus == '') and player.hp > 0 then
        equip(get_idle_set(petStatus))
    elseif playerStatus == 'Engaged' then
        equip(get_melee_set(petStatus))
    elseif playerStatus == 'Resting' then
        equip(get_resting_set(petStatus))
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Functions for constructing default gear sets based on status.
-------------------------------------------------------------------------------------------------------------------

-- Returns the appropriate idle set based on current state values and location.
-- Set construction order (all of which are optional):
--   sets.idle[idleScope][state.IdleMode][Pet[Engaged]][CustomIdleGroups]
--
-- Params:
-- petStatus - Optional explicit definition of pet status.
function get_idle_set(petStatus)
    local idleSet = sets.idle
    
    if not idleSet then
        return {}
    end
    
    mote_vars.set_breadcrumbs:append('sets')
    mote_vars.set_breadcrumbs:append('idle')
    
    local idleScope

    if buffactive.weakness then
        idleScope = 'Weak'
    elseif areas.Cities:contains(world.area) then
        idleScope = 'Town'
    else
        idleScope = 'Field'
    end

    if idleSet[idleScope] then
        idleSet = idleSet[idleScope]
        mote_vars.set_breadcrumbs:append(idleScope)
    end

    if idleSet[state.IdleMode.current] then
        idleSet = idleSet[state.IdleMode.current]
        mote_vars.set_breadcrumbs:append(state.IdleMode.current)
    end

    if (pet.isvalid or state.Buff.Pet) and idleSet.Pet then
        idleSet = idleSet.Pet
        petStatus = petStatus or pet.status
        mote_vars.set_breadcrumbs:append('Pet')

        if petStatus == 'Engaged' and idleSet.Engaged then
            idleSet = idleSet.Engaged
            mote_vars.set_breadcrumbs:append('Engaged')
        end
    end

    for _,group in ipairs(classes.CustomIdleGroups) do
        if idleSet[group] then
            idleSet = idleSet[group]
            mote_vars.set_breadcrumbs:append(group)
        end
    end

    if state.DefenseLevel.value ~= 'Off' and state.DefenseLevel.value ~= 'EngagedOnly' then
        idleSet = apply_defense(idleSet)    
        idleSet = apply_kiting(idleSet)
    end

    if user_customize_idle_set then
        idleSet = user_customize_idle_set(idleSet)
    end

    if customize_idle_set then
        idleSet = customize_idle_set(idleSet)
    end

    idleSet = apply_weapons(idleSet)

    return idleSet
end


-- Returns the appropriate melee set based on current state values.
-- Set construction order (all sets after sets.engaged are optional):
--   sets.engaged[state.CombatForm][state.WeaponsMode][state.OffenseMode][state.DefenseMode][classes.CustomMeleeGroups (any number)]
function get_melee_set()
    local meleeSet = sets.engaged
    
    if not meleeSet then
        return {}
    end
    
    mote_vars.set_breadcrumbs:append('sets')
    mote_vars.set_breadcrumbs:append('engaged')

    if state.CombatForm.has_value and meleeSet[state.CombatForm.value] then
        meleeSet = meleeSet[state.CombatForm.value]
        mote_vars.set_breadcrumbs:append(state.CombatForm.value)
    end

    if state.WeaponsMode.has_value and meleeSet[state.WeaponsMode.value] then
        meleeSet = meleeSet[state.WeaponsMode.value]
        mote_vars.set_breadcrumbs:append(state.WeaponsMode.value)
    end

    if meleeSet[state.OffenseMode.current] then
        meleeSet = meleeSet[state.OffenseMode.current]
        mote_vars.set_breadcrumbs:append(state.OffenseMode.current)
    end

    for _,group in ipairs(classes.CustomMeleeGroups) do
        if meleeSet[group] then
            meleeSet = meleeSet[group]
            mote_vars.set_breadcrumbs:append(group)
        end
    end

    if customize_melee_set then
        meleeSet = customize_melee_set(meleeSet)
    end

    if user_customize_melee_set then
        meleeSet = user_customize_melee_set(meleeSet)
    end

    if state.DefenseLevel.value ~= 'Off' then
        meleeSet = apply_defense(meleeSet)
        meleeSet = apply_kiting(meleeSet)
    end

    meleeSet = apply_weapons(meleeSet)

    return meleeSet
end


-- Returns the appropriate resting set based on current state values.
-- Set construction order:
--   sets.resting[state.RestingMode]
function get_resting_set()
    local restingSet = sets.resting

    if not restingSet then
        return {}
    end

    mote_vars.set_breadcrumbs:append('sets')
    mote_vars.set_breadcrumbs:append('resting')

    if restingSet[state.RestingMode.current] then
        restingSet = restingSet[state.RestingMode.current]
        mote_vars.set_breadcrumbs:append(state.RestingMode.current)
    end

    return restingSet
end


-------------------------------------------------------------------------------------------------------------------
-- Functions for constructing default gear sets based on action.
-------------------------------------------------------------------------------------------------------------------

-- Get the default precast gear set.
function get_precast_set(spell, spellMap)
    -- If there are no precast sets defined, bail out.
    if not sets.precast then
        return {}
    end

    local equipSet = sets.precast

    mote_vars.set_breadcrumbs:append('sets')
    mote_vars.set_breadcrumbs:append('precast')
    
    -- Determine base sub-table from type of action being performed.
    
    local cat
    
    if spell.action_type == 'Magic' then
        cat = 'FC'
    elseif spell.action_type == 'Ranged Attack' then
        cat = (sets.precast.RangedAttack and 'RangedAttack') or 'RA'
    elseif spell.action_type == 'Ability' then
        if spell.type == 'WeaponSkill' then
            cat = 'WS'
        elseif spell.type == 'JobAbility' then
            cat = 'JA'
        else
            -- Allow fallback to .JA table if spell.type isn't found, for all non-weaponskill abilities.
            cat = (sets.precast[spell.type] and spell.type) or 'JA'
        end
    elseif spell.action_type == 'Item' then
        cat = 'Item'
    end
    
    -- If no proper sub-category is defined in the job file, bail out.
    if cat then
        if equipSet[cat] then
            equipSet = equipSet[cat]
            mote_vars.set_breadcrumbs:append(cat)
        else
            mote_vars.set_breadcrumbs:clear()
            return {}
        end
    end

    classes.SkipSkillCheck = false
    -- Handle automatic selection of set based on spell class/name/map/skill/type.
    equipSet = select_specific_set(equipSet, spell, spellMap)

    
    -- Once we have a named base set, do checks for specialized modes (casting mode, weaponskill mode, etc).
    
    if spell.action_type == 'Magic' then
        if equipSet[state.CastingMode.current] then
            equipSet = equipSet[state.CastingMode.current]
            mote_vars.set_breadcrumbs:append(state.CastingMode.current)
        end
    elseif spell.type == 'WeaponSkill' then
        equipSet = get_weaponskill_set(equipSet, spell, spellMap)
    elseif spell.action_type == 'Ability' then
        if classes.JAMode and equipSet[classes.JAMode] then
            equipSet = equipSet[classes.JAMode]
            mote_vars.set_breadcrumbs:append(classes.JAMode)
        end
    elseif spell.action_type == 'Ranged Attack' then
        equipSet = get_ranged_set(equipSet, spell, spellMap)
    end

    -- Update defintions for element-specific gear that may be used.
    set_elemental_gear(spell)

    -- layer defense on top if requested
    if state.DefenseLevel.value == "Fulltime" then
        equipSet = apply_defense(equipSet)
    end

    equipSet = apply_weapons(equipSet)
    
    -- Return whatever we've constructed.
    return equipSet
end



-- Get the default midcast gear set.
-- This builds on sets.midcast.
function get_midcast_set(spell, spellMap)
    -- If there are no midcast sets defined, bail out.
    if not sets.midcast then
        return {}
    end
    
    local equipSet = sets.midcast

    mote_vars.set_breadcrumbs:append('sets')
    mote_vars.set_breadcrumbs:append('midcast')
    
    -- Determine base sub-table from type of action being performed.
    -- Only ranged attacks and items get specific sub-categories here.
    
    local cat

    if spell.action_type == 'Ranged Attack' then
        cat = (sets.precast.RangedAttack and 'RangedAttack') or 'RA'
    elseif spell.action_type == 'Item' then
        cat = 'Item'
    end
    
    -- If no proper sub-category is defined in the job file, bail out.
    if cat then
        if equipSet[cat] then
            equipSet = equipSet[cat]
            mote_vars.set_breadcrumbs:append(cat)
        else
            mote_vars.set_breadcrumbs:clear()
            return {}
        end
    end
    
    classes.SkipSkillCheck = classes.NoSkillSpells:contains(spell.english)
    -- Handle automatic selection of set based on spell class/name/map/skill/type.
    equipSet = select_specific_set(equipSet, spell, spellMap)
    
    -- After the default checks, do checks for specialized modes (casting mode, etc).
    
    if spell.action_type == 'Magic' then
        if equipSet[state.CastingMode.current] then
            equipSet = equipSet[state.CastingMode.current]
            mote_vars.set_breadcrumbs:append(state.CastingMode.current)
        end
    elseif spell.action_type == 'Ranged Attack' then
        equipSet = get_ranged_set(equipSet, spell, spellMap)
    end

    -- layer defense on top if requested
    if state.DefenseLevel.value == "PlusCasting" or state.DefenseLevel.value == "Fulltime" then
        equipSet = apply_defense(equipSet)
    end

    equipSet = apply_weapons(equipSet)
    
    -- Return whatever we've constructed.
    return equipSet
end


-- Get the default pet midcast gear set.
-- This is built in sets.midcast.Pet.
function get_pet_midcast_set(spell, spellMap)
    -- If there are no midcast sets defined, bail out.
    if not sets.midcast or not sets.midcast.Pet then
        return {}
    end

    local equipSet = sets.midcast.Pet

    mote_vars.set_breadcrumbs:append('sets')
    mote_vars.set_breadcrumbs:append('midcast')
    mote_vars.set_breadcrumbs:append('Pet')

    if sets.midcast and sets.midcast.Pet then
        classes.SkipSkillCheck = false
        equipSet = select_specific_set(equipSet, spell, spellMap)

        -- We can only generally be certain about whether the pet's action is
        -- Magic (ie: it cast a spell of its own volition) or Ability (it performed
        -- an action at the request of the player).  Allow CastinMode and
        -- OffenseMode to refine whatever set was selected above.
        if spell.action_type == 'Magic' then
            if equipSet[state.CastingMode.current] then
                equipSet = equipSet[state.CastingMode.current]
                mote_vars.set_breadcrumbs:append(state.CastingMode.current)
            end
        elseif spell.action_type == 'Ability' then
            if equipSet[state.OffenseMode.current] then
                equipSet = equipSet[state.OffenseMode.current]
                mote_vars.set_breadcrumbs:append(state.OffenseMode.current)
            end
        end
    end

    return equipSet
end


-- Function to handle the logic of selecting the proper weaponskill set.
function get_weaponskill_set(equipSet, spell, spellMap)
    -- Custom handling for weaponskills
    local ws_mode = state.WeaponskillMode.current
    
    if ws_mode == 'Normal' then
        -- If a particular weaponskill mode isn't specified, see if we have a weaponskill mode
        -- corresponding to the current offense mode.  If so, use that.
        if spell.skill == 'Archery' or spell.skill == 'Marksmanship' then
            if state.RangedMode.current ~= 'Normal' and state.WeaponskillMode:contains(state.RangedMode.current) then
                ws_mode = state.RangedMode.current
            end
        else
            if state.OffenseMode.current ~= 'Normal' and state.WeaponskillMode:contains(state.OffenseMode.current) then
                ws_mode = state.OffenseMode.current
            end
        end
    end

    local custom_wsmode

    -- Allow the job file to specify a preferred weaponskill mode
    if get_custom_wsmode then
        custom_wsmode = get_custom_wsmode(spell, spellMap, ws_mode)
    end

    -- If the job file returned a weaponskill mode, use that.
    if custom_wsmode then
        ws_mode = custom_wsmode
    end

    if equipSet[ws_mode] then
        equipSet = equipSet[ws_mode]
        mote_vars.set_breadcrumbs:append(ws_mode)
    end
    
    return equipSet
end


-- Function to handle the logic of selecting the proper ranged set.
function get_ranged_set(equipSet, spell, spellMap)
    -- Attach Combat Form and Combat Weapon to set checks
    if state.CombatForm.has_value and equipSet[state.CombatForm.value] then
        equipSet = equipSet[state.CombatForm.value]
        mote_vars.set_breadcrumbs:append(state.CombatForm.value)
    end

    if state.WeaponsMode.has_value and equipSet[state.WeaponsMode.value] then
        equipSet = equipSet[state.WeaponsMode.value]
        mote_vars.set_breadcrumbs:append(state.WeaponsMode.value)
    end

    -- Check for specific mode for ranged attacks (eg: Acc, Att, etc)
    if equipSet[state.RangedMode.current] then
        equipSet = equipSet[state.RangedMode.current]
        mote_vars.set_breadcrumbs:append(state.RangedMode.current)
    end

    -- Tack on any additionally specified custom groups, if the sets are defined.
    for _,group in ipairs(classes.CustomRangedGroups) do
        if equipSet[group] then
            equipSet = equipSet[group]
            mote_vars.set_breadcrumbs:append(group)
        end
    end

    return equipSet
end


-------------------------------------------------------------------------------------------------------------------
-- Functions for optional supplemental gear overriding the default sets defined above.
-------------------------------------------------------------------------------------------------------------------

-- Function to apply active weapons on top of the supplied set.
-- By attaching this at the end of ANY equip, it should prevent the selected weapons from being removed by any gearswap action.
-- If no WeaponsMode is set, then other sets are free to include weapons (ie casting sets)
-- @param baseSet : The set that any currently active defense set will be applied on top of. (gear set table)
function apply_weapons(baseSet)
    weaponsSet = sets.weapons[state.WeaponsMode.current] or {}
    baseSet = set_combine(baseSet, weaponsSet)
    return baseSet
end


-- Function to apply any active defense set on top of the supplied set
-- @param baseSet : The set that any currently active defense set will be applied on top of. (gear set table)
function apply_defense(baseSet)
    local defenseSet = sets.defense

    defenseSet = sets.defense[state.DefenseMode.current] or defenseSet

    for _,group in ipairs(classes.CustomDefenseGroups) do
        defenseSet = defenseSet[group] or defenseSet
    end

    if customize_defense_set then
        defenseSet = customize_defense_set(defenseSet)
    end

    baseSet = set_combine(baseSet, defenseSet)

    return baseSet
end


-- Function to add kiting gear on top of the base set if kiting state is true.
-- @param baseSet : The gear set that the kiting gear will be applied on top of.
function apply_kiting(baseSet)
    if state.Kiting.value then
        if sets.Kiting then
            baseSet = set_combine(baseSet, sets.Kiting)
        end
    end

    return baseSet
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions for constructing default gear sets.
-------------------------------------------------------------------------------------------------------------------

-- Get a spell mapping for the spell.
function get_spell_map(spell)
    local defaultSpellMap = classes.SpellMaps[spell.english]
    local jobSpellMap
    
    if job_get_spell_map then
        jobSpellMap = job_get_spell_map(spell, defaultSpellMap)
    end

    return jobSpellMap or defaultSpellMap
end


-- Select the equipment set to equip from a given starting table, based on standard
-- selection order: custom class, spell name, spell map, spell skill, and spell type.
-- Spell skill and spell type may further refine their selections based on
-- custom class, spell name and spell map.
function select_specific_set(equipSet, spell, spellMap)
    -- Take the determined base equipment set and try to get the simple naming extensions that
    -- may apply to it (class, spell name, spell map).
    local namedSet = get_named_set(equipSet, spell, spellMap)
    
    -- If no simple naming sub-tables were found, and we simply got back the original equip set,
    -- check for spell.skill and spell.type, then check the simple naming extensions again.
    if namedSet == equipSet then
        if spell.skill and equipSet[spell.skill] and not classes.SkipSkillCheck then
            namedSet = equipSet[spell.skill]
            mote_vars.set_breadcrumbs:append(spell.skill)
        elseif spell.type and equipSet[spell.type] then
            namedSet = equipSet[spell.type]
            mote_vars.set_breadcrumbs:append(spell.type)
        else
            return equipSet
        end
        
        namedSet = get_named_set(namedSet, spell, spellMap)
    end

    return namedSet
end


-- Simple utility function to handle a portion of the equipment set determination.
-- It attempts to select a sub-table of the provided equipment set based on the
-- standard search order of custom class, spell name, and spell map.
-- If no such set is found, it returns the original base set (equipSet) provided.
function get_named_set(equipSet, spell, spellMap)
    if equipSet then
        if classes.CustomClass and equipSet[classes.CustomClass] then
            mote_vars.set_breadcrumbs:append(classes.CustomClass)
            return equipSet[classes.CustomClass]
        elseif equipSet[spell.english] then
            mote_vars.set_breadcrumbs:append(spell.english)
            return equipSet[spell.english]
        elseif spellMap and equipSet[spellMap] then
            mote_vars.set_breadcrumbs:append(spellMap)
            return equipSet[spellMap]
        else
            return equipSet
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Hooks for other events.
-------------------------------------------------------------------------------------------------------------------

-- Called when the player's subjob changes.
function sub_job_change(newSubjob, oldSubjob)
    if user_setup then
        user_setup()
    end
    
    if job_sub_job_change then
        job_sub_job_change(newSubjob, oldSubjob)
    end
    
    send_command('gs c update')
end


-- Called when the player's status changes.
function status_change(newStatus, oldStatus)
    -- init a new eventArgs
    local eventArgs = {handled = false}
    mote_vars.set_breadcrumbs:clear()

    -- Allow a global function to be called on status change.
    if user_status_change then
        user_status_change(newStatus, oldStatus, eventArgs)
    end

    -- Then call individual jobs to handle status change events.
    if not eventArgs.handled then
        if job_status_change then
            job_status_change(newStatus, oldStatus, eventArgs)
        end
    end

    -- Handle equipping default gear if the job didn't mark this as handled.
    if not eventArgs.handled then
        handle_equipping_gear(newStatus)
        display_breadcrumbs()
    end
end


-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function buff_change(buff, gain)
    -- Init a new eventArgs
    local eventArgs = {handled = false}

    if state.Buff[buff] ~= nil then
        state.Buff[buff] = gain
    end

    -- Allow a global function to be called on buff change.
    if user_buff_change then
        user_buff_change(buff, gain, eventArgs)
    end

    -- Allow jobs to handle buff change events.
    if not eventArgs.handled then
        if job_buff_change then
            job_buff_change(buff, gain, eventArgs)
        end
    end
end


-- Called when a player gains or loses a pet.
-- pet == pet gained or lost
-- gain == true if the pet was gained, false if it was lost.
function pet_change(pet, gain)
    -- Init a new eventArgs
    local eventArgs = {handled = false}

    -- Allow jobs to handle pet change events.
    if job_pet_change then
        job_pet_change(pet, gain, eventArgs)
    end

    -- Equip default gear if not handled by the job.
    if not eventArgs.handled then
        handle_equipping_gear(player.status)
    end
end


-- Called when the player's pet's status changes.
-- Note that this is also called after pet_change when the pet is released.
-- As such, don't automatically handle gear equips.  Only do so if directed
-- to do so by the job.
function pet_status_change(newStatus, oldStatus)
    -- Init a new eventArgs
    local eventArgs = {handled = false}

    -- Allow jobs to override this code
    if job_pet_status_change then
        job_pet_status_change(newStatus, oldStatus, eventArgs)
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Debugging functions.
-------------------------------------------------------------------------------------------------------------------

-- This is a debugging function that will print the accumulated set selection
-- breadcrumbs for the default selected set for any given action stage.
function display_breadcrumbs(spell, spellMap, action)
    if not _settings.debug_mode then
        return
    end
    
    local msg = 'Default '
    
    if action and spell then
        msg = msg .. action .. ' set selection for ' .. spell.name
    end
    
    if spellMap then
        msg = msg .. ' (' .. spellMap .. ')'
    end
    msg = msg .. ' : '
    
    local cons
    
    for _,name in ipairs(mote_vars.set_breadcrumbs) do
        if not cons then
            cons = name
        else
            if name:contains(' ') or name:contains("'") then
                cons = cons .. '["' .. name .. '"]'
            else
                cons = cons .. '.' .. name
            end
        end
    end

    if cons then
        if action and cons == ('sets.' .. action) then
            msg = msg .. "None"
        else
            msg = msg .. tostring(cons)
        end
        add_to_chat(123, msg)
    end
end


