-------------------------------------------------------------------------------------------------------------------
-- Mappings, lists and sets to describe game relationships that aren't easily determinable otherwise.
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
-- Elemental mappings for element relationships and certain types of spells and gear.
-------------------------------------------------------------------------------------------------------------------

-- Basic elements
elements = {}

elements.list = S{'Light','Dark','Fire','Ice','Wind','Earth','Lightning','Water'}

elements.weak_to = {['Light']='Dark', ['Dark']='Light', ['Fire']='Ice', ['Ice']='Wind', ['Wind']='Earth', ['Earth']='Lightning',
        ['Lightning']='Water', ['Water']='Fire'}

elements.strong_to = {['Light']='Dark', ['Dark']='Light', ['Fire']='Water', ['Ice']='Fire', ['Wind']='Ice', ['Earth']='Wind',
        ['Lightning']='Earth', ['Water']='Lightning'}

storms = S{"Aurorastorm", "Voidstorm", "Firestorm", "Sandstorm", "Rainstorm", "Windstorm", "Hailstorm", "Thunderstorm",
		"Aurorastorm II", "Voidstorm II", "Firestorm II", "Sandstorm II", "Rainstorm II", "Windstorm II", "Hailstorm II", "Thunderstorm II"}

elements.storm_of = {['Light']="Aurorastorm", ['Dark']="Voidstorm", ['Fire']="Firestorm", ['Earth']="Sandstorm",
        ['Water']="Rainstorm", ['Wind']="Windstorm", ['Ice']="Hailstorm", ['Lightning']="Thunderstorm",['Light']="Aurorastorm II",
		['Dark']="Voidstorm II", ['Fire']="Firestorm II", ['Earth']="Sandstorm II", ['Water']="Rainstorm II", ['Wind']="Windstorm II",
		['Ice']="Hailstorm II", ['Lightning']="Thunderstorm II"}

spirits = S{"LightSpirit", "DarkSpirit", "FireSpirit", "EarthSpirit", "WaterSpirit", "AirSpirit", "IceSpirit", "ThunderSpirit"}
elements.spirit_of = {['Light']="Light Spirit", ['Dark']="Dark Spirit", ['Fire']="Fire Spirit", ['Earth']="Earth Spirit",
        ['Water']="Water Spirit", ['Wind']="Air Spirit", ['Ice']="Ice Spirit", ['Lightning']="Thunder Spirit"}

runes = S{'Lux', 'Tenebrae', 'Ignis', 'Gelus', 'Flabra', 'Tellus', 'Sulpor', 'Unda'}
elements.rune_of = {['Light']='Lux', ['Dark']='Tenebrae', ['Fire']='Ignis', ['Ice']='Gelus', ['Wind']='Flabra',
     ['Earth']='Tellus', ['Lightning']='Sulpor', ['Water']='Unda'}

elements.obi_of = {['Light']='Hachirin-no-obi', ['Dark']='Hachirin-no-obi', ['Fire']='Hachirin-no-obi', ['Ice']='Hachirin-no-obi', ['Wind']='Hachirin-no-obi',
     ['Earth']='Hachirin-no-obi', ['Lightning']='Hachirin-no-obi', ['Water']='Hachirin-no-obi'}
 
elements.gorget_of = {['Light']='Fotia Gorget', ['Dark']='Fotia Gorget', ['Fire']='Fotia Gorget', ['Ice']='Fotia Gorget',
    ['Wind']='Fotia Gorget', ['Earth']='Fotia Gorget', ['Lightning']='Fotia Gorget', ['Water']='Fotia Gorget'}
 
elements.belt_of = {['Light']='Fotia Belt', ['Dark']='Fotia Belt', ['Fire']='Fotia Belt', ['Ice']='Fotia Belt',
    ['Wind']='Fotia Belt', ['Earth']='Fotia Belt', ['Lightning']='Fotia Belt', ['Water']='Fotia Belt'}

