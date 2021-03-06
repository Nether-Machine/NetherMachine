-- NetherMachine Rotation
-- Profile Created by NetherMan
-- Custom Warrior Protection - WoD 6.1.2
-- Created on 05/08/15
-- Updated on 05/11/2015 @ 20:32
-- Version 1.0.2
-- Status: Functional - Beta Stage [ Estimated Completion: ~10% ]
--[[	Notes:	Profile developed to match SimCraft T17-Heroic Action Rotation Lists & tuned for Gear ilvl = 680-690 (with Tier 17 4 set bonus)
# Gear Summary:	neck enchant=gift_of_mastery, back enchant=gift_of_mastery, finger1 enchant=gift_of_mastery, 
				finger2 enchant=gift_of_mastery, trinket1=tablet_of_turnbuckle_teamwork id=113905,
				trinket2=blast_furnace_door id=113893, main_hand=kromogs_brutal_fist id=113927 enchant=mark_of_blackrock,
				off_hand=kromogs_protecting_palm id=113926	]]

-- Suggested Talents: 1113323
-- Suggested Glyphs: Unending Rage / Heroic Leap / Cleave
-- Controls: Pause - Left Control

-- ToDo List:
--[[		1. )   Need function to detect 2/4 Tier Set Bonus Abilities
			2. )   Need to rework the GCD detection Function
]]

