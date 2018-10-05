
OneRing_Config = {
	["CenterActions"] = {
		["Disrupt"] = "ABue3VjFJrl",
	},
	["CharProfiles"] = {
		["Kel'Thuzad-Fistbeavers-3"] = "default",
		["Kel'Thuzad-Twiddlederr"] = "default",
	},
	["_GameVersion"] = "8.0.1",
	["_OPieVersion"] = "Vanilla 7 (3.93)",
	["ProfileStorage"] = {
		["default"] = {
			["ClickActivation"] = true,
			["SliceBinding"] = true,
			["Bindings"] = {
				["RaidSymbols"] = false,
				["DruidUtility"] = false,
				["CommonTrades"] = false,
				["DruidShift"] = false,
				["SpecMenu"] = false,
				["DruidFeral"] = false,
			},
			["XTScaleSpeed"] = 4,
			["MISpinOnHide"] = false,
			["XTRotationPeriod"] = 10,
			["XTZoomTime"] = 0,
			["XTPointerSpeed"] = 4,
			["IndicationOffsetX"] = 150,
			["ShowCooldowns"] = true,
			["CenterAction"] = true,
			["RingOptions"] = {
				["RaidSymbols#SliceBinding"] = true,
			},
			["IndicationOffsetY"] = -150,
			["ShowRecharge"] = true,
		},
	},
	["PersistentStorage"] = {
		["RingKeeper"] = {
			["SpecMenu"] = {
				{
					"specset", -- [1]
					1, -- [2]
					["sliceToken"] = "OPCTA1",
				}, -- [1]
				{
					"specset", -- [1]
					2, -- [2]
					["sliceToken"] = "OPCTA2",
				}, -- [2]
				{
					"specset", -- [1]
					3, -- [2]
					["sliceToken"] = "OPCTA3",
				}, -- [3]
				{
					"specset", -- [1]
					4, -- [2]
					["sliceToken"] = "OPCTA4",
				}, -- [4]
				{
					["sliceToken"] = "OPCTAc",
					["id"] = "/cast {{spell:50977}}; {{spell:193753}}; {{spell:126892}}; {{spell:193759}}",
				}, -- [5]
				{
					"item", -- [1]
					110560, -- [2]
					["sliceToken"] = "OPCTAg",
				}, -- [6]
				{
					"item", -- [1]
					140192, -- [2]
					["sliceToken"] = "OPCTAd",
				}, -- [7]
				{
					"item", -- [1]
					6948, -- [2]
					["sliceToken"] = "OPCTAh",
				}, -- [8]
				{
					"toy", -- [1]
					64488, -- [2]
					["sliceToken"] = "OPCTAi",
				}, -- [9]
				{
					"item", -- [1]
					141605, -- [2]
					["sliceToken"] = "ABue3VjFJrX",
				}, -- [10]
				["name"] = "Specializations and Travel",
				["save"] = true,
				["hotkey"] = "ALT-H",
			},
			["Disarm"] = {
				{
					"macro", -- [1]
					"Disarm1", -- [2]
					["show"] = "[@arena1,exists]",
					["sliceToken"] = "ABuedpFdSbp",
				}, -- [1]
				{
					"macro", -- [1]
					"Disarm2", -- [2]
					["show"] = "[@arena2,exists]",
					["sliceToken"] = "ABuedpFdSbo",
				}, -- [2]
				{
					"macro", -- [1]
					"Disarm3", -- [2]
					["show"] = "[@arena3,exists]",
					["sliceToken"] = "ABuedpFdSb2",
				}, -- [3]
				{
					"macro", -- [1]
					"DisarmMO", -- [2]
					["sliceToken"] = "ABuedpFdSbi",
				}, -- [4]
				["save"] = true,
				["name"] = "Disarm",
				["limit"] = "Fistbeavers-Kel'Thuzad",
			},
			["Shifts"] = {
				{
					["sliceToken"] = "ABuedaTVKtr",
					["id"] = 783,
				}, -- [1]
				{
					["sliceToken"] = "ABuedablyZp",
					["id"] = 768,
				}, -- [2]
				{
					["sliceToken"] = "ABuedablyZo",
					["id"] = 5487,
				}, -- [3]
				{
					["sliceToken"] = "ABuedablyZd",
					["id"] = 197625,
				}, -- [4]
				{
					["sliceToken"] = "ABuedablyZ2",
					["id"] = 114282,
				}, -- [5]
				["name"] = "Shifts",
				["save"] = true,
				["limit"] = "Eyebrowse-Kel'Thuzad",
			},
			["BGs"] = {
				{
					["sliceToken"] = "ABuediQ29St",
					["id"] = 195710,
				}, -- [1]
				{
					["id"] = 59752,
					["sliceToken"] = "ABuediQ29S1",
				}, -- [2]
				{
					"item", -- [1]
					109076, -- [2]
					["sliceToken"] = "ABuede6=dW1",
				}, -- [3]
				{
					"item", -- [1]
					153490, -- [2]
					["sliceToken"] = "ABue3/fRvWf",
				}, -- [4]
				{
					"item", -- [1]
					138486, -- [2]
					["sliceToken"] = "ABue3/fRvWd",
				}, -- [5]
				{
					"item", -- [1]
					138727, -- [2]
					["sliceToken"] = "ABue3/fRvW3",
				}, -- [6]
				{
					"item", -- [1]
					138478, -- [2]
					["sliceToken"] = "ABue3/fRvWs",
				}, -- [7]
				{
					"item", -- [1]
					138488, -- [2]
					["sliceToken"] = "ABue3/fRvWa",
				}, -- [8]
				["name"] = "PVP",
				["save"] = true,
			},
			["RaidSymbols"] = {
				{
					"raidmark", -- [1]
					8, -- [2]
					["sliceToken"] = "OPCRSw",
				}, -- [1]
				{
					"raidmark", -- [1]
					7, -- [2]
					["sliceToken"] = "OPCRSr",
				}, -- [2]
				{
					"raidmark", -- [1]
					2, -- [2]
					["sliceToken"] = "OPCRSo",
				}, -- [3]
				{
					"raidmark", -- [1]
					6, -- [2]
					["sliceToken"] = "OPCRSb",
				}, -- [4]
				{
					"raidmark", -- [1]
					1, -- [2]
					["sliceToken"] = "OPCRSy",
				}, -- [5]
				{
					"raidmark", -- [1]
					3, -- [2]
					["sliceToken"] = "OPCRSp",
				}, -- [6]
				{
					"raidmark", -- [1]
					4, -- [2]
					["sliceToken"] = "OPCRSg",
				}, -- [7]
				{
					"raidmark", -- [1]
					5, -- [2]
					["sliceToken"] = "OPCRSs",
				}, -- [8]
				{
					"raidmark", -- [1]
					0, -- [2]
					["sliceToken"] = "OPCRSc",
				}, -- [9]
				["name"] = "Target Markers",
				["save"] = true,
				["hotkey"] = "ALT-R",
			},
			["Buffs"] = {
				{
					"item", -- [1]
					160053, -- [2]
					["sliceToken"] = "ABuedrxG0nf",
				}, -- [1]
				{
					"item", -- [1]
					120257, -- [2]
					["sliceToken"] = "ABuedrxG0nd",
				}, -- [2]
				{
					"item", -- [1]
					154167, -- [2]
					["sliceToken"] = "ABued2w6wRe",
				}, -- [3]
				{
					"item", -- [1]
					142406, -- [2]
					["sliceToken"] = "ABueda8IHUe",
				}, -- [4]
				{
					"item", -- [1]
					158201, -- [2]
					["sliceToken"] = "ABueds3Srxu",
				}, -- [5]
				{
					"item", -- [1]
					158202, -- [2]
					["sliceToken"] = "ABueds3Srxy",
				}, -- [6]
				{
					"item", -- [1]
					158204, -- [2]
					["sliceToken"] = "ABueds3Srxi",
				}, -- [7]
				{
					"item", -- [1]
					152639, -- [2]
					["sliceToken"] = "ABued4la3ie",
				}, -- [8]
				["name"] = "Buffs",
				["save"] = true,
			},
			["Res"] = {
				{
					["sliceToken"] = "ABueddABZUy",
					["id"] = 20484,
				}, -- [1]
				{
					["sliceToken"] = "ABuedghY301",
					["id"] = 212040,
				}, -- [2]
				{
					["sliceToken"] = "ABueddABZUt",
					["id"] = 50769,
				}, -- [3]
				{
					["id"] = 115178,
					["sliceToken"] = "ABuediQ29Si",
				}, -- [4]
				{
					["id"] = 212051,
					["sliceToken"] = "ABuediQ29Su",
				}, -- [5]
				["name"] = "Res",
				["save"] = true,
			},
			["FuckOff"] = {
				{
					"item", -- [1]
					6948, -- [2]
					["sliceToken"] = "ABuedsRZ0wm",
				}, -- [1]
				{
					"item", -- [1]
					140192, -- [2]
					["sliceToken"] = "ABuedsRZ0wn",
				}, -- [2]
				{
					"item", -- [1]
					141605, -- [2]
					["sliceToken"] = "ABuedsRZ0w6",
				}, -- [3]
				{
					["sliceToken"] = "ABuedsRZ0wb",
					["id"] = 193753,
				}, -- [4]
				["limit"] = "Eyebrowse-Kel'Thuzad",
				["save"] = true,
				["name"] = "FuckOff",
			},
			["Imprison"] = {
				{
					"macro", -- [1]
					"CC1", -- [2]
					["sliceToken"] = "ABue3VjFJrI",
				}, -- [1]
				{
					"macro", -- [1]
					"CC2", -- [2]
					["sliceToken"] = "ABue3VjFJr8",
				}, -- [2]
				{
					"macro", -- [1]
					"CC3", -- [2]
					["sliceToken"] = "ABue3VjFJrU",
				}, -- [3]
				{
					["id"] = 217832,
					["sliceToken"] = "ABue3VjFJrY",
				}, -- [4]
				{
					"macro", -- [1]
					"CC MO", -- [2]
					["sliceToken"] = "ABue3VjFJrT",
				}, -- [5]
				["save"] = true,
				["limit"] = "Twiddlederr-Kel'Thuzad",
				["name"] = "Imprison",
			},
			["Potions"] = {
				{
					"item", -- [1]
					152494, -- [2]
					["sliceToken"] = "ABuedtmTCzu",
				}, -- [1]
				{
					"item", -- [1]
					152497, -- [2]
					["sliceToken"] = "ABuedtmTCzy",
				}, -- [2]
				{
					"item", -- [1]
					152503, -- [2]
					["sliceToken"] = "ABuedtmTCzt",
				}, -- [3]
				{
					"item", -- [1]
					152495, -- [2]
					["sliceToken"] = "ABued24Vc61",
				}, -- [4]
				{
					"item", -- [1]
					163082, -- [2]
					["sliceToken"] = "ABued24Vc6r",
				}, -- [5]
				{
					"item", -- [1]
					152560, -- [2]
					["sliceToken"] = "ABuedoUBkqe",
				}, -- [6]
				{
					"item", -- [1]
					152561, -- [2]
					["sliceToken"] = "ABuedgJ=vKe",
				}, -- [7]
				["name"] = "Potions",
				["save"] = true,
			},
			["Specs"] = {
				{
					"specset", -- [1]
					4, -- [2]
					["sliceToken"] = "ABuedsRZ0wp",
				}, -- [1]
				{
					"specset", -- [1]
					2, -- [2]
					["sliceToken"] = "ABuedsRZ0wo",
				}, -- [2]
				{
					"specset", -- [1]
					3, -- [2]
					["sliceToken"] = "ABuedsRZ0w2",
				}, -- [3]
				{
					"specset", -- [1]
					1, -- [2]
					["sliceToken"] = "ABuedsRZ0wi",
				}, -- [4]
				["limit"] = "Eyebrowse-Kel'Thuzad",
				["save"] = true,
				["name"] = "Specs",
			},
			["Incap"] = {
				{
					"macro", -- [1]
					"CC1", -- [2]
					["show"] = "[@arena1,exists]",
					["sliceToken"] = "ABuedpyZc2x",
				}, -- [1]
				{
					"macro", -- [1]
					"CC2", -- [2]
					["show"] = "[@arena2,exists]",
					["sliceToken"] = "ABuedpyZc25",
				}, -- [2]
				{
					"macro", -- [1]
					"CC3", -- [2]
					["show"] = "[@arena3,exists]",
					["sliceToken"] = "ABuedpyZc2z",
				}, -- [3]
				{
					"macro", -- [1]
					"CC MO", -- [2]
					["sliceToken"] = "ABuedpyZc2l",
					["fastClick"] = true,
				}, -- [4]
				["save"] = true,
				["name"] = "Incap",
				["limit"] = "Fistbeavers-Kel'Thuzad",
			},
			["Disrupt"] = {
				{
					"macro", -- [1]
					"Interrupt1", -- [2]
					["sliceToken"] = "ABue3VjFJrc",
				}, -- [1]
				{
					"macro", -- [1]
					"Interrupt2", -- [2]
					["sliceToken"] = "ABue3VjFJrx",
				}, -- [2]
				{
					"macro", -- [1]
					"Interrupt3", -- [2]
					["sliceToken"] = "ABue3VjFJr5",
				}, -- [3]
				{
					["id"] = 183752,
					["sliceToken"] = "ABue3VjFJrl",
					["fastClick"] = true,
				}, -- [4]
				{
					"macro", -- [1]
					"D MO", -- [2]
					["sliceToken"] = "ABue3VjFJrz",
				}, -- [5]
				["name"] = "Disrupt",
				["save"] = true,
			},
			["DruidShift"] = {
				{
					["show"] = "[known:783]",
					["sliceToken"] = "OPCDSf",
					["id"] = "/cancelform [noflyable,noform:moonkin]\n/cast [flyable,outdoors,nocombat,noswimming,nomod][flying] {{spell:783}}; [outpost:corral,nomod,nospec:103/104] {{spell:161691}}; [swimming,nomod][flyable,nomod][flying] {{spell:783}}; [nocombat,outdoors,nomod:alt] {{mount:ground}}; [outdoors] {{spell:783}}",
				}, -- [1]
				{
					["sliceToken"] = "OPCDSk",
					["c"] = "c74cff",
					["id"] = 24858,
				}, -- [2]
				{
					["sliceToken"] = "OPCDSc",
					["c"] = "fff04d",
					["id"] = 768,
				}, -- [3]
				{
					["sliceToken"] = "OPCDSb",
					["c"] = "ff0000",
					["id"] = 5487,
				}, -- [4]
				["name"] = "Shapeshifts",
				["save"] = true,
				["hotkey"] = "BUTTON4",
				["limit"] = "DRUID",
			},
			["Profs1"] = {
				{
					["id"] = 195116,
					["sliceToken"] = "ABuedsUpZgl",
				}, -- [1]
				{
					["id"] = 2108,
					["sliceToken"] = "ABuedsUpZgk",
				}, -- [2]
				{
					["id"] = 2259,
					["sliceToken"] = "ABuedsF1eFf",
				}, -- [3]
				{
					["id"] = 45357,
					["sliceToken"] = "ABuedsF1eF3",
				}, -- [4]
				{
					["id"] = 51005,
					["sliceToken"] = "ABuedsF1eFd",
				}, -- [5]
				{
					["id"] = 31252,
					["sliceToken"] = "ABuedsUpZgj",
				}, -- [6]
				{
					["id"] = 195128,
					["sliceToken"] = "ABuedsUpZg4",
				}, -- [7]
				{
					["id"] = 195127,
					["sliceToken"] = "ABuedsUpZgh",
				}, -- [8]
				{
					["id"] = 80451,
					["sliceToken"] = "ABuedsUpZgg",
				}, -- [9]
				["name"] = "Profs",
				["save"] = true,
			},
			["OPieFlagStore"] = {
				["FlushedDefaultColors"] = true,
			},
			["Mounts"] = {
				{
					["sliceToken"] = "ABue3Nac4Qu",
					["id"] = 223578,
				}, -- [1]
				{
					["sliceToken"] = "ABue3Nac4Qy",
					["id"] = 274610,
				}, -- [2]
				{
					["sliceToken"] = "ABue3Nac4Qt",
					["id"] = 61425,
				}, -- [3]
				{
					["sliceToken"] = "ABuedwH3D2e",
					["id"] = 278803,
				}, -- [4]
				["name"] = "Mounts",
				["save"] = true,
			},
			["nsumeMagic"] = {
				{
					"macro", -- [1]
					"ConsumeMagic1", -- [2]
					["sliceToken"] = "ABue3VjFJrZ",
				}, -- [1]
				{
					"macro", -- [1]
					"ConsumeMagic2", -- [2]
					["sliceToken"] = "ABue3VjFJr=",
				}, -- [2]
				{
					"macro", -- [1]
					"ConsumeMagic3e", -- [2]
					["sliceToken"] = "ABue3VjFJrL",
				}, -- [3]
				{
					["id"] = 278326,
					["sliceToken"] = "ABue3VjFJrK",
				}, -- [4]
				{
					"macro", -- [1]
					"P MO", -- [2]
					["sliceToken"] = "ABue3VjFJrJ",
				}, -- [5]
				["name"] = "ConsumeMagic",
				["save"] = true,
			},
			["IslandExp"] = {
				{
					"item", -- [1]
					163768, -- [2]
					["sliceToken"] = "ABue3Bo=xE1",
				}, -- [1]
				{
					"item", -- [1]
					163770, -- [2]
					["sliceToken"] = "ABue3Bo=xEr",
				}, -- [2]
				{
					"item", -- [1]
					163769, -- [2]
					["sliceToken"] = "ABue3BGoqv1",
				}, -- [3]
				{
					"item", -- [1]
					163771, -- [2]
					["sliceToken"] = "ABue3BGoqvr",
				}, -- [4]
				{
					"item", -- [1]
					151114, -- [2]
					["sliceToken"] = "ABuedwFyGAe",
				}, -- [5]
				{
					"item", -- [1]
					144430, -- [2]
					["sliceToken"] = "ABuedwLLEQe",
				}, -- [6]
				{
					"item", -- [1]
					163754, -- [2]
					["sliceToken"] = "ABued1KdNAu",
				}, -- [7]
				{
					"item", -- [1]
					163753, -- [2]
					["sliceToken"] = "ABued1KdNAy",
				}, -- [8]
				{
					"item", -- [1]
					163755, -- [2]
					["sliceToken"] = "ABued1KdNAt",
				}, -- [9]
				{
					"item", -- [1]
					163760, -- [2]
					["sliceToken"] = "ABuedpFdSb3",
				}, -- [10]
				{
					"item", -- [1]
					163759, -- [2]
					["sliceToken"] = "ABuedpFdSbs",
				}, -- [11]
				{
					"item", -- [1]
					163761, -- [2]
					["sliceToken"] = "ABuedpFdSbd",
				}, -- [12]
				{
					"item", -- [1]
					160105, -- [2]
					["sliceToken"] = "ABueddlkIUe",
				}, -- [13]
				{
					"item", -- [1]
					160106, -- [2]
					["sliceToken"] = "ABueddlkIUr",
				}, -- [14]
				["name"] = "IslandExp",
				["save"] = true,
			},
			["Fishing"] = {
				{
					["id"] = 131474,
					["sliceToken"] = "ABuedqpZMtt",
				}, -- [1]
				{
					"item", -- [1]
					136377, -- [2]
					["sliceToken"] = "ABuedqpZMt1",
				}, -- [2]
				{
					"item", -- [1]
					6532, -- [2]
					["sliceToken"] = "ABuedekjY/o",
				}, -- [3]
				{
					"equipmentset", -- [1]
					"Fishing", -- [2]
					["sliceToken"] = "ABuedekjY/2",
				}, -- [4]
				{
					"equipmentset", -- [1]
					"Havoc", -- [2]
					["sliceToken"] = "ABuedekjY/i",
				}, -- [5]
				{
					"item", -- [1]
					6533, -- [2]
					["sliceToken"] = "ABuede6=dWe",
				}, -- [6]
				["name"] = "Fishing",
				["save"] = true,
			},
			["MonkDmg"] = {
				{
					["id"] = 117952,
					["sliceToken"] = "ABuedivYhU1",
				}, -- [1]
				{
					["id"] = 101546,
					["sliceToken"] = "ABuedivYhUr",
				}, -- [2]
				["save"] = true,
				["name"] = "MonkDmg",
				["limit"] = "Fistbeavers-Kel'Thuzad",
			},
			["Roots"] = {
				{
					"macro", -- [1]
					"root1", -- [2]
					["show"] = "[@arena1, exists][instance:arena]",
					["sliceToken"] = "ABueddIlle2",
				}, -- [1]
				{
					"macro", -- [1]
					"root2", -- [2]
					["show"] = "[@arena2, exists][instance:arena]",
					["sliceToken"] = "ABueddIlleo",
				}, -- [2]
				{
					"macro", -- [1]
					"root3", -- [2]
					["show"] = "[@arena3, exists][instance:arena]",
					["sliceToken"] = "ABueddIllei",
				}, -- [3]
				{
					"macro", -- [1]
					"rootMo", -- [2]
					["sliceToken"] = "ABueddIlle3",
				}, -- [4]
				["limit"] = "Eyebrowse-Kel'Thuzad",
				["save"] = true,
				["name"] = "Roots",
			},
			["Cyclone"] = {
				{
					"macro", -- [1]
					"CC1", -- [2]
					["show"] = "[@arena1, exists][instance:arena]",
					["sliceToken"] = "ABuedsG3ekp",
				}, -- [1]
				{
					"macro", -- [1]
					"CC2", -- [2]
					["show"] = "[@arena2, exists][instance:arena]",
					["sliceToken"] = "ABuedsG3eko",
				}, -- [2]
				{
					"macro", -- [1]
					"CC3", -- [2]
					["show"] = "[@arena3, exists][instance:arena]",
					["sliceToken"] = "ABuedsG3ek2",
				}, -- [3]
				{
					"macro", -- [1]
					"CCMO", -- [2]
					["sliceToken"] = "ABuedsG3eki",
				}, -- [4]
				["name"] = "Cyclone",
				["save"] = true,
				["limit"] = "Eyebrowse-Kel'Thuzad",
			},
		},
	},
	["_GameLocale"] = "enUS",
}