elements.fastcast_staff_of = {['Light']='Arka I', ['Dark']='Xsaeta I', ['Fire']='Atar I', ['Ice']='Vourukasha I',
    ['Wind']='Vayuvata I', ['Earth']='Vishrava I', ['Lightning']='Apamajas I', ['Water']='Haoma I', ['Thunder']='Apamajas I'}

elements.recast_staff_of = {['Light']='Arka II', ['Dark']='Xsaeta II', ['Fire']='Atar II', ['Ice']='Vourukasha II',
    ['Wind']='Vayuvata II', ['Earth']='Vishrava II', ['Lightning']='Apamajas II', ['Water']='Haoma II', ['Thunder']='Apamajas II'}

elements.perpetuance_staff_of = {['Light']='Arka III', ['Dark']='Xsaeta III', ['Fire']='Atar III', ['Ice']='Vourukasha III',
    ['Wind']='Vayuvata III', ['Earth']='Vishrava III', ['Lightning']='Apamajas III', ['Water']='Haoma III', ['Thunder']='Apamajas III'}


-- Elements for skillchain names
skillchain_elements = {}
skillchain_elements.Light = S{'Light','Fire','Wind','Lightning'}
skillchain_elements.Darkness = S{'Dark','Ice','Earth','Water'}
skillchain_elements.Fusion = S{'Light','Fire'}
skillchain_elements.Fragmentation = S{'Wind','Lightning'}
skillchain_elements.Distortion = S{'Ice','Water'}
skillchain_elements.Gravitation = S{'Dark','Earth'}
skillchain_elements.Transfixion = S{'Light'}
skillchain_elements.Compression = S{'Dark'}
skillchain_elements.Liquification = S{'Fire'}
skillchain_elements.Induration = S{'Ice'}
skillchain_elements.Detonation = S{'Wind'}
skillchain_elements.Scission = S{'Earth'}
skillchain_elements.Impaction = S{'Lightning'}
skillchain_elements.Reverberation = S{'Water'}


-------------------------------------------------------------------------------------------------------------------
-- Mappings for weaponskills
-------------------------------------------------------------------------------------------------------------------

-- REM weapons and their corresponding weaponskills
data = {}
data.weaponskills = {}
data.weaponskills.relic = {
    ["Spharai"] = "Final Heaven",
    ["Mandau"] = "Mercy Stroke",
    ["Excalibur"] = "Knights of Round",
    ["Ragnarok"] = "Scourge",
    ["Guttler"] = "Onslaught",
    ["Bravura"] = "Metatron Torment",
    ["Apocalypse"] = "Catastrophe",
    ["Gungnir"] = "Gierskogul",
    ["Kikoku"] = "Blade: Metsu",
    ["Amanomurakumo"] = "Tachi: Kaiten",
    ["Mjollnir"] = "Randgrith",
    ["Claustrum"] = "Gates of Tartarus",
    ["Annihilator"] = "Coronach",
    ["Yoichinoyumi"] = "Namas Arrow"}
data.weaponskills.mythic = {
    ["Conqueror"] = "King's Justice",
    ["Glanzfaust"] = "Ascetic's Fury",
    ["Yagrush"] = "Mystic Boon",
    ["Laevateinn"] = "Vidohunir",
    ["Murgleis"] = "Death Blossom",
    ["Vajra"] = "Mandalic Stab",
    ["Burtgang"] = "Atonement",
    ["Liberator"] = "Insurgency",
    ["Aymur"] = "Primal Rend",
    ["Carnwenhan"] = "Mordant Rime",
    ["Gastraphetes"] = "Trueflight",
    ["Kogarasumaru"] = "Tachi: Rana",
    ["Nagi"] = "Blade: Kamu",
    ["Ryunohige"] = "Drakesbane",
    ["Nirvana"] = "Garland of Bliss",
    ["Tizona"] = "Expiacion",
    ["Death Penalty"] = "Leaden Salute",
    ["Kenkonken"] = "Stringing Pummel",
    ["Terpsichore"] = "Pyrrhic Kleos",
    ["Tupsimati"] = "Omniscience",
    ["Idris"] = "Exudation",
    ["Epeolatry"] = "Dimidiation"}
