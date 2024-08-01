unit Skill_Constants;

(*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*
Skill_Constants
2004/06/03 ChrstphrR - started

--
Overview:
--
Skill Constants so that we're not staring at 411 different numbers.
The "" field of skill_db.txt is what the constant names are based off of,
which will give a better common ground for fixing skill errors / omissions
when users report them.

--
Revisions:
--
2004/06/03 - Created

*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*)


interface

const
	//Novice
	NV_BASIC = 1; //Basic_Skills

	//Swordsman Skills
	SM_SWORD    = 2; //Sword_Mastery
	SM_TWOHAND  = 3; //Two-Handed_Sword_Mastery
	SM_RECOVERY = 4; //HP_Recovery
	SM_BASH     = 5; //Bash
	SM_PROVOKE  = 6; //Provoke
	SM_MAGNUM   = 7; //Magnum_Break
	SM_ENDURE   = 8; //Endure

	//Mage Skills
	MG_SRECOVERY     =  9; //SP_Recovery
	MG_SIGHT         = 10; //Sight
	MG_NAPALMBEAT    = 11; //Napalm_Beat
	MG_SAFETYWALL    = 12; //Safety_Wall
	MG_SOULSTRIKE    = 13; //Soul_Strike
	MG_COLDBOLT      = 14; //Cold_Bolt
	MG_FROSTDIVER    = 15; //Frost_Driver
	MG_STONECURSE    = 16; //Stone_Curse
	MG_FIREBALL      = 17; //Fire_Ball
	MG_FIREWALL      = 18; //Fire_Wall
	MG_FIREBOLT      = 19; //Fire_Bolt
	MG_LIGHTNINGBOLT = 20; //Lightning_Bolt
	MG_THUNDERSTORM  = 21; //Thunder_Storm

	//Acolyte Skills
	AL_DP        = 22; //Divine_Protection
	AL_DEMONBANE = 23; //Demon_Bane
	AL_RUWACH    = 24; //Ruwatch
	AL_PNEUMA    = 25; //Pneuma
	AL_TELEPORT  = 26; //Teleportation
	AL_WARP      = 27; //Warp_Portal
	AL_HEAL      = 28; //Heal
	AL_INCAGI    = 29; //Increase_Agility
	AL_DECAGI    = 30; //Decrease_Agility
{
31,AL_HOLYWATER,Aqua_Benedicta
32,AL_CRUCIS,Signum_Crucis
33,AL_ANGELUS,Angelus
34,AL_BLESSING,Blessing
35,AL_CURE,Cure
}
	//Merchant Skills
	MC_INCCARRY   = 36; //Enlarge_Weight_Limit
	MC_DISCOUNT   = 37; //Discount
	MC_OVERCHARGE = 38; //Overcharge
	MC_PUSHCART   = 39; //Pushcart
	MC_IDENTIFY   = 40; //Identify
	MC_VENDING    = 41; //Vending
	MC_MAMMONITE  = 42; //Mammonite

	//Archer Skills
	AC_OWL           = 43; //Owl's_Eye
	AC_VULTURE       = 44; //Vulture's_Eye
	AC_CONCENTRATION = 45; //Improve_Concentration
	AC_DOUBLE        = 46; //Double_Strafing
	AC_SHOWER        = 47; //Arrow_Shower

//Thief Skills
	TF_DOUBLE   = 48; //Double_Attack (Passive)
	TF_MISS     = 49; //Increase_Dodge (Passive)
	TF_STEAL    = 50; //Steal
	TF_HIDING   = 51; //Hiding
	TF_POISON   = 52; //Envenom
	TF_DETOXIFY = 53; //Detoxify

	//Classless Skill
	ALL_RESURRECTION = 54; //Resurrection

	//Knight Skills
	KN_SPEARMASTERY    = 55; //Spear_Mastery
	KN_PIERCE          = 56; //Pierce
	KN_BRANDISHSPEAR   = 57; //Brandish_Spear
	KN_SPEARSTAB       = 58; //Spear_Stab
	KN_SPEARBOOMERANG  = 59; //Spear_Boomerang
	KN_TWOHANDQUICKEN  = 60; //Two-Hand_Quicken
	KN_AUTOCOUNTER     = 61; //Auto_Counter
	KN_BOWLINGBASH     = 62; //Bowling_Bash
	KN_RIDING          = 63; //Riding
	KN_CAVALIERMASTERY = 64; //Cavalry_Mastery

{
}

	//High Wizard Skills
	HW_MAGICCRASHER = 365; //Magic_Crasher




implementation

end.