NetherMachine.rotation.register_custom(73, "|cff8A2BE2Nether|r|cffFF0074Machine |cffC79C6EWarrior Protection |cffff9999(SimC T17N/H) |cff336600Ver: |cff3333cc1.0.2", {
---- *** COMBAT ROUTINE SECTION ***
	-- ** Pauses **
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },
	{ "pause", "target.istheplayer" },

	{ "/stopcasting", { "boss2.exists", "player.casting", "boss2.casting(Interrupting Shout)" } }, -- boss2 Highmual Pol Interrupting Shout

	-- Stance
	{ "Defensive Stance", { "!player.buff(Defensive Stance)", "!modifier.last" } },
	
	-- ** Consumables **
	{ "#5512", { "toggle.consume", "player.health < 40" } }, -- Healthstone (5512)
	{ "#109223", { "toggle.consume", "player.health < 15", "target.boss" } }, -- WoD Healing Tonic (109223)

	-- Buttons
	{ "Heroic Leap", { "modifier.lalt" }, "ground" },

	-- ** Auto Grinding **
	{	{
		{ "Battle Shout", "@bbLib.engaugeUnit('ANY', 30, true)" },
		}, { "toggle.autogrind" } },

	-- ** Auto Target **
	{ "/targetenemy [noexists]", { "toggle.autotarget", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.autotarget", "target.exists", "target.dead" } },

	-- ** Interrupts **
	{	{
		{ "Disrupting Shout", { "target.exists", "target.enemy", "target.range < 10", "player.area(10).enemies > 1"  } },
		{ "Disrupting Shout", { "mouseover.exists", "mouseover.enemy", "mouseover.interruptAt(40)", "mouseover.range < 10", "player.area(10).enemies > 1" }, "mouseover" },
		{ "Pummel", { "target.exists", "target.enemy", "target.interruptAt(40)", "target.range < 5" } },
		{ "Pummel", { "mouseover.exists", "mouseover.enemy", "mouseover.interruptAt(40)", "mouseover.range <= 5" }, "mouseover" },
		-- Spell Reflection
		{ "Arcane Torrent", "target.distance < 8" }, -- Blood Elf Racial
		{ "War Stomp", "target.range < 8" }, -- Taruen Racial
		},	{ "modifier.interrupt","target.interruptAt(50)" } },

	-- ** Mouseovers **
	{ "Heroic Throw", { "toggle.mouseovers", "mouseover.exists", "mouseover.enemy", "mouseover.alive", "mouseover.distance <= 30" }, "mouseover" },

	-- ** Pre-DPS Pauses **
	{ "pause", "target.debuff(Wyvern Sting).any" },
	{ "pause", "target.debuff(Scatter Shot).any" },
	{ "pause", "target.immune.all" },
	{ "pause", "target.status.disorient" },
	{ "pause", "target.status.incapacitate" },
	{ "pause", "target.status.sleep" },

	-- ** Common **
	-- # Executed every time the actor is available.
	-- actions=charge
	-- actions+=/auto_attack
	-- actions+=/call_action_list,name=prot
	
	-- ** Cooldowns **
	{	{
		-- actions.prot+=/potion,name=draenic_armor,if=incoming_damage_2500ms>health.max*0.1&!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up|buff.potion.up)|target.time_to_die<=25
		{ "#109220", { "toggle.consume", "target.boss", "player.health <= 30" } }, -- Draenic Armor Potion (109220)
		-- actions+=/use_item,name=tablet_of_turnbuckle_teamwork,if=active_enemies=1&(buff.bloodbath.up|!talent.bloodbath.enabled)|(active_enemies>=2&buff.ravager_protection.up)
		{ "#trinket1", { "player.area(5).enemies == 1", "player.buff(Bloodbath)" } },
		{ "#trinket1", { "player.area(5).enemies == 1", "!talent(6, 2)"} },
		{ "#trinket1", { "player.area(5).enemies >= 2", "player.buff(Ravager Protection)" } },
		{ "#trinket2", { "player.area(5).enemies == 1", "player.buff(Bloodbath)" } },
		{ "#trinket2", { "player.area(5).enemies == 1", "!talent(6, 2)"} },
		{ "#trinket2", { "player.area(5).enemies >= 2", "player.buff(Ravager Protection)" } },
		-- actions+=/blood_fury,if=buff.bloodbath.up|buff.avatar.up
		{ "Blood Fury", "player.buff(Bloodbath)" },
		{ "Blood Fury", "player.buff(Avatar)" },
		-- actions+=/berserking,if=buff.bloodbath.up|buff.avatar.up
		{ "Berserking", "player.buff(Bloodbath)" },
		{ "Berserking", "player.buff(Avatar)" },
		-- actions+=/arcane_torrent,if=buff.bloodbath.up|buff.avatar.up
		{ "Arcane Torrent", "player.buff(Bloodbath)" },
		{ "Arcane Torrent", "player.buff(Avatar)" },
		-- actions+=/berserker_rage,if=buff.enrage.down
		{ "Berserker Rage", "!player.buff(Enrage)" },
		-- actions.prot=shield_block,if=!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up)
		{ "Shield Block", "!target.debuff(Demoralizing Shout)" },
		{ "Shield Block", "!player.buff(Ravager Protection)" },
		{ "Shield Block", "!player.buff(Shield Wall)" },
		{ "Shield Block", "!player.buff(Last Stand)" },
		{ "Shield Block", "!player.buff(Enraged Regeneration)" },
		{ "Shield Block", "!player.buff(Shield Block)" },
		-- actions.prot+=/shield_barrier,if=buff.shield_barrier.down&((buff.shield_block.down&action.shield_block.charges_fractional<0.75)|rage>=85)
		{ "Shield Barrier", { "!player.buff(Shield Barrier)", "!player.buff(Shield Block)", "player.buff(Shield Block).charges < 1" } },
		{ "Shield Barrier", { "!player.buff(Shield Barrier)", "player.rage >= 85" } },
		-- actions.prot+=/enraged_regeneration,if=incoming_damage_2500ms>health.max*0.1&!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up|buff.potion.up)
		{ "Enraged Regeneration", { "talent(2, 1)", "player.health <= 60", "!target.debuff(Demoralizing Shout)" } },
		{ "Enraged Regeneration", { "talent(2, 1)", "player.health <= 60", "!player.buff(Ravager Protection)" } },
		{ "Enraged Regeneration", { "talent(2, 1)", "player.health <= 60", "!player.buff(Shield Wall)" } },
		{ "Enraged Regeneration", { "talent(2, 1)", "player.health <= 60", "!player.buff(Last Stand)" } },
		{ "Enraged Regeneration", { "talent(2, 1)", "player.health <= 60", "!player.buff(Enraged Regeneration)" } },
		{ "Enraged Regeneration", { "talent(2, 1)", "player.health <= 60", "!player.buff(Shield Block)" } },
		{ "Enraged Regeneration", { "talent(2, 1)", "player.health <= 60", "!player.buff(Draenic Armor Potion)" } },
		-- actions.prot+=/demoralizing_shout,if=incoming_damage_2500ms>health.max*0.1&!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up|buff.potion.up)
		{ "Demoralizing Shout", { "player.health <= 60", "!target.debuff(Demoralizing Shout)" } },
		{ "Demoralizing Shout", { "player.health <= 60", "!player.buff(Ravager Protection)" } },
		{ "Demoralizing Shout", { "player.health <= 60", "!player.buff(Shield Wall)" } },
		{ "Demoralizing Shout", { "player.health <= 60", "!player.buff(Last Stand)" } },
		{ "Demoralizing Shout", { "player.health <= 60", "!player.buff(Enraged Regeneration)" } },
		{ "Demoralizing Shout", { "player.health <= 60", "!player.buff(Shield Block)" } },
		{ "Demoralizing Shout", { "player.health <= 60", "!player.buff(Draenic Armor Potion)" } },
		-- actions.prot+=/shield_wall,if=incoming_damage_2500ms>health.max*0.1&!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up|buff.potion.up)
		{ "Shield Wall", { "player.health <= 60", "!target.debuff(Demoralizing Shout)" } },
		{ "Shield Wall", { "player.health <= 60", "!player.buff(Ravager Protection)" } },
		{ "Shield Wall", { "player.health <= 60", "!player.buff(Shield Wall)" } },
		{ "Shield Wall", { "player.health <= 60", "!player.buff(Last Stand)" } },
		{ "Shield Wall", { "player.health <= 60", "!player.buff(Enraged Regeneration)" } },
		{ "Shield Wall", { "player.health <= 60", "!player.buff(Shield Block)" } },
		{ "Shield Wall", { "player.health <= 60", "!player.buff(Draenic Armor Potion)" } },
		-- actions.prot+=/last_stand,if=incoming_damage_2500ms>health.max*0.1&!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up|buff.potion.up)
		{ "Last Stand", { "player.health <= 60", "!target.debuff(Demoralizing Shout)" } },
		{ "Last Stand", { "player.health <= 60", "!player.buff(Ravager Protection)" } },
		{ "Last Stand", { "player.health <= 60", "!player.buff(Shield Wall)" } },
		{ "Last Stand", { "player.health <= 60", "!player.buff(Last Stand)" } },
		{ "Last Stand", { "player.health <= 60", "!player.buff(Enraged Regeneration)" } },
		{ "Last Stand", { "player.health <= 60", "!player.buff(Shield Block)" } },
		{ "Last Stand", { "player.health <= 60", "!player.buff(Draenic Armor Potion)" } },
		-- actions.prot+=/stoneform,if=incoming_damage_2500ms>health.max*0.1&!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up|buff.potion.up)
		{ "Stoneform", { "player.health <= 60", "!target.debuff(Demoralizing Shout)" } },
		{ "Stoneform", { "player.health <= 60", "!player.buff(Ravager Protection)" } },
		{ "Stoneform", { "player.health <= 60", "!player.buff(Shield Wall)" } },
		{ "Stoneform", { "player.health <= 60", "!player.buff(Last Stand)" } },
		{ "Stoneform", { "player.health <= 60", "!player.buff(Enraged Regeneration)" } },
		{ "Stoneform", { "player.health <= 60", "!player.buff(Shield Block)" } },
		{ "Stoneform", { "player.health <= 60", "!player.buff(Draenic Armor Potion)" } },
	},	{ "modifier.cooldowns", "target.exists", "target.enemy", "target.alive", "target.distance <= 5" } },

	-- ** "Non-Smart" Single Target Rotation <= 2 **
	{	{
		-- actions.prot+=/heroic_strike,if=buff.ultimatum.up|(talent.unyielding_strikes.enabled&buff.unyielding_strikes.stack>=6)
		{ "Heroic Strike", "player.buff(Ultimatum)" },
		{ "Heroic Strike", { "talent(3, 3)", "player.buff(Unyielding Strikes).count >= 6" } },
		-- actions.prot+=/bloodbath,if=talent.bloodbath.enabled&((cooldown.dragon_roar.remains=0&talent.dragon_roar.enabled)|(cooldown.storm_bolt.remains=0&talent.storm_bolt.enabled)|talent.shockwave.enabled)
		{ "Bloodbath", { "talent(6, 2)", "player.spell(Dragon Roar).cooldown == 0", "talent(4, 3)" } },
		{ "Bloodbath", { "talent(6, 2)", "player.spell(Storm Bolt).cooldown == 0", "talent(4, 1)" } },
		{ "Bloodbath", { "talent(6, 2)", "talent(4, 2)" } },
		-- actions.prot+=/avatar,if=talent.avatar.enabled&((cooldown.ravager.remains=0&talent.ravager.enabled)|(cooldown.dragon_roar.remains=0&talent.dragon_roar.enabled)|(talent.storm_bolt.enabled&cooldown.storm_bolt.remains=0)|(!(talent.dragon_roar.enabled|talent.ravager.enabled|talent.storm_bolt.enabled)))
		{ "Avatar", { "talent(6, 1)", "player.spell(Ravager).cooldown == 0", "talent(7, 2)" } },
		{ "Avatar", { "talent(6, 1)", "player.spell(Dragon Roar).cooldown == 0", "talent(4, 3)" } },
		{ "Avatar", { "talent(6, 1)", "player.spell(Storm Bolt).cooldown == 0", "talent(4, 1)" } },
		{ "Avatar", { "talent(6, 1)", "!talent(4, 3)" } },
		{ "Avatar", { "talent(6, 1)", "!talent(7, 2)" } },
		{ "Avatar", { "talent(6, 1)", "!talent(4, 1)" } },
		-- actions.prot+=/shield_slam
		{ "Shield Slam" },
		-- actions.prot+=/revenge
		{ "Revenge" },
		-- actions.prot+=/ravager
		{ "Ravager" },
		-- actions.prot+=/storm_bolt
		{ "Storm Bolt" },
		-- actions.prot+=/dragon_roar
		{ "Dragon Roar" },
		-- actions.prot+=/impending_victory,if=talent.impending_victory.enabled&cooldown.shield_slam.remains<=execute_time
		{ "Impending Victory", { "talent(2, 3)", "player.health <= 85" } },
		-- actions.prot+=/victory_rush,if=!talent.impending_victory.enabled&cooldown.shield_slam.remains<=execute_time
		{ "Victory Rush", { "!talent(2, 3)", "player.health <= 85" } },
		-- actions.prot+=/execute,if=buff.sudden_death.react
		{ "Execute", "player.buff(Sudden Death)" },
		-- actions.prot+=/devastate
		{ "Devastate" },
	},	{ "!modifier.multitarget", "!toggle.smartaoe" } },
		
	-- actions.prot+=/call_action_list,name=prot_aoe,if=active_enemies>3
		
	-- "Non-Smart" Cleave AoE Rotation >= 4
	{	{
		-- actions.prot_aoe=bloodbath
		{ "Bloodbath" },
		-- actions.prot_aoe+=/avatar
		{ "Avatar" },
		-- actions.prot_aoe+=/thunder_clap,if=!dot.deep_wounds.ticking
		{ "Thunder Clap", "!target.debuff(Deep Wounds)" },
		-- actions.prot_aoe+=/heroic_strike,if=buff.ultimatum.up|rage>110|(talent.unyielding_strikes.enabled&buff.unyielding_strikes.stack>=6)
		{ "Heroic Strike", "player.buff(Ultimatum)" },
		{ "Heroic Strike", "player.rage > 110" },
		{ "Heroic Strike", { "player.buff(Unyielding Strikes).count >=6", "talent(3, 3)" } },
		-- actions.prot_aoe+=/heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
			-- *** player controlled action only ***
		-- actions.prot_aoe+=/shield_slam,if=buff.shield_block.up
		{ "Shield Slam", "player.buff(Shield Block)" },
		-- actions.prot_aoe+=/ravager,if=(buff.avatar.up|cooldown.avatar.remains>10)|!talent.avatar.enabled
		{ "Ravager", { "talent(6, 1)", "player.buff(Avatar)" } },
		{ "Ravager", { "talent(6, 1)", "player.spell(Avatar).cooldown > 10" } },
		{ "Ravager", "!talent(6, 1)" },
		-- actions.prot_aoe+=/dragon_roar,if=(buff.bloodbath.up|cooldown.bloodbath.remains>10)|!talent.bloodbath.enabled
		{ "Dragon Roar", { "talent(6, 2)", "player.buff(Bloodbath)" } },
		{ "Dragon Roar", { "talent(6, 2)", "player.spell(Bloodbath).cooldown > 10" } },
		{ "Dragon Roar", "!talent(6, 2)" },
		-- actions.prot_aoe+=/shockwave
		{ "Shockwave" },
		-- actions.prot_aoe+=/revenge
		{ "Revenge" },
		-- actions.prot_aoe+=/thunder_clap
		{ "Thunder Clap" },
		-- actions.prot_aoe+=/bladestorm
		{ "Bladestorm" },
		-- actions.prot_aoe+=/shield_slam
		{ "Shield Slam" },
		-- actions.prot_aoe+=/storm_bolt
		{ "Storm Bolt" },
		-- actions.prot_aoe+=/shield_slam
		{ "Shield Slam" },
		-- actions.prot_aoe+=/execute,if=buff.sudden_death.react
		{ "Execute", "player.buff(Sudden Death)" },
		-- actions.prot_aoe+=/devastate
		{ "Devastate" },
	},	{ "modifier.multitarget", "!toggle.smartaoe" } },

	-- ** "Smart" Single Target Rotation <= 3 **
	{	{
		-- actions.prot+=/heroic_strike,if=buff.ultimatum.up|(talent.unyielding_strikes.enabled&buff.unyielding_strikes.stack>=6)
		{ "Heroic Strike", "player.buff(Ultimatum)" },
		{ "Heroic Strike", { "talent(3, 3)", "player.buff(Unyielding Strikes).count >= 6" } },
		-- actions.prot+=/bloodbath,if=talent.bloodbath.enabled&((cooldown.dragon_roar.remains=0&talent.dragon_roar.enabled)|(cooldown.storm_bolt.remains=0&talent.storm_bolt.enabled)|talent.shockwave.enabled)
		{ "Bloodbath", { "talent(6, 2)", "player.spell(Dragon Roar).cooldown == 0", "talent(4, 3)" } },
		{ "Bloodbath", { "talent(6, 2)", "player.spell(Storm Bolt).cooldown == 0", "talent(4, 1)" } },
		{ "Bloodbath", { "talent(6, 2)", "talent(4, 2)" } },
		-- actions.prot+=/avatar,if=talent.avatar.enabled&((cooldown.ravager.remains=0&talent.ravager.enabled)|(cooldown.dragon_roar.remains=0&talent.dragon_roar.enabled)|(talent.storm_bolt.enabled&cooldown.storm_bolt.remains=0)|(!(talent.dragon_roar.enabled|talent.ravager.enabled|talent.storm_bolt.enabled)))
		{ "Avatar", { "talent(6, 1)", "player.spell(Ravager).cooldown == 0", "talent(7, 2)" } },
		{ "Avatar", { "talent(6, 1)", "player.spell(Dragon Roar).cooldown == 0", "talent(4, 3)" } },
		{ "Avatar", { "talent(6, 1)", "player.spell(Storm Bolt).cooldown == 0", "talent(4, 1)" } },
		{ "Avatar", { "talent(6, 1)", "!talent(4, 3)" } },
		{ "Avatar", { "talent(6, 1)", "!talent(7, 2)" } },
		{ "Avatar", { "talent(6, 1)", "!talent(4, 1)" } },
		-- actions.prot+=/shield_slam
		{ "Shield Slam" },
		-- actions.prot+=/revenge
		{ "Revenge" },
		-- actions.prot+=/ravager
		{ "Ravager" },
		-- actions.prot+=/storm_bolt
		{ "Storm Bolt" },
		-- actions.prot+=/dragon_roar
		{ "Dragon Roar" },
		-- actions.prot+=/impending_victory,if=talent.impending_victory.enabled&cooldown.shield_slam.remains<=execute_time
		{ "Impending Victory", { "talent(2, 3)", "player.health <= 85" } },
		-- actions.prot+=/victory_rush,if=!talent.impending_victory.enabled&cooldown.shield_slam.remains<=execute_time
		{ "Victory Rush", { "!talent(2, 3)", "player.health <= 85" } },
		-- actions.prot+=/execute,if=buff.sudden_death.react
		{ "Execute", "player.buff(Sudden Death)" },
		-- actions.prot+=/devastate
		{ "Devastate" },
		},	{ "toggle.smartaoe", "!player.area(8)enemies >= 4" } },

	-- "Smart" Cleave AoE Rotation >= 4
	{	{
		-- actions.prot_aoe=bloodbath
		{ "Bloodbath" },
		-- actions.prot_aoe+=/avatar
		{ "Avatar" },
		-- actions.prot_aoe+=/thunder_clap,if=!dot.deep_wounds.ticking
		{ "Thunder Clap", "!target.debuff(Deep Wounds)" },
		-- actions.prot_aoe+=/heroic_strike,if=buff.ultimatum.up|rage>110|(talent.unyielding_strikes.enabled&buff.unyielding_strikes.stack>=6)
		{ "Heroic Strike", "player.buff(Ultimatum)" },
		{ "Heroic Strike", "player.rage > 110" },
		{ "Heroic Strike", { "player.buff(Unyielding Strikes).count >=6", "talent(3, 3)" } },
		-- actions.prot_aoe+=/heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
			-- *** player controlled action only ***
		-- actions.prot_aoe+=/shield_slam,if=buff.shield_block.up
		{ "Shield Slam", "player.buff(Shield Block)" },
		-- actions.prot_aoe+=/ravager,if=(buff.avatar.up|cooldown.avatar.remains>10)|!talent.avatar.enabled
		{ "Ravager", { "talent(6, 1)", "player.buff(Avatar)" } },
		{ "Ravager", { "talent(6, 1)", "player.spell(Avatar).cooldown > 10" } },
		{ "Ravager", "!talent(6, 1)" },
		-- actions.prot_aoe+=/dragon_roar,if=(buff.bloodbath.up|cooldown.bloodbath.remains>10)|!talent.bloodbath.enabled
		{ "Dragon Roar", { "talent(6, 2)", "player.buff(Bloodbath)" } },
		{ "Dragon Roar", { "talent(6, 2)", "player.spell(Bloodbath).cooldown > 10" } },
		{ "Dragon Roar", "!talent(6, 2)" },
		-- actions.prot_aoe+=/shockwave
		{ "Shockwave" },
		-- actions.prot_aoe+=/revenge
		{ "Revenge" },
		-- actions.prot_aoe+=/thunder_clap
		{ "Thunder Clap" },
		-- actions.prot_aoe+=/bladestorm
		{ "Bladestorm" },
		-- actions.prot_aoe+=/shield_slam
		{ "Shield Slam" },
		-- actions.prot_aoe+=/storm_bolt
		{ "Storm Bolt" },
		-- actions.prot_aoe+=/shield_slam
		{ "Shield Slam" },
		-- actions.prot_aoe+=/execute,if=buff.sudden_death.react
		{ "Execute", "player.buff(Sudden Death)" },
		-- actions.prot_aoe+=/devastate
		{ "Devastate" },
		},	{ "toggle.smartaoe", "player.area(8)enemies >= 4" } },
		
},	{
---- *** OUT OF COMBAT ROUTINE SECTION ***
	-- Pauses
	{ "pause", "modifier.lcontrol" },
	{ "pause", "@bbLib.pauses" },

	-- Buttons
	{ "Heroic Leap", { "modifier.lalt" }, "ground" },

	-- Buffs
	{ "Battle Shout", { "!player.buffs.attackpower", "lowest.distance <= 30", "!modifier.last" }, "lowest" },
	{ "Commanding Shout", { "!player.buffs.attackpower", "!player.buffs.stamina", "lowest.distance <= 30", "!modifier.last" }, "lowest" },

	-- OOC Healing
	{ "#118935", { "player.health < 80", "!player.ininstance(raid)" } }, -- Ever-Blooming Frond 15% health/mana every 1 sec for 6 sec. 5 min CD

	-- Mass Resurrection
	{ "Mass Resurrection", { "!player.moving", "!modifier.last", "target.exists", "target.friendly", "!target.alive", "target.distance.actual < 100" } },

	-- Auto Grinding
	{	{
		{ "Battle Shout", "@bbLib.engaugeUnit('ANY', 30, true)" },
		{ "Taunt" },
		}, { "toggle.autogrind" } },

}, -- [Section Closing Curly Brace]

