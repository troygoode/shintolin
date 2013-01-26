[{
  :stick =>
  {:id => 1,
    :name => 'stick',
    :plural => 'sticks',
    :desc => 'a sturdy wooden stick',
    :weight => 1,
    
    :use => :weapon,
    :break_odds => 10,
    :accuracy => 25,
    :effect => 1,
    :weapon_class => :blunt,
    
    :craftable => true,
    :craft_ap => 6,
    :craft_xp => 3,
    :craft_amount => 6,
    :materials => {:log => 1},
    :tools => [:stone_axe],
    
    :Autumn => 0.8,
    :Winter => 0.7
  },
  
  :stone =>
  {:id => 2,
    :name => 'stone',
    :plural => 'stones',
    :desc => 'a good-sized stone',
    :use => :weapon,
    :weight => 2,
    :break_odds => 2,
    :accuracy => 15,
    :effect => 1,
    :weapon_class => :blunt,
  },
  
  :thyme =>
  {:id => 3,
    :name => 'thyme sprig',
    :plural => 'thyme sprigs',
    :desc => 'a sprig of thyme, good for healing',
    :use => :heal,
    :effect => {:default => 5, :herb_lore => 7},
    :weight => 0,
    :Autumn => 0.7,
    :Winter => 0.5
  },
  
  :bark =>
  {:id => 4,
    :name => 'piece of willow bark',
    :plural => 'pieces of willow bark',
    :desc => 'some willow bark, good for healing',
    :use => "Using the willow bark doesn't seem to have any effect. Perhaps it would be more useful if combined with something else",
    :weight => 0,
    :Autumn => 0.7,
    :Winter => 0.5
  },
  
  :poultice =>
  {:id => 5,
    :name => 'herbal poultice',
    :plural => 'herbal poultices',
    :desc => 'a herbal poultice, for reviving',
    :use => :revive,
    :effect => 5,
    :weight => 0,
    :craftable => true,
    :craft_ap => 10,
    :craft_xp => 5,
    :craft_xp_type => :herbal,
    :materials => {:thyme => 5, :bark => 2}
  },
  
  :flint =>
  {:id => 6,
    :name => 'flint',
    :plural => 'flints',
    :desc => 'a good-sized piece of flint',
    
    :weight => 2,
  },
  
  :hand_axe =>
  {:id => 7,
    :name => 'hand axe',
    :plural => 'hand axes',
    :desc => 'a hand axe',
    :use => :weapon,
    :weight => 2,
    :break_odds => 2,
    :accuracy => {:default => 15, :axe1 => 20, :axe2 => 30, :axe4 => 40},
    :effect => {:default => 2, :axe3 => 3},
    :weapon_class => :slash,
    :craftable => true,
    :craft_ap => 10,
    :craft_xp => 10,
    :tools => [:stone],
    :materials => {:flint => 1}
  },
  
  :stone_axe =>
  {:id => 8,
    :name => 'stone axe',
    :plural => 'stone axes',
    :desc => 'a stone axe',
    :use => :weapon,
    :break_odds => 2,
    :weapon_class => :slash,
    :accuracy => {:default => 20, :axe2 => 30, :axe4 => 40},
    :effect => {:default => 2, :axe1 => 3, :axe3 => 4},
    :weight => 3,
    :craftable => true,
    :craft_ap => 10,
    :craft_xp => 5,
    :craft_skill => :hafting,
    :materials => {:hand_axe => 1, :stick => 1}
  },
  
  :staff =>
  {:id => 9,
    :name => 'staff',
    :plural => 'staves',
    :desc => 'a stout wooden staff',
    :use => :weapon,
    :break_odds => 5,
    :accuracy => 25,
    :effect => 2,
    :weapon_class => :blunt,
    :weight => 3,
    
    :craftable => true,
    :craft_ap => 12,
    :craft_xp => 5,
    :craft_amount => 3,
    :materials => {:log => 1},
    :tools => [:stone_carpentry],
    :craft_skill => :carpentry,
    
    :Autumn => 0.8,
    :Winter => 0.7
  },
  
  :stone_spear =>
  {:id => 10,
    :name => 'stone spear',
    :plural => 'stone spears',
    :desc => 'a stone spear',
    :use => :weapon,
    :weight => 5,
    :break_odds => 2,
    :weapon_class => :stab,
    
    :accuracy => {:default => 30, :spear2 => 40, :spear4 => 50},
    :effect => {:default => 2, :spear1 => 3, :spear3 => 4},
    :craftable => true,
    :craft_ap => 10,
    :craft_xp => 10,
    :craft_skill => :hafting,
    :materials => {:hand_axe => 1, :staff => 1}
  },
  
  :chestnut =>
  {:id => 11,
    :name => 'handful of chestnuts',
    :plural => 'handfuls of chestnuts',
    :desc => 'a handful of chestnuts',
    :use => :food,
    :weight => 1,
    :Autumn => 1.3,
    :Winter => 0.5
  },
  
  :onion =>
  {:id => 12,
    :name => 'wild onion',
    :plural => 'wild onions',
    :desc => 'a pungent wild onion',
    :use => :food,
    :weight => 1,
    :Autumn => 0.7,
    :Winter => 0.5
  },
  
  :tea =>
  {:id => 13,
    :name => 'cup of herbal tea',
    :plural => 'cups of herbal tea',
    :desc => 'a fragrant cup of herbal tea, for reviving',
    :use => :revive,
    :effect => 20,
    :weight => 1,
    :craftable => true,
    :craft_ap => 10,
    :craft_xp => 5,
    :craft_xp_type => :herbal,
    :craft_building => :campfire,
    :craft_skill => :tea_making,
    :materials => {:thyme => 2, :bark => 2}
  },
  
  :digging_stick =>
  {:id => 14,
    :name => 'digging stick',
    :plural => 'digging sticks',
    :desc => 'a sharpened stick for digging',
    :weight => 1,
    :break_odds => 12,
    :craftable => true,
    :craft_ap => 5,
    :craft_xp => 3,
    :craft_building => :campfire,
    :tools => [:hand_axe],
    :materials => {:stick => 1}
  },
  
  :log =>
  {:id => 15,
    :name => 'log',
    :plural => 'logs',
    :desc => 'a heavy wooden log',
    
    :weight => 12,
  },
  
  :raw_meat =>
  {:id => 16,
    :name => 'hunk of raw meat',
    :plural => 'hunks of raw meat',
    :desc => 'a hunk of raw meat',
    :use => 'You must cook the meat before it can be eaten.',
    :weight => 1,
  },
  
  :pelt =>
  {:id => 17,
    :name => 'pelt',
    :plural => 'pelts',
    :desc => 'an animal\'s hide',
    
    :weight => 4,
  },
  
  :cooked_meat =>
  {:id => 18,
    :name => 'hunk of cooked meat',
    :plural => 'hunks of cooked meat',
    :desc => 'a hunk of cooked meat',
    :use => :food,
    :weight => 1,
    :craftable => true,
    :craft_ap => 1,
    :craft_xp => 0.3,
    :craft_xp_type => :wander,
    :craft_building => :campfire,
    :materials => {:raw_meat => 1}
  },
  
  :stone_carpentry =>
  {:id => 19,
    :name => 'set of stone carpentry tools',
    :plural => 'sets of stone carpentry tools',
    :desc => 'a set of stone carpentry tools, including an adze, saw and lathe',
    
    :weight => 8,
    :break_odds => 4,
    :craftable => true,
    :craft_ap => 15,
    :craft_xp => 15,
    :craft_skill => :carpentry,
    :materials => {:hand_axe => 4, :stick => 4}
  },
  
  :timber =>
  {:id => 20,
    :name => 'plank of timber',
    :plural => 'planks of timber',
    :desc => 'a carved wooden plank, for construction',
    
    :weight => 3,
    
    :craftable => true,
    :craft_ap => 12,
    :craft_xp => 5,
    :craft_amount => 3,
    :materials => {:log => 1},
    :tools => [:stone_carpentry],
    :craft_skill => :carpentry,
  },
  
  :wheat =>
  {:id => 21,
    :name => 'handful of wheat',
    :plural => 'handfuls of wheat',
    :desc => 'some wheat',
    :use => :food,
    :plantable => true,
    :weight => 1,
    :Autumn => 0.5,
    :Winter => 0
  },
  
  :stone_sickle =>
  {:id => 22,
    :name => 'stone sickle',
    :plural => 'stone sickles',
    :desc => 'a stone sickle',
    
    :weight => 2,
    :break_odds => 2,
    :craftable => true,
    :craft_ap => 10,
    :craft_xp => 10,
    :craft_skill => :carpentry,
    :craft_building => :workshop,
    :tools => [:stone_carpentry],
    :materials => {:hand_axe => 1, :stick => 1}
  },
  
  :noobcake =>
  {:id => 23,
    :name => 'noobcake',
    :plural => 'noobcakes',
    :desc => 'a cake decorated with a picture of a cuddly bear surrounded by pink hearts',
    :use => :noobcake,
    :weight => 1,
  },
  
  :fist =>
  {:id => 24,
    :name => 'fist',
    :plural => 'fists',
    :use => :weapon,
    :break_odds => 0,
    
    :weapon_class => :blunt,
    :weight => 0,
    
    :accuracy => {:default => 10, :unarmed1 => 20, :unarmed3 => 30},
    :effect => {:default => 1, :unarmed2 => 2, :unarmed4 => 3},
  },
  
  :test_weapon =>
  {:id => 25,
    :name => 'hammer of the gods',
    :desc => 'And I will punish the world for their evil, and the wicked for their iniquity; and I will cause the arrogance of the proud to cease, and will lay low the haughtiness of the terrible',
    :plural => 'hammers of the gods',
    :effect => 10,
    :weight => 1,
    :use => :weapon,
    :accuracy => 100,
    :weapon_class => :blunt,
    :break_odds => 0,
  },
  
  :sabre_tooth =>
  {:id => 26,
    :name => 'sabre tooth',
    :plural => 'sabre teeth',
    :use => :weapon,
    :weapon_class => :stab,
    :desc => "a curved yellow fang, as long as a man's forearm",
    :weight => 2,
    :break_odds => 5,
    :accuracy => 25,
    :effect => 3,
  },
  
  :test_weapon2 =>
  {:id => 27,
    :name => 'unusable test weapon',
    :desc => 'unusable test weapon',
    :plural => 'unusable test weapon',
    :effect => 10,
    :weight => 1,
    :use => :weapon,
    :accuracy => 0,
    :weapon_class => :stab,
    :break_odds => 0,
  },
  
  :small_pelt =>
  {:id => 28,
    :name => 'small pelt',
    :plural => 'small pelts',
    :desc => 'the hide of a small animal',
    :weight => 2,
  },
  
  :wolf_pelt =>
  {:id => 29,
    :name => 'wolf pelt',
    :plural => 'wolf pelts',
    :desc => 'the hide of a wolf',
    :weight => 4,
  },
  
  :bear_skin =>
  {:id => 30,
    :name => 'bear skin',
    :plural => 'bear skins',
    :desc => 'the hide of a bear',
    :weight => 10,
  },
  
  :croc_skin =>
  {:id => 31,
    :name => 'crocodile skin',
    :plural => 'crocodile skins',
    :desc => 'the hide of a crocodile',
    :weight => 6,
  },
  
  :horn =>
  {:id => 32,
    :name => 'horn',
    :plural => 'horns',
    :desc => 'the horn of some animal',
    :weight => 3,
    
    :use => :weapon,
    :weapon_class => :stab,
    :break_odds => 5,
    :accuracy => 20,
    :effect => 2,
  },
  
  :rotten_food =>
  {:id => 33,
    :name => 'lump of rotten food',
    :plural => 'lumps of rotten food',
    :desc => "whatever it was, it's not edible anymore",
    :use => "You stare at the lump of rotten food questioningly. It stares back.",
    :weight => 1,
  },
  
  :clay =>
  {:id => 34,
    :name => 'lump of clay',
    :plural => 'lumps of clay',
    :desc => "a lump of clay",
    :weight => 2,
  },
  
  :gold_coin =>
  {:id => 35,
    :name => 'gold coin',
    :plural => 'gold coins',
    :desc => "a gold disk with some mysterious etchings on the surface",
    :weight => 0,
  },
  
  :antler =>
  {:id => 36,
    :name => 'antler',
    :plural => 'antlers',
    :desc => "a magnificent antler",
    :weight => 4,
  },
  
  :bone_pick =>
  {:id => 37,
    :name => 'bone pick',
    :plural => 'bone picks',
    :desc => 'a pick crafted from bone or antler',
    :weight => 3,
    :break_odds => 5,
    
    :craftable => true,
    :craft_ap => 10,
    :craft_xp => 10,
    :craft_skill => :carpentry,
    :craft_building => :workshop,
    :tools => [:stone_carpentry],
    :materials => {:antler => 1}
  },
  
  :boulder =>
  {:id => 38,
    :name => 'boulder',
    :plural => 'boulders',
    :desc => "a large, heavy boulder",
    :weight => 6,
  },
  
  :masonry_tools =>
  {:id => 39,
    :name => 'set of masonry tools',
    :plural => 'sets of masonry tools',
    :desc => 'a set of stone masonry tools, including a chisel, hammer and rock drill',
    
    :weight => 8,
    :break_odds => 4,
    :craftable => true,
    :craft_ap => 15,
    :craft_xp => 15,
    :craft_building => :workshop,
    :craft_skill => :carpentry,
    :tools => [:stone_carpentry],
    :materials => {:hand_axe => 2, :stone => 2, :stick => 4}
  },
  
  :stone_block =>
  {:id => 40,
    :name => 'stone block',
    :plural => 'stone blocks',
    :desc => 'a large stone block, for construction',
    
    :weight => 4,
    :craftable => true,
    :craft_ap => 10,
    :craft_xp => 6,
    :craft_building => :stonemasonry,
    :craft_skill => :stone_working,
    :tools => [:masonry_tools],
    :materials => {:boulder => 1}
  },
  
  :pot =>
  {:id => 41,
    :name => 'pot',
    :plural => 'pots',
    :desc => 'the legal kind',
    :weight => 3,
    
    :craftable => true,
    :craft_ap => 10,
    :craft_xp => 5,
    :craft_skill => :pottery,
    :craft_building => :kiln,
    :materials => {:clay => 3}
  },
  
  :lion_pelt =>
  {:id => 42,
    :name => 'lion pelt',
    :plural => 'lion pelts',
    :desc => 'the hide of a lion',
    :weight => 6,
  },
  
  :water_pot =>
  {:id => 43,
    :name => 'pot of water',
    :plural => 'pots of water',
    :desc => 'a clay pot filled with water',
    :weight => 10,
  },
  
  :ocarina =>
  {:id => 44,
    :name => 'ocarina',
    :plural => 'ocarinas',
    :desc => 'a small wind instrument',
    :use => :ocarina,
    
    :weight => 1,
    :craftable => true,
    :craft_ap => 7,
    :craft_xp => 5,
    :craft_building => :kiln,
    :craft_skill => :pottery,
    :materials => {:clay => 1}
  },
  
  :grinding_stone =>
  {:id => 45,
    :name => 'grinding stone',
    :plural => 'grinding stones',
    :desc => 'a heavy stone for grinding',
    :weight => 4,
    
    :craftable => true,
    :craft_ap => 10,
    :craft_xp => 6,
    :craft_building => :stonemasonry,
    :craft_skill => :stone_working,
    :tools => [:masonry_tools],
    :materials => {:boulder => 1}
  },
  
  :flour_pot =>
  {:id => 46,
    :name => 'pot of flour',
    :plural => 'pots of flour',
    :desc => 'a pot full of flour',
    :weight => 7,
    
    :craftable => true,
    :craft_ap => 16,
    :craft_xp => 5,
    :craft_skill => :milling,
    :tools => [:grinding_stone, :stone],
    :materials => {:wheat => 4, :pot => 1}
  },
  
  :bread =>
  {:id => 47,
    :name => 'flatbread',
    :plural => 'flatbreads',
    :desc => 'a flat loaf of bread',
    :weight => 1,
    :use => :food,
    
    :craftable => true,
    :craft_amount => 10,
    :craft_ap => 8,
    :craft_xp => 4,
    :craft_xp_type => :herbal,
    :craft_skill => :baking,
    :craft_building => :bakery,
    :materials => {:flour_pot => 1, :water_pot => 1},
    :extra_products => {:pot => 2}
  },
  
  :honeycomb =>
  {:id => 48,
    :name => 'honeycomb',
    :plural => 'honeycombs',
    :desc => 'a honeycomb, good for healing',
    :use => :heal,
    :effect => {:default => 3, :herb_lore => 5},
    :weight => 1,
  },
  
  :tusk =>
  {:id => 49,
    :name => 'mammoth tusk',
    :plural => 'mammoth tusks',
    :use => :weapon,
    :weapon_class => :stab,
    :desc => "a huge mammoth's tusk, very unwieldy",
    :weight => 8,
    :break_odds => 5,
    :accuracy => 20,
    :effect => 6,
  },

  :ivory_spear =>
  {:id => 50,
    :name => 'ivory spear',
    :plural => 'ivory spears',
    :desc => 'a finely-crafted spear made from the tusk of a mammoth and decorated with fur',
    :use => :weapon,
    :weight => 8,
    :break_odds => 0.25,
    :weapon_class => :stab,
    :tools => [:stone],
    :accuracy => {:default => 30, :spear2 => 40, :spear4 => 50},
    :effect => {:default => 6, :spear1 => 7, :spear3 => 8},
    :craftable => true,
    :craft_ap => 15,
    :craft_xp => 15,
    :craft_skill => :hafting,
    :materials => {:tusk => 1, :staff => 1, :small_pelt => 1}
  },

  :ivory_axe =>
  {:id => 51,
    :name => 'ivory axe',
    :plural => 'ivory axes',
    :desc => 'a finely-crafted axe made from the tusk of a mammoth and decorated with fur',
    :use => :weapon,
    :break_odds => 0.25,
    :weapon_class => :slash,
    :tools => [:stone],
    :accuracy => {:default => 20, :axe2 => 30, :axe4 => 40},
    :effect => {:default => 6, :axe1 => 7, :axe3 => 8},
    :weight => 8,
    :craftable => true,
    :craft_ap => 15,
    :craft_xp => 15,
    :craft_skill => :hafting,
    :materials => {:tusk => 1, :stick => 1, :small_pelt => 1}
  },

  :ivory_pick =>
  {:id => 52,
    :name => 'ivory pick',
    :plural => 'ivory picks',
    :desc => 'a pick crafted from the tusk of a mammoth',
    :weight => 3,
    :break_odds => 0.25,
    
    :craftable => true,
    :craft_ap => 15,
    :craft_xp => 15,
    :craft_skill => :carpentry,
    :craft_building => :workshop,
    :tools => [:stone_carpentry],
    :materials => {:tusk => 1}
  },

  :huckleberry =>
  {:id => 53,
    :name => 'handful of huckleberries',
    :plural => 'handfuls of huckleberries',
    :desc => 'a handful of juicy huckleberries',
    :use => :food,
    :weight => 1,
    :Spring => 0.3,
    :Autumn => 1.5,
    :Winter => 0.5
  },

  :hberry_pie =>
  {:id => 54,
    :name => 'slice of huckleberry pie',
    :plural => 'slices of huckleberry pie',
    :desc => 'a slice of mouth-watering huckleberry pie',
    :weight => 1,
    :use => :food,
    
    :craftable => true,
    :craft_amount => 15,
    :craft_ap => 8,
    :craft_xp => 4,
    :craft_xp_type => :herbal,
    :craft_skill => :baking,
    :craft_building => :bakery,
    :materials => {:flour_pot => 1, :water_pot => 1, :huckleberry => 3},
    :extra_products => {:pot => 2}
  },
}]