data.weaponskills.empyrean = {
    ["Verethragna"] = "Victory Smite",
    ["Twashtar"] = "Rudra's Storm",
    ["Almace"] = "Chant du Cygne",
    ["Caladbolg"] = "Torcleaver",
    ["Farsha"] = "Cloudsplitter",
    ["Ukonvasara"] = "Ukko's Fury",
    ["Redemption"] = "Quietus",
    ["Rhongomiant"] = "Camlann's Torment",
    ["Kannagi"] = "Blade: Hi",
    ["Masamune"] = "Tachi: Fudo",
    ["Gambanteinn"] = "Dagann",
    ["Hvergelmir"] = "Myrkr",
    ["Gandiva"] = "Jishnu's Radiance",
    ["Armageddon"] = "Wildfire"}

-- Weaponskills that can be used at range.
data.weaponskills.ranged = S{"Flaming Arrow", "Piercing Arrow", "Dulling Arrow", "Sidewinder", "Arching Arrow",
    "Empyreal Arrow", "Refulgent Arrow", "Apex Arrow", "Namas Arrow", "Jishnu's Radiance",
    "Hot Shot", "Split Shot", "Sniper Shot", "Slug Shot", "Heavy Shot", "Detonator", "Last Stand",
    "Coronach", "Trueflight", "Leaden Salute", "Wildfire",
    "Myrkr"}

ranged_weaponskills = data.weaponskills.ranged

-------------------------------------------------------------------------------------------------------------------
-- Spell mappings allow defining a general category or description that each of sets of related
-- spells all fall under.
-------------------------------------------------------------------------------------------------------------------