---- *** TOGGLE BUTTONS ***
function()
	NetherMachine.toggle.create('mouseovers', 'Interface\\Icons\\inv_pet_lilsmoky', 'Use Mouseovers', 'Automatically cast spells on mouseover targets.')
	NetherMachine.toggle.create('autotarget', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automaticaly target the nearest enemy when target dies or does not exist.')
	NetherMachine.toggle.create('consume', 'Interface\\Icons\\inv_alchemy_endlessflask_06', 'Use Consumables', 'Toggle the usage of Flasks/Food/Potions etc..')
	NetherMachine.toggle.create('smartaoe', 'Interface\\Icons\\Ability_Racial_RocketBarrage', 'Enable Smart AoE Detection', 'Toggle the usage of smart detection of Single/AoE target roation selection abilities.')
	NetherMachine.toggle.create('limitaoe', 'Interface\\Icons\\spell_fire_flameshock', 'Limit AoE', 'Toggle to not use AoE spells to avoid breaking CC.')
	NetherMachine.toggle.create('autogrind', 'Interface\\Icons\\inv_misc_fish_33', 'Auto Attack', 'Automaticly target and attack nearby enemies.')
end)

-- actions.precombat=flask,type=greater_draenic_stamina_flask
-- actions.precombat+=/food,type=sleeper_sushi
-- actions.precombat+=/stance,choose=defensive
-- actions.precombat+=/snapshot_stats
-- actions.precombat+=/shield_wall
-- actions.precombat+=/potion,name=draenic_armor