spell_maps = {
    ['Cure'] = S{
        'Cure', 'Cure II', 'Cure III', 'Cure IV', 'Cure V', 'Cure VI', 'Full Cure'},
    ['Curaga'] = S{
        'Cura', 'Cura II', 'Cura III', 'Curaga', 'Curaga II', 'Curaga III', 'Curaga IV', 'Curaga V', 'Curaga VI'},
    ['StatusRemoval'] = S{
        'Poisona', 'Paralyna', 'Silena', 'Blindna', 'Cursna', 'Stona', 'Viruna', 'Erase', 'Esuna'},
    ['BarElement'] = S{
        'Barstone', 'Barwater', 'Baraero', 'Barfire', 'Barblizzard', 'Barthunder', 
        'Barstonra', 'Barwatera', 'Baraera', 'Barfira', 'Barblizzara', 'Barthundra'},
    ['Raise'] = S{
         'Raise', 'Raise II', 'Raise III', 'Arise'},
    ['Reraise'] = S{
        'Reraise', 'Reraise II', 'Reraise III', 'Reraise IV'},
    ['Protect'] = S{
        'Protect', 'Protect II', 'Protect III', 'Protect IV', 'Protect V', 
        'Protectra', 'Protectra II', 'Protectra III', 'Protectra IV', 'Protectra V'},
    ['Shell'] = S{
        'Shell', 'Shell II', 'Shell III', 'Shell IV', 'Shell V',
        'Shellra', 'Shellra II', 'Shellra III', 'Shellra IV', 'Shellra V'},
    ['Regen'] = S{
        'Regen', 'Regen II', 'Regen III', 'Regen IV', 'Regen V'},
    ['Refresh'] = S{
        'Refresh', 'Refresh II', 'Refresh III'},
    ['Teleport']= S{
        'Teleport-Holla', 'Teleport-Dem', 'Teleport-Mea', 'Teleport-Altep', 'Teleport-Yhoat', 'Teleport-Vahzl',
        'Recall-Pashh', 'Recall-Meriph', 'Recall-Jugner'},
    
    ['Enfeebling_MND'] = S{
        'Paralye', 'Paralyze II', 'Dia', 'Dia II', 'Dia III', 'Diaga', 'Slow', 'Slow II', 'Silence', 'Addle', 'Addle II'},
    ['Enfeebling_INT'] = S{
        'Poison', 'Poison II', 'Poisonga', 'Blind', 'Blind II', 'Bind', 'Gravity', 'Gravity II', 'Dispel', 'Sleep', 'Sleep II', 'Sleepga', 'Sleepga II',
        'Distract', 'Distract II', 'Distract III', 'Frazzle', 'Frazzle II', 'Frazzle III', 'Break', 'Breakga'},

    ['Banish'] = S{
        'Banish', 'Banish II', 'Banish III', 'Banishga', 'Banishga II'},
    ['Holy'] = S{
        'Holy', 'Holy II'},
    ['Drain'] = S{
        'Drain', 'Drain II', 'Drain III'},
    ['Aspir'] = S{
        'Aspir', 'Aspir II'},
    ['Absorb'] = S{
        'Absorb-Str', 'Absorb-Dex', 'Absorb-Vit', 'Absorb-Agi', 'Absorb-Int', 'Absorb-Mnd', 'Absorb-Chr', 'Absorb-Acc', 'Absorb-TP', 'Absorb-Attri'},
    ['Enspell'] = S{
        'Enstone', 'Enwater', 'Enaero', 'Enfire', 'Enblizzard', 'Enthunder', 'Enlight', 'Endark',
        'Enstone II', 'Enwater II', 'Enaero II', 'Enfire II', 'Enblizzard II', 'Enthunder II', 'Enlight II', 'Endark II'},
    ['ElementalEnfeeble'] = S{
        'Burn', 'Frost', 'Choke', 'Rasp', 'Shock', 'Drown'},

    -- Songs
    ['Minuet'] = S{
        'Valor Minuet', 'Valor Minuet II', 'Valor Minuet III', 'Valor Minuet IV', 'Valor Minuet V'},
    ['Minne'] = S{
        "Knight's Minne", "Knight's Minne II", "Knight's Minne III", "Knight's Minne IV", "Knight's Minne V"},
    ['March'] = S{
        'Advancing March', 'Victory March', 'Honor March'},
    ['Madrigal'] = S{
        'Sword Madrigal', 'Blade Madrigal'},
    ['Prelude'] = S{
        "Hunter's Prelude", "Archer's Prelude"},
    ['Mambo'] = S{
        'Sheepfoe Mambo', 'Dragonfoe Mambo'},
    ['Mazurka'] = S{
        'Raptor Mazurka', 'Chocobo Mazurka'},
    ['Etude'] = S{
        'Sinewy Etude', 'Dextrous Etude', 'Vivacious Etude', 'Quick Etude', 'Learned Etude', 'Spirited Etude', 'Enchanting Etude',
        'Herculean Etude', 'Uncanny Etude', 'Vital Etude', 'Swift Etude', 'Sage Etude', 'Logical Etude', 'Bewitching Etude'},
    ['Ballad'] = S{
        "Mage's Ballad", "Mage's Ballad II", "Mage's Ballad III"},
    ['Paeon'] = S{
        "Army's Paeon", "Army's Paeon II", "Army's Paeon III", "Army's Paeon IV", "Army's Paeon V", "Army's Paeon VI"},
    ['Carol'] = S{
        'Fire Carol', 'Ice Carol', 'Wind Carol', 'Earth Carol', 'Lightning Carol', 'Water Carol', 'Light Carol', 'Dark Carol',
        'Fire Carol II', 'Ice Carol II', 'Wind Carol II', 'Earth Carol II', 'Lightning Carol II', 'Water Carol II', 'Light Carol II', 'Dark Carol II'},
    ['Lullaby'] = S{
        'Foe Lullaby', 'Foe Lullaby II', 'Horde Lullaby', 'Horde Lullaby II'},
    ['Threnody'] = S{
        'Fire Threnody', 'Ice Threnody', 'Wind Threnody', 'Earth Threnody', 'Lightning Threnody', 'Water Threnody', 'Light Threnody', 'Dark Threnody',
        'Fire Threnody II', 'Ice Threnody II', 'Wind Threnody II', 'Earth Threnody II', 'Lightning Threnody II', 'Water Threnody II', 'Light Threnody II', 'Dark Threnody II'},
    ['Elegy'] = S{
        'Battlefield Elegy', 'Carnage Elegy'},
    ['Requiem'] = S{
        'Foe Requiem', 'Foe Requiem II', 'Foe Requiem III', 'Foe Requiem IV', 'Foe Requiem V', 'Foe Requiem VI', 'Foe Requiem VII'},
    
    -- Ninjutsu
    ['Utsusemi'] = S{
        'Utsusemi: Ichi', 'Utsusemi: Ni', 'Utsusemi: San'},
    ['ElementalNinjutsu'] = S{
        'Katon: Ichi', 'Suiton: Ichi', 'Raiton: Ichi', 'Doton: Ichi', 'Huton: Ichi', 'Hyoton: Ichi',
        'Katon: Ni', 'Suiton: Ni', 'Raiton: Ni', 'Doton: Ni', 'Huton: Ni', 'Hyoton: Ni',
        'Katon: San', 'Suiton: San', 'Raiton: San', 'Doton: San', 'Huton: San', 'Hyoton: San'},
    
    -- Sch
    ['Helix'] = S{
        'Pyrohelix', 'Cryohelix', 'Anemohelix', 'Geohelix', 'Ionohelix', 'Hydrohelix', 'Luminohelix', 'Noctohelix',
	    'Pyrohelix II', 'Cryohelix II', 'Anemohelix II', 'Geohelix II', 'Ionohelix II', 'Hydrohelix II', 'Luminohelix II', 'Noctohelix II'},
    ['Storm'] = S{
        'Firestorm', 'Hailstorm', 'Windstorm', 'Sandstorm', 'Thunderstorm', 'Rainstorm', 'Aurorastorm', 'Voidstorm',
	    'Firestorm II', 'Hailstorm II', 'Windstorm II', 'Sandstorm II', 'Thunderstorm II', 'Rainstorm II', 'Aurorastorm II', 'Voidstorm II'},

    -- Pup
    ['Maneuver'] = S{
        'Fire Maneuver', 'Ice Maneuver', 'Wind Maneuver', 'Earth Maneuver', 'Thunder Maneuver', 'Water Maneuver', 'Light Maneuver', 'Dark Maneuver'},

    -- Physical blue magic
    ['Blue_Physical_STR'] = S{
        'Asuran Claws', 'Bilgestorm', 'Battle Dance', 'Bludgeon', 'Bloodrake', 'Death Scissors', 
        'Dimensional Death', 'Empty Thrash', 'Heavy Strike', 'Mandibular Bite', 'Quadrastrike', 'Uppercut', 'Tourbillion', 'Sinker Drill', 
        'Thrashing Assault', 'Vertical Cleave', 'Whirl of Rage', 'Saurian Slide', 'Spinal Cleave', 'Paralyzing Triad'},
    ['Blue_Physical_DEX'] = S{
        'Amorphic Spikes', 'Barbed Crescent', 'Claw Cyclone', 'Disseverment', 'Foot Kick',
        'Frenetic Rip', 'Goblin Rush', 'Hysteric Barrage', 'Seedspray', 'Sickle Slash', 'Terror Touch', 'Vanity Dive'},
    ['Blue_Physical_VIT'] = S{
        'Body Slam', 'Cannonball', 'Delta Thrust', 'Glutinous Dart', 'Grand Slam', 'Quad. Continuum', 'Sprout Smack', 'Sweeping Gouge'},
    ['Blue_Physical_AGI'] = S{
        'Benthic Typhoon', 'Feather Storm', 'Helldive', 'Hydro Shot', 'Jet Stream', 'Pinecone Bomb', 'Wild Oats', 'Spiral Spin'},
    -- These spells may have WSC but are generally not worth worrynig about, or the spell's primary purpose isn't damage
    ['Blue_Physical_Other'] = S{
        'Queasyshroom', 'Power Attack', 'Ram Charge', 'Saurian Slide', 'Screwdriver',  'Smite of Rage'},

    -- Magical blue magic
    ['Blue_Magical_INTMAB'] = S{
        'Acrid Stream', 'Anvil Lightning', 'Crashing Thunder', 'Charged Whisker', 'Droning Whirlwind', 'Firespit',
        'Foul Waters', 'Gates of Hades', 'Ice Break', 'Leafstorm', 'Molting Plumage', 'Nectarous Deluge', 'Polar Roar',
        'Regurgitation', 'Rending Deluge', 'Scouring Spate', 'Searing Tempest', 'Silent Storm', 'Spectral Floe',
        'Subduction', 'Tem. Upheaval', 'Thermal Pulse', 'Thunderbolt', 'Uproot', 'Water Bomb' },
    ['Blue_Magical_Light'] = S{
        'Blinding Fulgor', 'Diffusion Ray', 'Magic Hammer', 'Rail Cannon', 'Retinal Glare' },
    ['Blue_Magical_Dark'] = S{
        'Blood Saber', 'Dark Orb', 'Death Ray', 'Eyes On Me', 'Evryone. Grudge', 'Palling Salvo', 'Tenebral Crush'},
    ['Blue_Magical_Earth'] = S{
         'Embalming Earth', 'Entomb', 'Sandspin' },
    ['Blue_Magical_Other'] = S{
         'Osmosis', 'Feather Tickle', 'Reaving Wind', 'Blazing Bound'},

    ['Blue_Magical_MACC'] = S{
        '1000 Needles', 'Absolute Terror', 'Auroral Drape', 'Awful Eye', 'Blastbomb', 'Blank Gaze', 'Blistering Roar', 'Blitzstrahl',
        'Blood Drain', 'Blood Saber', 'Chaotic Eye', 'Cimicine Discharge', 'Cold Wave', 'Digest', 'Corrosive Ooze',
        'Demoralizing Roar', 'Dream Flower', 'Enervation', 'Filamented Hold', 'Frightful Roar',
        'Geist Wall', 'Hecatomb Wave', 'Infrasonics', 'Light of Penance', 'Lowing', 'Mind Blast', 'Mortal Ray',
        'MP Drainkiss', 'Sheep Song', 'Soporific', 'Sound Blast', 'Sprout Smack', 'Stinking Gas','Osmosis', 'Cruel Joke'},
    ['Blue_Breath'] = S{
        'Bad Breath', 'Flying Hip Press', 'Final Sting', 'Frost Breath', 'Heat Breath', 'Magnetite Cloud',
        'Poison Breath', 'Radiant Breath', 'Self Destruct', 'Thunder Breath', 'Vapor Spray', 'Wind Breath'},

    -- Effect blue magic
    ['Blue_Stun'] = S{
        'Frypan', 'Head Butt', 'Sudden Lunge', 'Tail slap', 'Sub-zero Smash', 'Sweeping Gouge'},
    ['Blue_Skill'] = S{
        'Diamondhide', 'Metallic Body', 'Magic Barrier', 'Atra. Libations'},
    ['Blue_Cure'] = S{
        'Healing Breeze', 'Magic Fruit', 'Plenilune Embrace', 'Pollen', 'Restoral', 'Wild Carrot'},
    ['Blue_Buff'] = S{
        'Barrier Tusk', 'Cocoon', 'Carcharian Verve', 'Erratic Flutter', 'Harden Shell', 'Orcish Counterstance',
        'Plasma Charge', 'Pyric Bulwark', 'Memento Mori', 'Mighty Guard', 'Nat. Meditation', 'Reactor Cool', 'Saline Coat', 
        'Feather Barrier','Refueling','Warm-Up', 'Zephyr Mantle', 'Reactor Cool', 'Plasma Charge', 'Amplification'},
    ['Blue_Enmity'] = S{
        'Actinic Burst', 'Exuviation', 'Fantod', 'Jettatura', 'Temporal Shift'},

    -- Wyvern Breaths
    ['Healing Breath'] = S{'Healing Breath', 'Healing Breath II', 'Healing Breath III', 'Healing Breath IV'},
    ['ElementalBreath'] = S{'Flame Breath', 'Frost Breath', 'Sand Breath', 'Hydro Breath', 'Gust Breath', 'Lightning Breath'},
}

no_skill_spells_list = S{'Haste', 'Refresh', 'Regen', 'Protect', 'Protectra', 'Shell', 'Shellra',
        'Raise', 'Reraise', 'Sneak', 'Invisible', 'Deodorize'}


-------------------------------------------------------------------------------------------------------------------
-- Tables to specify general area groupings.  Creates the 'areas' table to be referenced in job files.
-- Zone names provided by world.area/world.zone are currently in all-caps, so defining the same way here.
-------------------------------------------------------------------------------------------------------------------

areas = {}

-- City areas for town gear and behavior.
areas.Cities = S{
    "Ru'Lude Gardens",
    "Upper Jeuno",
    "Lower Jeuno",
    "Port Jeuno",
    "Port Windurst",
    "Windurst Waters",
    "Windurst Woods",
    "Windurst Walls",
    "Heavens Tower",
    "Port San d'Oria",
    "Northern San d'Oria",
    "Southern San d'Oria",
    "Port Bastok",
    "Bastok Markets",
    "Bastok Mines",
    "Metalworks",
    "Aht Urhgan Whitegate",
    "Tavnazian Safehold",
    "Nashmau",
    "Selbina",
    "Mhaura",
    "Norg",
    "Eastern Adoulin",
    "Western Adoulin",
    "Kazham",
    "Rabao",
    "Chocobo Circuit",
}
-- Adoulin areas, where Ionis will grant special stat bonuses.
areas.Adoulin = S{
    "Yahse Hunting Grounds",
    "Ceizak Battlegrounds",
    "Foret de Hennetiel",
    "Morimar Basalt Fields",
    "Yorcia Weald",
    "Yorcia Weald [U]",
    "Cirdas Caverns",
    "Cirdas Caverns [U]",
    "Marjami Ravine",
    "Kamihr Drifts",
    "Sih Gates",
    "Moh Gates",
    "Dho Gates",
    "Woh Gates",
    "Rala Waterways",
    "Rala Waterways [U]",
    "Outer Ra'Kaznar",
    "Outer Ra'Kaznar [U]"
}


-------------------------------------------------------------------------------------------------------------------
-- Lists of certain NPCs. (Not up to date)
-------------------------------------------------------------------------------------------------------------------

npcs = {}
npcs.Trust = S{'Ajido-Marujido','Aldo','Ayame','Cherukiki','Curilla','D.Shantotto','Elivira','Excenmille',
        'Fablinix','FerreousCoffin','Gadalar','Gessho','Ingrid','IronEater','Joachim','Klara','Kupipi',
        'LehkoHabhoka','LhuMhakaracca','Lion','Luzaf','Maat','MihliAliapoh','Mnejing','Moogle','Mumor',
        'NajaSalaheem','Najelith','Naji','NanaaMihgo','Nashmeira','Noillurie','Ovjang','Prishe','Rainemard',
        'RomaaMihgo','Sakura','Shantotto','StarSibyl','Tenzen','Trion','UkaTotlihn','Ulmia','Valaineral',
        'Volker','Zazarg','Zeid'}


