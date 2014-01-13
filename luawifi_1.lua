local rshift,lshift,wd,ww,wb,rd,rw,rb,gt,sf,mf,ts,ti=bit.rshift,bit.lshift,memory.writedword,memory.writeword,memory.writebyte,memory.readdwordunsigned,memory.readwordunsigned,memory.readbyteunsigned,gui.text,string.format,math.floor,table.sort,table.insert
local on,enbl,display,sdec,rdec,shlog,pdata,speedlist,speed=0,1,1,{},{},{},{},{},{}
local typeorder={"Fighting","Flying","Poison","Ground","Rock","Bug","Ghost","Steel","Fire","Water","Grass","Electric","Psychic","Ice","Dragon","Dark"}
local speciesindex={"Bulbasaur","Ivysaur","Venusaur","Charmander","Charmeleon","Charizard","Squirtle","Wartortle","Blastoise","Caterpie","Metapod","Butterfree","Weedle","Kakuna","Beedrill","Pidgey","Pidgeotto","Pidgeot","Rattata","Raticate","Spearow","Fearow","Ekans","Arbok","Pikachu","Raichu","Sandshrew","Sandslash","Nidoran?","Nidorina","Nidoqueen","Nidoran?","Nidorino","Nidoking","Clefairy","Clefable","Vulpix","Ninetales","Jigglypuff","Wigglytuff","Zubat","Golbat","Oddish","Gloom","Vileplume","Paras","Parasect","Venonat","Venomoth","Diglett","Dugtrio","Meowth","Persian","Psyduck","Golduck","Mankey","Primeape","Growlithe","Arcanine","Poliwag","Poliwhirl","Poliwrath","Abra","Kadabra","Alakazam","Machop","Machoke","Machamp","Bellsprout","Weepinbell","Victreebel","Tentacool","Tentacruel","Geodude","Graveler","Golem","Ponyta","Rapidash","Slowpoke","Slowbro","Magnemite","Magneton","Farfetch'd","Doduo","Dodrio","Seel","Dewgong","Grimer","Muk","Shellder","Cloyster","Gastly","Haunter","Gengar","Onix","Drowzee","Hypno","Krabby","Kingler","Voltorb","Electrode","Exeggcute","Exeggutor","Cubone","Marowak","Hitmonlee","Hitmonchan","Lickitung","Koffing","Weezing","Rhyhorn","Rhydon","Chansey","Tangela","Kangaskhan","Horsea","Seadra","Goldeen","Seaking","Staryu","Starmie","Mr. Mime","Scyther","Jynx","Electabuzz","Magmar","Pinsir","Tauros","Magikarp","Gyarados","Lapras","Ditto","Eevee","Vaporeon","Jolteon","Flareon","Porygon","Omanyte","Omastar","Kabuto","Kabutops","Aerodactyl","Snorlax","Articuno","Zapdos","Moltres","Dratini","Dragonair","Dragonite","Mewtwo","Mew","Chikorita","Bayleef","Meganium","Cyndaquil","Quilava","Typhlosion","Totodile","Croconaw","Feraligatr","Sentret","Furret","Hoothoot","Noctowl","Ledyba","Ledian","Spinarak","Ariados","Crobat","Chinchou","Lanturn","Pichu","Cleffa","Igglybuff","Togepi","Togetic","Natu","Xatu","Mareep","Flaaffy","Ampharos","Bellossom","Marill","Azumarill","Sudowoodo","Politoed","Hoppip","Skiploom","Jumpluff","Aipom","Sunkern","Sunflora","Yanma","Wooper","Quagsire","Espeon","Umbreon","Murkrow","Slowking","Misdreavus","Unown","Wobbuffet","Girafarig","Pineco","Forretress","Dunsparce","Gligar","Steelix","Snubbull","Granbull","Qwilfish","Scizor","Shuckle","Heracross","Sneasel","Teddiursa","Ursaring","Slugma","Magcargo","Swinub","Piloswine","Corsola","Remoraid","Octillery","Delibird","Mantine","Skarmory","Houndour","Houndoom","Kingdra","Phanpy","Donphan","Porygon2","Stantler","Smeargle","Tyrogue","Hitmontop","Smoochum","Elekid","Magby","Miltank","Blissey","Raikou","Entei","Suicune","Larvitar","Pupitar","Tyranitar","Lugia","Ho-Oh","Celebi","Treecko","Grovyle","Sceptile","Torchic","Combusken","Blaziken","Mudkip","Marshtomp","Swampert","Poochyena","Mightyena","Zigzagoon","Linoone","Wurmple","Silcoon","Beautifly","Cascoon","Dustox","Lotad","Lombre","Ludicolo","Seedot","Nuzleaf","Shiftry","Taillow","Swellow","Wingull","Pelipper","Ralts","Kirlia","Gardevoir","Surskit","Masquerain","Shroomish","Breloom","Slakoth","Vigoroth","Slaking","Nincada","Ninjask","Shedinja","Whismur","Loudred","Exploud","Makuhita","Hariyama","Azurill","Nosepass","Skitty","Delcatty","Sableye","Mawile","Aron","Lairon","Aggron","Meditite","Medicham","Electrike","Manectric","Plusle","Minun","Volbeat","Illumise","Roselia","Gulpin","Swalot","Carvanha","Sharpedo","Wailmer","Wailord","Numel","Camerupt","Torkoal","Spoink","Grumpig","Spinda","Trapinch","Vibrava","Flygon","Cacnea","Cacturne","Swablu","Altaria","Zangoose","Seviper","Lunatone","Solrock","Barboach","Whiscash","Corphish","Crawdaunt","Baltoy","Claydol","Lileep","Cradily","Anorith","Armaldo","Feebas","Milotic","Castform","Kecleon","Shuppet","Banette","Duskull","Dusclops","Tropius","Chimecho","Absol","Wynaut","Snorunt","Glalie","Spheal","Sealeo","Walrein","Clamperl","Huntail","Gorebyss","Relicanth","Luvdisc","Bagon","Shelgon","Salamence","Beldum","Metang","Metagross","Regirock","Regice","Registeel","Latias","Latios","Kyogre","Groudon","Rayquaza","Jirachi","Deoxys","Turtwig","Grotle","Torterra","Chimchar","Monferno","Infernape","Piplup","Prinplup","Empoleon","Starly","Staravia","Staraptor","Bidoof","Bibarel","Kricketot","Kricketune","Shinx","Luxio","Luxray","Budew","Roserade","Cranidos","Rampardos","Shieldon","Bastiodon","Burmy","Wormadam","Mothim","Combee","Vespiquen","Pachirisu","Buizel","Floatzel","Cherubi","Cherrim","Shellos","Gastrodon","Ambipom","Drifloon","Drifblim","Buneary","Lopunny","Mismagius","Honchkrow","Glameow","Purugly","Chingling","Stunky","Skuntank","Bronzor","Bronzong","Bonsly","Mime Jr.","Happiny","Chatot","Spiritomb","Gible","Gabite","Garchomp","Munchlax","Riolu","Lucario","Hippopotas","Hippowdon","Skorupi","Drapion","Croagunk","Toxicroak","Carnivine","Finneon","Lumineon","Mantyke","Snover","Abomasnow","Weavile","Magnezone","Lickilicky","Rhyperior","Tangrowth","Electivire","Magmortar","Togekiss","Yanmega","Leafeon","Glaceon","Gliscor","Mamoswine","Porygon-Z","Gallade","Probopass","Dusknoir","Froslass","Rotom","Uxie","Mesprit","Azelf","Dialga","Palkia","Heatran","Regigigas","Giratina","Cresselia","Phione","Manaphy","Darkrai","Shaymin","Arceus","Victini","Snivy","Servine","Serperior","Tepig","Pignite","Emboar","Oshawott","Dewott","Samurott","Patrat","Watchog","Lillipup","Herdier","Stoutland","Purrloin","Liepard","Pansage","Simisage","Pansear","Simisear","Panpour","Simipour","Munna","Musharna","Pidove","Tranquill","Unfezant","Blitzle","Zebstrika","Roggenrola","Boldore","Gigalith","Woobat","Swoobat","Drilbur","Excadrill","Audino","Timburr","Gurdurr","Conkeldurr","Tympole","Palpitoad","Seismitoad","Throh","Sawk","Sewaddle","Swadloon","Leavanny","Venipede","Whirlipede","Scolipede","Cottonee","Whimsicott","Petilil","Lilligant","Basculin","Sandile","Krokorok","Krookodile","Darumaka","Darmanitan","Maractus","Dwebble","Crustle","Scraggy","Scrafty","Sigilyph","Yamask","Cofagrigus","Tirtouga","Carracosta","Archen","Archeops","Trubbish","Garbodor","Zorua","Zoroark","Minccino","Cinccino","Gothita","Gothorita","Gothitelle","Solosis","Duosion","Reuniclus","Ducklett","Swanna","Vanillite","Vanillish","Vanilluxe","Deerling","Sawsbuck","Emolga","Karrablast","Escavalier","Foongus","Amoonguss","Frillish","Jellicent","Alomomola","Joltik","Galvantula","Ferroseed","Ferrothorn","Klink","Klang","Klinklang","Tynamo","Eelektrik","Eelektross","Elgyem","Beheeyem","Litwick","Lampent","Chandelure","Axew","Fraxure","Haxorus","Cubchoo","Beartic","Cryogonal","Shelmet","Accelgor","Stunfisk","Mienfoo","Mienshao","Druddigon","Golett","Golurk","Pawniard","Bisharp","Bouffalant","Rufflet","Braviary","Vullaby","Mandibuzz","Heatmor","Durant","Deino","Zweilous","Hydreigon","Larvesta","Volcarona","Cobalion","Terrakion","Virizion","Tornadus","Thundurus","Reshiram","Zekrom","Landorus","Kyurem","Keldeo","Meloetta","Genesect"}
local itemindex={"Master Ball","Ultra Ball","Great Ball","Poke Ball","Safari Ball","Net Ball","Dive Ball","Nest Ball","Repeat Ball","Timer Ball","Luxury Ball","Premier Ball","Dusk Ball","Heal Ball","Quick Ball","Cherish Ball","Potion","Antidote","Burn Heal","Ice Heal","Awakening","Parlyz Heal","Full Restore","Max Potion","Hyper Potion","Super Potion","Full Heal","Revive","Max Revive","Fresh Water","Soda Pop","Lemonade","Moomoo Milk","EnergyPowder","Energy Root","Heal Powder","Revival Herb","Ether","Max Ether","Elixir","Max Elixir","Lava Cookie","Berry Juice","Sacred Ash","HP Up","Protein","Iron","Carbos","Calcium","Rare Candy","PP Up","Zinc","PP Max","Old Gateau","Guard Spec.","Dire Hit","X Attack","X Defend","X Speed","X Accuracy","X Special","X Sp. Def","Poké Doll","Fluffy Tail","Blue Flute","Yellow Flute","Red Flute","Black Flute","White Flute","Shoal Salt","Shoal Shell","Red Shard","Blue Shard","Yellow Shard","Green Shard","Super Repel","Max Repel","Escape Rope","Repel","Sun Stone","Moon Stone","Fire Stone","Thunderstone","Water Stone","Leaf Stone","TinyMushroom","Big Mushroom","Pearl","Big Pearl","Stardust","Star Piece","Nugget","Heart Scale","Honey","Growth Mulch","Damp Mulch","Stable Mulch","Gooey Mulch","Root Fossil","Claw Fossil","Helix Fossil","Dome Fossil","Old Amber","Armor Fossil","Skull Fossil","Rare Bone","Shiny Stone","Dusk Stone","Dawn Stone","Oval Stone","Odd Keystone","Griseous Orb","???","???","???","Douse Drive","Shock Drive","Burn Drive","Chill Drive","???","???","???","???","???","???","???","???","???","???","???","???","???","???","Sweet Heart","Adamant Orb","Lustrous Orb","Greet Mail","Favored Mail","RSVP Mail","Thanks Mail","Inquiry Mail","Like Mail","Reply Mail","BridgeMail S","BridgeMail D","BridgeMail T","BridgeMail V","BridgeMail M","Cheri Berry","Chesto Berry","Pecha Berry","Rawst Berry","Aspear Berry","Leppa Berry","Oran Berry","Persim Berry","Lum Berry","Sitrus Berry","Figy Berry","Wiki Berry","Mago Berry","Aguav Berry","Iapapa Berry","Razz Berry","Bluk Berry","Nanab Berry","Wepear Berry","Pinap Berry","Pomeg Berry","Kelpsy Berry","Qualot Berry","Hondew Berry","Grepa Berry","Tamato Berry","Cornn Berry","Magost Berry","Rabuta Berry","Nomel Berry","Spelon Berry","Pamtre Berry","Watmel Berry","Durin Berry","Belue Berry","Occa Berry","Passho Berry","Wacan Berry","Rindo Berry","Yache Berry","Chople Berry","Kebia Berry","Shuca Berry","Coba Berry","Payapa Berry","Tanga Berry","Charti Berry","Kasib Berry","Haban Berry","Colbur Berry","Babiri Berry","Chilan Berry","Liechi Berry","Ganlon Berry","Salac Berry","Petaya Berry","Apicot Berry","Lansat Berry","Starf Berry","Enigma Berry","Micle Berry","Custap Berry","Jaboca Berry","Rowap Berry","BrightPowder","White Herb","Macho Brace","Exp. Share","Quick Claw","Soothe Bell","Mental Herb","Choice Band","King's Rock","SilverPowder","Amulet Coin","Cleanse Tag","Soul Dew","DeepSeaTooth","DeepSeaScale","Smoke Ball","Everstone","Focus Band","Lucky Egg","Scope Lens","Metal Coat","Leftovers","Dragon Scale","Light Ball","Soft Sand","Hard Stone","Miracle Seed","BlackGlasses","Black Belt","Magnet","Mystic Water","Sharp Beak","Poison Barb","NeverMeltIce","Spell Tag","TwistedSpoon","Charcoal","Dragon Fang","Silk Scarf","Up-Grade","Shell Bell","Sea Incense","Lax Incense","Lucky Punch","Metal Powder","Thick Club","Stick","Red Scarf","Blue Scarf","Pink Scarf","Green Scarf","Yellow Scarf","Wide Lens","Muscle Band","Wise Glasses","Expert Belt","Light Clay","Life Orb","Power Herb","Toxic Orb","Flame Orb","Quick Powder","Focus Sash","Zoom Lens","Metronome","Iron Ball","Lagging Tail","Destiny Knot","Black Sludge","Icy Rock","Smooth Rock","Heat Rock","Damp Rock","Grip Claw","Choice Scarf","Sticky Barb","Power Bracer","Power Belt","Power Lens","Power Band","Power Anklet","Power Weight","Shed Shell","Big Root","Choice Specs","Flame Plate","Splash Plate","Zap Plate","Meadow Plate","Icicle Plate","Fist Plate","Toxic Plate","Earth Plate","Sky Plate","Mind Plate","Insect Plate","Stone Plate","Spooky Plate","Draco Plate","Dread Plate","Iron Plate","Odd Incense","Rock Incense","Full Incense","Wave Incense","Rose Incense","Luck Incense","Pure Incense","Protector","Electirizer","Magmarizer","Dubious Disc","Reaper Cloth","Razor Claw","Razor Fang","TM01","TM02","TM03","TM04","TM05","TM06","TM07","TM08","TM09","TM10","TM11","TM12","TM13","TM14","TM15","TM16","TM17","TM18","TM19","TM20","TM21","TM22","TM23","TM24","TM25","TM26","TM27","TM28","TM29","TM30","TM31","TM32","TM33","TM34","TM35","TM36","TM37","TM38","TM39","TM40","TM41","TM42","TM43","TM44","TM45","TM46","TM47","TM48","TM49","TM50","TM51","TM52","TM53","TM54","TM55","TM56","TM57","TM58","TM59","TM60","TM61","TM62","TM63","TM64","TM65","TM66","TM67","TM68","TM69","TM70","TM71","TM72","TM73","TM74","TM75","TM76","TM77","TM78","TM79","TM80","TM81","TM82","TM83","TM84","TM85","TM86","TM87","TM88","TM89","TM90","TM91","TM92","HM01","HM02","HM03","HM04","HM05","HM06","???","???","Explorer Kit","Loot Sack","Rule Book","Poké Radar","Point Card","Journal","Seal Case","Fashion Case","Seal Bag","Pal Pad","Works Key","Old Charm","Galactic Key","Red Chain","Town Map","Vs. Seeker","Coin Case","Old Rod","Good Rod","Super Rod","Sprayduck","Poffin Case","Bicycle","Suite Key","Oak's Letter","Lunar Wing","Member Card","Azure Flute","S.S. Ticket","Contest Pass","Magma Stone","Parcel","Coupon 1","Coupon 2","Coupon 3","Storage Key","SecretPotion","Vs. Recorder","Gracidea","Secret Key","Apricorn Box","Unown Report","Berry Pots","Dowsing MCHN","Blue Card","SlowpokeTail","Clear Bell","Card Key","Basement Key","SquirtBottle","Red Scale","Lost Item","Pass","Machine Part","Silver Wing","Rainbow Wing","Mystery Egg","Red Apricorn","Blu Apricorn","Ylw Apricorn","Grn Apricorn","Pnk Apricorn","Wht Apricorn","Blk Apricorn","Fast Ball","Level Ball","Lure Ball","Heavy Ball","Love Ball","Friend Ball","Moon Ball","Sport Ball","Park Ball","Photo Album","GB Sounds","Tidal Bell","RageCandyBar","Data Card 01","Data Card 02","Data Card 03","Data Card 04","Data Card 05","Data Card 06","Data Card 07","Data Card 08","Data Card 09","Data Card 10","Data Card 11","Data Card 12","Data Card 13","Data Card 14","Data Card 15","Data Card 16","Data Card 17","Data Card 18","Data Card 19","Data Card 20","Data Card 21","Data Card 22","Data Card 23","Data Card 24","Data Card 25","Data Card 26","Data Card 27","Jade Orb","Lock Capsule","Red Orb","Blue Orb","Enigma Stone","Prism Scale","Eviolite","Float Stone","Rocky Helmet","Air Balloon","Red Card","Ring Target","Binding Band","Absorb Bulb","Cell Battery","Eject Button","Fire Gem","Water Gem","Electric Gem","Grass Gem","Ice Gem","Fighting Gem","Poison Gem","Ground Gem","Flying Gem","Psychic Gem","Bug Gem","Rock Gem","Ghost Gem","Dragon Gem","Dark Gem","Steel Gem","Normal Gem","Health Wing","Muscle Wing","Resist Wing","Genius Wing","Clever Wing","Swift Wing","Pretty Wing","Cover Fossil","Plume Fossil","Liberty Pass","Pass Orb","Dream Ball","Poké Toy","Prop Case","Dragon Skull","BalmMushroom","Big Nugget","Pearl String","Comet Shard","Relic Copper","Relic Silver","Relic Gold","Relic Vase","Relic Band","Relic Statue","Relic Crown","Casteliacone","Dire Hit 2","X Speed 2","X Special 2","X Sp. Def 2","X Defend 2","X Attack 2","X Accuracy 2","X Speed 3","X Special 3","X Sp. Def 3","X Defend 3","X Attack 3","X Accuracy 3","X Speed 6","X Special 6","X Sp. Def 6","X Defend 6","X Attack 6","X Accuracy 6","Ability Urge","Item Drop","Item Urge","Reset Urge","Dire Hit 3","Light Stone","Dark Stone","TM93","TM94","TM95","Xtransceiver","???","Gram 1","Gram 2","Gram 3","Xtransceiver"}
local naturename={"Hardy","Lonely","Brave","Adamant","Naughty","Bold","Docile","Relaxed","Impish","Lax","Timid","Hasty","Serious","Jolly","Naive","Modest","Mild","Quiet","Bashful","Rash","Calm","Gentle","Sassy","Careful","Quirky"}
local moveindex={"Pound","Karate Chop","DoubleSlap","Comet Punch","Mega Punch","Pay Day","Fire Punch","Ice Punch","ThunderPunch","Scratch","ViceGrip","Guillotine","Razor Wind","Swords Dance","Cut","Gust","Wing Attack","Whirlwind","Fly","Bind","Slam","Vine Whip","Stomp","Double Kick","Mega Kick","Jump Kick","Rolling Kick","Sand-Attack","Headbutt","Horn Attack","Fury Attack","Horn Drill","Tackle","Body Slam","Wrap","Take Down","Thrash","Double-Edge","Tail Whip","Poison Sting","Twineedle","Pin Missile","Leer","Bite","Growl","Roar","Sing","Supersonic","SonicBoom","Disable","Acid","Ember","Flamethrower","Mist","Water Gun","Hydro Pump","Surf","Ice Beam","Blizzard","Psybeam","BubbleBeam","Aurora Beam","Hyper Beam","Peck","Drill Peck","Submission","Low Kick","Counter","Seismic Toss","Strength","Absorb","Mega Drain","Leech Seed","Growth","Razor Leaf","SolarBeam","PoisonPowder","Stun Spore","Sleep Powder","Petal Dance","String Shot","Dragon Rage","Fire Spin","ThunderShock","Thunderbolt","Thunder Wave","Thunder","Rock Throw","Earthquake","Fissure","Dig","Toxic","Confusion","Psychic","Hypnosis","Meditate","Agility","Quick Attack","Rage","Teleport","Night Shade","Mimic","Screech","Double Team","Recover","Harden","Minimize","SmokeScreen","Confuse Ray","Withdraw","Defense Curl","Barrier","Light Screen","Haze","Reflect","Focus Energy","Bide","Metronome","Mirror Move","Selfdestruct","Egg Bomb","Lick","Smog","Sludge","Bone Club","Fire Blast","Waterfall","Clamp","Swift","Skull Bash","Spike Cannon","Constrict","Amnesia","Kinesis","Softboiled","Hi Jump Kick","Glare","Dream Eater","Poison Gas","Barrage","Leech Life","Lovely Kiss","Sky Attack","Transform","Bubble","Dizzy Punch","Spore","Flash","Psywave","Splash","Acid Armor","Crabhammer","Explosion","Fury Swipes","Bonemerang","Rest","Rock Slide","Hyper Fang","Sharpen","Conversion","Tri Attack","Super Fang","Slash","Substitute","Struggle","Sketch","Triple Kick","Thief","Spider Web","Mind Reader","Nightmare","Flame Wheel","Snore","Curse","Flail","Conversion 2","Aeroblast","Cotton Spore","Reversal","Spite","Powder Snow","Protect","Mach Punch","Scary Face","Faint Attack","Sweet Kiss","Belly Drum","Sludge Bomb","Mud-Slap","Octazooka","Spikes","Zap Cannon","Foresight","Destiny Bond","Perish Song","Icy Wind","Detect","Bone Rush","Lock-On","Outrage","Sandstorm","Giga Drain","Endure","Charm","Rollout","False Swipe","Swagger","Milk Drink","Spark","Fury Cutter","Steel Wing","Mean Look","Attract","Sleep Talk","Heal Bell","Return","Present","Frustration","Safeguard","Pain Split","Sacred Fire","Magnitude","DynamicPunch","Megahorn","DragonBreath","Baton Pass","Encore","Pursuit","Rapid Spin","Sweet Scent","Iron Tail","Metal Claw","Vital Throw","Morning Sun","Synthesis","Moonlight","Hidden Power","Cross Chop","Twister","Rain Dance","Sunny Day","Crunch","Mirror Coat","Psych Up","ExtremeSpeed","AncientPower","Shadow Ball","Future Sight","Rock Smash","Whirlpool","Beat Up","Fake Out","Uproar","Stockpile","Spit Up","Swallow","Heat Wave","Hail","Torment","Flatter","Will-O-Wisp","Memento","Facade","Focus Punch","SmellingSalt","Follow Me","Nature Power","Charge","Taunt","Helping Hand","Trick","Role Play","Wish","Assist","Ingrain","Superpower","Magic Coat","Recycle","Revenge","Brick Break","Yawn","Knock Off","Endeavor","Eruption","Skill Swap","Imprison","Refresh","Grudge","Snatch","Secret Power","Dive","Arm Thrust","Camouflage","Tail Glow","Luster Purge","Mist Ball","FeatherDance","Teeter Dance","Blaze Kick","Mud Sport","Ice Ball","Needle Arm","Slack Off","Hyper Voice","Poison Fang","Crush Claw","Blast Burn","Hydro Cannon","Meteor Mash","Astonish","Weather Ball","Aromatherapy","Fake Tears","Air Cutter","Overheat","Odor Sleuth","Rock Tomb","Silver Wind","Metal Sound","GrassWhistle","Tickle","Cosmic Power","Water Spout","Signal Beam","Shadow Punch","Extrasensory","Sky Uppercut","Sand Tomb","Sheer Cold","Muddy Water","Bullet Seed","Aerial Ace","Icicle Spear","Iron Defense","Block","Howl","Dragon Claw","Frenzy Plant","Bulk Up","Bounce","Mud Shot","Poison Tail","Covet","Volt Tackle","Magical Leaf","Water Sport","Calm Mind","Leaf Blade","Dragon Dance","Rock Blast","Shock Wave","Water Pulse","Doom Desire","Psycho Boost","Roost","Gravity","Miracle Eye","Wake-Up Slap","Hammer Arm","Gyro Ball","Healing Wish","Brine","Natural Gift","Feint","Pluck","Tailwind","Acupressure","Metal Burst","U-turn","Close Combat","Payback","Assurance","Embargo","Fling","Psycho Shift","Trump Card","Heal Block","Wring Out","Power Trick","Gastro Acid","Lucky Chant","Me First","Copycat","Power Swap","Guard Swap","Punishment","Last Resort","Worry Seed","Sucker Punch","Toxic Spikes","Heart Swap","Aqua Ring","Magnet Rise","Flare Blitz","Force Palm","Aura Sphere","Rock Polish","Poison Jab","Dark Pulse","Night Slash","Aqua Tail","Seed Bomb","Air Slash","X-Scissor","Bug Buzz","Dragon Pulse","Dragon Rush","Power Gem","Drain Punch","Vacuum Wave","Focus Blast","Energy Ball","Brave Bird","Earth Power","Switcheroo","Giga Impact","Nasty Plot","Bullet Punch","Avalanche","Ice Shard","Shadow Claw","Thunder Fang","Ice Fang","Fire Fang","Shadow Sneak","Mud Bomb","Psycho Cut","Zen Headbutt","Mirror Shot","Flash Cannon","Rock Climb","Defog","Trick Room","Draco Meteor","Discharge","Lava Plume","Leaf Storm","Power Whip","Rock Wrecker","Cross Poison","Gunk Shot","Iron Head","Magnet Bomb","Stone Edge","Captivate","Stealth Rock","Grass Knot","Chatter","Judgment","Bug Bite","Charge Beam","Wood Hammer","Aqua Jet","Attack Order","Defend Order","Heal Order","Head Smash","Double Hit","Roar of Time","Spacial Rend","Lunar Dance","Crush Grip","Magma Storm","Dark Void","Seed Flare","Ominous Wind","Shadow Force","Hone Claws","Wide Guard","Guard Split","Power Split","Wonder Room","Psyshock","Venoshock","Autotomize","Rage Powder","Telekinesis","Magic Room","Smack Down","Storm Throw","Flame Burst","Sludge Wave","Quiver Dance","Heavy Slam","Synchronoise","Electro Ball","Soak","Flame Charge","Coil","Low Sweep","Acid Spray","Foul Play","Simple Beam","Entrainment","After You","Round","Echoed Voice","Chip Away","Clear Smog","Stored Power","Quick Guard","Ally Switch","Scald","Shell Smash","Heal Pulse","Hex","Sky Drop","Shift Gear","Circle Throw","Incinerate","Quash","Acrobatics","Reflect Type","Retaliate","Final Gambit","Bestow","Inferno","Water Pledge","Fire Pledge","Grass Pledge","Volt Switch","Struggle Bug","Bulldoze","Frost Breath","Dragon Tail","Work Up","Electroweb","Wild Charge","Drill Run","Dual Chop","Heart Stamp","Horn Leech","Sacred Sword","Razor Shell","Heat Crash","Leaf Tornado","Steamroller","Cotton Guard","Night Daze","Psystrike","Tail Slap","Hurricane","Head Charge","Gear Grind","Searing Shot","Techno Blast","Relic Song","Secret Sword","Glaciate","Bolt Strike","Blue Flare","Fiery Dance","Freeze Shock","Ice Burn","Snarl","Icicle Crash","V-create","Fusion Flare","Fusion Bolt"}
local Apkms={0x023A8078,0x023A8154,0x023A8230,0x023A830C,0x023A83E8,0x023A84C4}
local Bpkms={0x023A85D8,0x023A86B4,0x023A8790,0x023A886C,0x023A8948,0x023A8A24}

function mb(x) 				-- Read u8  properly (for prose)
	return rb(x)
end
function mw(x) 				-- Read u16 properly
	return rb(x)+rb(x+1)*0x100
end
function md(x) 				-- Read u32 properly
	return rb(x)+rb(x+1)*0x100+rb(x+2)*0x10000+rb(x+3)*0x1000000
end
function rand(seed) 		-- LCRNG 32bit for Decryption
	return (0x4e6d*(seed%65536)+((0x41c6*(seed%65536)+0x4e6d*mf(seed/65536))%65536)*65536+0x6073)%4294967296 
end
function species(getspec) 	-- Get the species of a nat dex's #
	if getspec==0 then return "None"
	else return speciesindex[getspec] end
	end
function helditem(getitem) 	-- Get the item of a held's index #
	if getitem==0 then return "None"
	else return itemindex[getitem]
	end
	end
function movenum(getmove)	-- Get the name of a move's index #
	if getmove==0 then print(getmove) return "None"
	else move=moveindex[getmove]
		if move=="Hidden Power" then
			IVs=Apkm1[0x38]+Apkm1[0x39]*0x100+Apkm1[0x3A]*0x10000+Apkm1[0x3B]*0x1000000
			hpiv=bit.band(IVs,0x1F)
			atkiv=bit.band(IVs,0x1F*0x20)/0x20
			defiv=bit.band(IVs,0x1F*0x400)/0x400
			spdiv=bit.band(IVs,0x1F*0x8000)/0x8000
			spatkiv=bit.band(IVs,0x1F*0x100000)/0x100000
			spdefiv=bit.band(IVs,0x1F*0x2000000)/0x2000000
			
			hidpowtype=typeorder[1+math.floor(((hpiv%2 + 2*(atkiv%2) + 4*(defiv%2) + 8*(spdiv%2) + 16*(spatkiv%2) + 32*(spdefiv%2))*15)/63)]
			hidpowbase=math.floor(((bit.band(hpiv,2)/2 + bit.band(atkiv,2) + 2*bit.band(defiv,2) + 4*bit.band(spdiv,2) + 8*bit.band(spatkiv,2) + 16*bit.band(spdefiv,2))*40)/63 + 30)
			move="Hidden Power ["..hidpowtype..hidpowbase.."]"
		end
	return move
	end
	end
function getpkm(player,pkm) -- Get data for a given player's PKM
	if player==0 then
		start=Apkms[pkm]
	else	start=Bpkms[pkm] end
	pid=md(start)
	checksum=mw(start+6)
	magic=checksum
	pmagic=pid	
	shufflenum=bit.band(rshift(pid,0xD),0x1F)%24
	aloc={0,0,0,0,0,0,1,1,2,3,2,3,1,1,2,3,2,3,1,1,2,3,2,3} shlog[0]=aloc[shufflenum+1]
	bloc={1,1,2,3,2,3,0,0,0,0,0,0,2,3,1,1,3,2,2,3,1,1,3,2} shlog[1]=bloc[shufflenum+1]
	cloc={2,3,1,1,3,2,2,3,1,1,3,2,0,0,0,0,0,0,3,2,3,2,1,1} shlog[2]=cloc[shufflenum+1]
	dloc={3,2,3,2,1,1,3,2,3,2,1,1,3,2,3,2,1,1,0,0,0,0,0,0} shlog[3]=dloc[shufflenum+1]
	
	--Unencrypted PID & Checksum
	for i=0,7 do
		sdec[i]=mb(start+i)
	end
    --Decrypting the Main Stats
	for i=8,135,2 do
		next=rand(magic)
		decval=bit.bxor(rshift(next,16),mw(start+i))
		sdec[i]=decval%0x100
		sdec[i+1]=rshift(decval,8)
		magic=next
	end
    --Decrypting the Party Stats
	for i=136,219,2 do
		next=rand(pmagic)
		decval=bit.bxor(rshift(next,16),mw(start+i))
		--if pkm==5 then print(sf("DEC %04X",decval)) end
		sdec[i]=decval%0x100
		sdec[i+1]=rshift(decval,8)
		pmagic=next
	end
    --Unshuffle Data to Final Form
	--PID area isnt shuffled
	for i=0,7 do
		rdec[i]=sdec[i]
	end
	--Block Unshuffling
	for b=0,3 do
	  for i=0,31 do
		rdec[i+8+0x20*b]=sdec[i+0x20*shlog[b]+8]
	  end
	end	
	--Party Stats aren't shuffled
	for i=136,219 do
		rdec[i]=sdec[i]
	end
return rdec
end
function tl(T) 				-- Table Length to count # of PKMs
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function main()
table=joypad.get(1)
        if (table.L and table.R) then
          gt(0,0,"Filling Data. Let go of L & R!")
                enbl=0
        else
        if enbl==0 then on=(on+1)%2 enbl=1 
print() print("=====Player 1=====")
		Apkm1=getpkm(0,1) 
			Aspec1=species(Apkm1[8]+0x100*Apkm1[9])
			if Aspec1~="None" then
			Aitem1=helditem(Apkm1[0xA]+0x100*Apkm1[0xB])
			Anature1=naturename[Apkm1[0x41]+1]
			Amove11=movenum(Apkm1[0x28]+0x100*Apkm1[0x29])
			Amove12=movenum(Apkm1[0x2A]+0x100*Apkm1[0x2B])
			Amove13=movenum(Apkm1[0x2C]+0x100*Apkm1[0x2D])
			Amove14=movenum(Apkm1[0x2E]+0x100*Apkm1[0x2F])
		print(Aspec1.." ("..Anature1..") @ "..Aitem1)
		print(" - "..Amove11) print(" - "..Amove12) print(" - "..Amove13) print(" - "..Amove14)
			AIVs1=Apkm1[0x38]+Apkm1[0x39]*0x100+Apkm1[0x3A]*0x10000+Apkm1[0x3B]*0x1000000
			Ahpiv1,Aatkiv1,Adefiv1,Aspdiv1,Aspatkiv1,Aspdefiv1=bit.band(AIVs1,0x1F),bit.band(AIVs1,0x1F*0x20)/0x20,bit.band(AIVs1,0x1F*0x400)/0x400,bit.band(AIVs1,0x1F*0x8000)/0x8000,bit.band(AIVs1,0x1F*0x100000)/0x100000,bit.band(AIVs1,0x1F*0x2000000)/0x2000000
			Ahpev1,Aatkev1,Adefev1,Aspaev1,Aspdev1,Aspeev1=Apkm1[0x18],Apkm1[0x19],Apkm1[0x1A],Apkm1[0x1C],Apkm1[0x1D],Apkm1[0x1B]
			Achp1,Acat1,Acde1,Acsp1,Acsa1,Acsd1=Apkm1[0x90]+Apkm1[0x91]*0x100,Apkm1[0x92]+Apkm1[0x93]*0x100,Apkm1[0x94]+Apkm1[0x95]*0x100,Apkm1[0x96]+Apkm1[0x97]*0x100,Apkm1[0x98]+Apkm1[0x99]*0x100,Apkm1[0x9A]+Apkm1[0x9B]*0x100
		print(Ahpiv1.."/"..Aatkiv1.."/"..Adefiv1.."/"..Aspatkiv1.."/"..Aspdefiv1.."/"..Aspdiv1.." // "..Ahpev1.."/"..Aatkev1.."/"..Adefev1.."/"..Aspaev1.."/"..Aspdev1.."/"..Aspeev1)
		print("Stats: "..Achp1.." | "..Acat1.." | "..Acde1.." | "..Acsa1.." | "..Acsd1.." | "..Acsp1)
		print() end
		Apkm2=getpkm(0,2)
			Aspec2=species(Apkm2[8]+0x100*Apkm2[9])
			if Aspec2~="None" then
			Aitem2=helditem(Apkm2[0xA]+0x100*Apkm2[0xB])
			Anature2=naturename[Apkm2[0x41]+1]
			Amove21=movenum(Apkm2[0x28]+0x100*Apkm2[0x29])
			Amove22=movenum(Apkm2[0x2A]+0x100*Apkm2[0x2B])
			Amove23=movenum(Apkm2[0x2C]+0x100*Apkm2[0x2D])
			Amove24=movenum(Apkm2[0x2E]+0x100*Apkm2[0x2F])
		print(Aspec2.." ("..Anature2..") @ "..Aitem2)
		print(" - "..Amove21) print(" - "..Amove22) print(" - "..Amove23) print(" - "..Amove24)
			AIVs2=Apkm2[0x38]+Apkm2[0x39]*0x100+Apkm2[0x3A]*0x10000+Apkm2[0x3B]*0x1000000
			Ahpiv2,Aatkiv2,Adefiv2,Aspdiv2,Aspatkiv2,Aspdefiv2=bit.band(AIVs2,0x1F),bit.band(AIVs2,0x1F*0x20)/0x20,bit.band(AIVs2,0x1F*0x400)/0x400,bit.band(AIVs2,0x1F*0x8000)/0x8000,bit.band(AIVs2,0x1F*0x100000)/0x100000,bit.band(AIVs2,0x1F*0x2000000)/0x2000000
			Ahpev2,Aatkev2,Adefev2,Aspaev2,Aspdev2,Aspeev2=Apkm2[0x18],Apkm2[0x19],Apkm2[0x1A],Apkm2[0x1C],Apkm2[0x1D],Apkm2[0x1B]
			Achp2,Acat2,Acde2,Acsp2,Acsa2,Acsd2=Apkm2[0x90]+Apkm2[0x91]*0x100,Apkm2[0x92]+Apkm2[0x93]*0x100,Apkm2[0x94]+Apkm2[0x95]*0x100,Apkm2[0x96]+Apkm2[0x97]*0x100,Apkm2[0x98]+Apkm2[0x99]*0x100,Apkm2[0x9A]+Apkm2[0x9B]*0x100
		print(Ahpiv2.."/"..Aatkiv2.."/"..Adefiv2.."/"..Aspatkiv2.."/"..Aspdefiv2.."/"..Aspdiv2.." // "..Ahpev2.."/"..Aatkev2.."/"..Adefev2.."/"..Aspaev2.."/"..Aspdev2.."/"..Aspeev2)
		print("Stats: "..Achp2.." | "..Acat2.." | "..Acde2.." | "..Acsa2.." | "..Acsd2.." | "..Acsp2)
		print() end
		Apkm3=getpkm(0,3)
			Aspec3=species(Apkm3[8]+0x100*Apkm3[9])
			if Aspec3~="None" then
			Aitem3=helditem(Apkm3[0xA]+0x100*Apkm3[0xB])
			Anature3=naturename[Apkm3[0x41]+1]
			Amove31=movenum(Apkm3[0x28]+0x100*Apkm3[0x29])
			Amove32=movenum(Apkm3[0x2A]+0x100*Apkm3[0x2B])
			Amove33=movenum(Apkm3[0x2C]+0x100*Apkm3[0x2D])
			Amove34=movenum(Apkm3[0x2E]+0x100*Apkm3[0x2F])
		print(Aspec3.." ("..Anature3..") @ "..Aitem3)
		print(" - "..Amove31) print(" - "..Amove32) print(" - "..Amove33) print(" - "..Amove34)
			AIVs3=Apkm3[0x38]+Apkm3[0x39]*0x100+Apkm3[0x3A]*0x10000+Apkm3[0x3B]*0x1000000
			Ahpiv3,Aatkiv3,Adefiv3,Aspdiv3,Aspatkiv3,Aspdefiv3=bit.band(AIVs3,0x1F),bit.band(AIVs3,0x1F*0x20)/0x20,bit.band(AIVs3,0x1F*0x400)/0x400,bit.band(AIVs3,0x1F*0x8000)/0x8000,bit.band(AIVs3,0x1F*0x100000)/0x100000,bit.band(AIVs3,0x1F*0x2000000)/0x2000000
			Ahpev3,Aatkev3,Adefev3,Aspaev3,Aspdev3,Aspeev3=Apkm3[0x18],Apkm3[0x19],Apkm3[0x1A],Apkm3[0x1C],Apkm3[0x1D],Apkm3[0x1B]
			Achp3,Acat3,Acde3,Acsp3,Acsa3,Acsd3=Apkm3[0x90]+Apkm3[0x91]*0x100,Apkm3[0x92]+Apkm3[0x93]*0x100,Apkm3[0x94]+Apkm3[0x95]*0x100,Apkm3[0x96]+Apkm3[0x97]*0x100,Apkm3[0x98]+Apkm3[0x99]*0x100,Apkm3[0x9A]+Apkm3[0x9B]*0x100
		print(Ahpiv3.."/"..Aatkiv3.."/"..Adefiv3.."/"..Aspatkiv3.."/"..Aspdefiv3.."/"..Aspdiv3.." // "..Ahpev3.."/"..Aatkev3.."/"..Adefev3.."/"..Aspaev3.."/"..Aspdev3.."/"..Aspeev3)
		print("Stats: "..Achp3.." | "..Acat3.." | "..Acde3.." | "..Acsa3.." | "..Acsd3.." | "..Acsp3)
		print() end
		Apkm4=getpkm(0,4)
			Aspec4=species(Apkm4[8]+0x100*Apkm4[9])
			if Aspec4~="None" then
			Aitem4=helditem(Apkm4[0xA]+0x100*Apkm4[0xB])
			Anature4=naturename[Apkm4[0x41]+1]
			Amove41=movenum(Apkm4[0x28]+0x100*Apkm4[0x29])
			Amove42=movenum(Apkm4[0x2A]+0x100*Apkm4[0x2B])
			Amove43=movenum(Apkm4[0x2C]+0x100*Apkm4[0x2D])
			Amove44=movenum(Apkm4[0x2E]+0x100*Apkm4[0x2F])
		print(Aspec4.." ("..Anature4..") @ "..Aitem4)
		print(" - "..Amove41) print(" - "..Amove42) print(" - "..Amove43) print(" - "..Amove44)
			AIVs4=Apkm4[0x38]+Apkm4[0x39]*0x100+Apkm4[0x3A]*0x10000+Apkm4[0x3B]*0x1000000
			Ahpiv4,Aatkiv4,Adefiv4,Aspdiv4,Aspatkiv4,Aspdefiv4=bit.band(AIVs4,0x1F),bit.band(AIVs4,0x1F*0x20)/0x20,bit.band(AIVs4,0x1F*0x400)/0x400,bit.band(AIVs4,0x1F*0x8000)/0x8000,bit.band(AIVs4,0x1F*0x100000)/0x100000,bit.band(AIVs4,0x1F*0x2000000)/0x2000000
			Ahpev4,Aatkev4,Adefev4,Aspaev4,Aspdev4,Aspeev4=Apkm4[0x18],Apkm4[0x19],Apkm4[0x1A],Apkm4[0x1C],Apkm4[0x1D],Apkm4[0x1B]
			Achp4,Acat4,Acde4,Acsp4,Acsa4,Acsd4=Apkm4[0x90]+Apkm4[0x91]*0x100,Apkm4[0x92]+Apkm4[0x93]*0x100,Apkm4[0x94]+Apkm4[0x95]*0x100,Apkm4[0x96]+Apkm4[0x97]*0x100,Apkm4[0x98]+Apkm4[0x99]*0x100,Apkm4[0x9A]+Apkm4[0x9B]*0x100
		print(Ahpiv4.."/"..Aatkiv4.."/"..Adefiv4.."/"..Aspatkiv4.."/"..Aspdefiv4.."/"..Aspdiv4.." // "..Ahpev4.."/"..Aatkev4.."/"..Adefev4.."/"..Aspaev4.."/"..Aspdev4.."/"..Aspeev4)
		print("Stats: "..Achp4.." | "..Acat4.." | "..Acde4.." | "..Acsa4.." | "..Acsd4.." | "..Acsp4)
		print() end
		Apkm5=getpkm(0,5)
			Aspec5=species(Apkm5[8]+0x100*Apkm5[9])
			if Aspec5~="None" then
			Aitem5=helditem(Apkm5[0xA]+0x100*Apkm5[0xB])
			Anature5=naturename[Apkm5[0x41]+1]
			Amove51=movenum(Apkm5[0x28]+0x100*Apkm5[0x29])
			Amove52=movenum(Apkm5[0x2A]+0x100*Apkm5[0x2B])
			Amove53=movenum(Apkm5[0x2C]+0x100*Apkm5[0x2D])
			Amove54=movenum(Apkm5[0x2E]+0x100*Apkm5[0x2F])
		print(Aspec5.." ("..Anature5..") @ "..Aitem5)
		print(" - "..Amove51) print(" - "..Amove52) print(" - "..Amove53) print(" - "..Amove54)
			AIVs5=Apkm5[0x38]+Apkm5[0x39]*0x100+Apkm5[0x3A]*0x10000+Apkm5[0x3B]*0x1000000
			Ahpiv5,Aatkiv5,Adefiv5,Aspdiv5,Aspatkiv5,Aspdefiv5=bit.band(AIVs5,0x1F),bit.band(AIVs5,0x1F*0x20)/0x20,bit.band(AIVs5,0x1F*0x400)/0x400,bit.band(AIVs5,0x1F*0x8000)/0x8000,bit.band(AIVs5,0x1F*0x100000)/0x100000,bit.band(AIVs5,0x1F*0x2000000)/0x2000000
			Ahpev5,Aatkev5,Adefev5,Aspaev5,Aspdev5,Aspeev5=Apkm5[0x18],Apkm5[0x19],Apkm5[0x1A],Apkm5[0x1C],Apkm5[0x1D],Apkm5[0x1B]
			Achp5,Acat5,Acde5,Acsp5,Acsa5,Acsd5=Apkm5[0x90]+Apkm5[0x91]*0x100,Apkm5[0x92]+Apkm5[0x93]*0x100,Apkm5[0x94]+Apkm5[0x95]*0x100,Apkm5[0x96]+Apkm5[0x97]*0x100,Apkm5[0x98]+Apkm5[0x99]*0x100,Apkm5[0x9A]+Apkm5[0x9B]*0x100
		print(Ahpiv5.."/"..Aatkiv5.."/"..Adefiv5.."/"..Aspatkiv5.."/"..Aspdefiv5.."/"..Aspdiv5.." // "..Ahpev5.."/"..Aatkev5.."/"..Adefev5.."/"..Aspaev5.."/"..Aspdev5.."/"..Aspeev5)
		print("Stats: "..Achp5.." | "..Acat5.." | "..Acde5.." | "..Acsa5.." | "..Acsd5.." | "..Acsp5)
		print() end
		Apkm6=getpkm(0,6)
			Aspec6=species(Apkm6[8]+0x100*Apkm6[9])
			if Aspec6~="None" then
			Aitem6=helditem(Apkm6[0xA]+0x100*Apkm6[0xB])
			Anature6=naturename[Apkm5[0x41]+1]
			Amove61=movenum(Apkm6[0x28]+0x100*Apkm6[0x29])
			Amove62=movenum(Apkm6[0x2A]+0x100*Apkm6[0x2B])
			Amove63=movenum(Apkm6[0x2C]+0x100*Apkm6[0x2D])
			Amove64=movenum(Apkm6[0x2E]+0x100*Apkm6[0x2F])
		print(Aspec6.." ("..Anature6..") @ "..Aitem6)
		print(" - "..Amove61) print(" - "..Amove62) print(" - "..Amove63) print(" - "..Amove64)
			AIVs6=Apkm6[0x38]+Apkm6[0x39]*0x100+Apkm6[0x3A]*0x10000+Apkm6[0x3B]*0x1000000
			Ahpiv6,Aatkiv6,Adefiv6,Aspdiv6,Aspatkiv6,Aspdefiv6=bit.band(AIVs6,0x1F),bit.band(AIVs6,0x1F*0x20)/0x20,bit.band(AIVs6,0x1F*0x400)/0x400,bit.band(AIVs6,0x1F*0x8000)/0x8000,bit.band(AIVs6,0x1F*0x100000)/0x100000,bit.band(AIVs2,0x1F*0x2000000)/0x2000000
			Ahpev6,Aatkev6,Adefev6,Aspaev6,Aspdev6,Aspeev6=Apkm6[0x18],Apkm6[0x19],Apkm6[0x1A],Apkm6[0x1C],Apkm6[0x1D],Apkm6[0x1B]
			Achp6,Acat6,Acde6,Acsp6,Acsa6,Acsd6=Apkm6[0x90]+Apkm6[0x91]*0x100,Apkm6[0x92]+Apkm6[0x93]*0x100,Apkm6[0x94]+Apkm6[0x95]*0x100,Apkm6[0x96]+Apkm6[0x97]*0x100,Apkm6[0x98]+Apkm6[0x99]*0x100,Apkm6[0x9A]+Apkm6[0x9B]*0x100
		print(Ahpiv6.."/"..Aatkiv6.."/"..Adefiv6.."/"..Aspatkiv6.."/"..Aspdefiv6.."/"..Aspdiv6.." // "..Ahpev6.."/"..Aatkev6.."/"..Adefev6.."/"..Aspaev6.."/"..Aspdev6.."/"..Aspeev6)
		print("Stats: "..Achp6.." | "..Acat6.." | "..Acde6.." | "..Acsa6.." | "..Acsd6.." | "..Acsp6)
		print() end

print("=====Player 2=====")
		Bpkm1=getpkm(1,1) 
			Bspec1=species(Bpkm1[8]+0x100*Bpkm1[9])
			if Bspec1~="None" then
			Bitem1=helditem(Bpkm1[0xA]+0x100*Bpkm1[0xB])
			Bnature1=naturename[Bpkm1[0x41]+1]
			Bmove11=movenum(Bpkm1[0x28]+0x100*Bpkm1[0x29])
			Bmove12=movenum(Bpkm1[0x2A]+0x100*Bpkm1[0x2B])
			Bmove13=movenum(Bpkm1[0x2C]+0x100*Bpkm1[0x2D])
			Bmove14=movenum(Bpkm1[0x2E]+0x100*Bpkm1[0x2F])
		print(Bspec1.." ("..Bnature1..") @ "..Bitem1)
		print(" - "..Bmove11) print(" - "..Bmove12) print(" - "..Bmove13) print(" - "..Bmove14)
			BIVs1=Bpkm1[0x38]+Bpkm1[0x39]*0x100+Bpkm1[0x3A]*0x10000+Bpkm1[0x3B]*0x1000000
			Bhpiv1,Batkiv1,Bdefiv1,Bspdiv1,Bspatkiv1,Bspdefiv1=bit.band(BIVs1,0x1F),bit.band(BIVs1,0x1F*0x20)/0x20,bit.band(BIVs1,0x1F*0x400)/0x400,bit.band(BIVs1,0x1F*0x8000)/0x8000,bit.band(BIVs1,0x1F*0x100000)/0x100000,bit.band(BIVs1,0x1F*0x2000000)/0x2000000
			Bhpev1,Batkev1,Bdefev1,Bspaev1,Bspdev1,Bspeev1=Bpkm1[0x18],Bpkm1[0x19],Bpkm1[0x1A],Bpkm1[0x1C],Bpkm1[0x1D],Bpkm1[0x1B]
			Bchp1,Bcat1,Bcde1,Bcsp1,Bcsa1,Bcsd1=Bpkm1[0x90]+Bpkm1[0x91]*0x100,Bpkm1[0x92]+Bpkm1[0x93]*0x100,Bpkm1[0x94]+Bpkm1[0x95]*0x100,Bpkm1[0x96]+Bpkm1[0x97]*0x100,Bpkm1[0x98]+Bpkm1[0x99]*0x100,Bpkm1[0x9A]+Bpkm1[0x9B]*0x100
		print(Bhpiv1.."/"..Batkiv1.."/"..Bdefiv1.."/"..Bspatkiv1.."/"..Bspdefiv1.."/"..Bspdiv1.." // "..Bhpev1.."/"..Batkev1.."/"..Bdefev1.."/"..Bspaev1.."/"..Bspdev1.."/"..Bspeev1)
		print("Stats: "..Bchp1.." | "..Bcat1.." | "..Bcde1.." | "..Bcsa1.." | "..Bcsd1.." | "..Bcsp1)	
		print() end
		Bpkm2=getpkm(1,2)
			Bspec2=species(Bpkm2[8]+0x100*Bpkm2[9])
			if Bspec2~="None" then
			Bitem2=helditem(Bpkm2[0xA]+0x100*Bpkm2[0xB])
			Bnature2=naturename[Bpkm2[0x41]+1]
			Bmove21=movenum(Bpkm2[0x28]+0x100*Bpkm2[0x29])
			Bmove22=movenum(Bpkm2[0x2A]+0x100*Bpkm2[0x2B])
			Bmove23=movenum(Bpkm2[0x2C]+0x100*Bpkm2[0x2D])
			Bmove24=movenum(Bpkm2[0x2E]+0x100*Bpkm2[0x2F])
		print(Bspec2.." ("..Bnature2..") @ "..Bitem2)
		print(" - "..Bmove21) print(" - "..Bmove22) print(" - "..Bmove23) print(" - "..Bmove24)
			BIVs2=Bpkm2[0x38]+Bpkm2[0x39]*0x100+Bpkm2[0x3A]*0x10000+Bpkm2[0x3B]*0x1000000
			Bhpiv2,Batkiv2,Bdefiv2,Bspdiv2,Bspatkiv2,Bspdefiv2=bit.band(BIVs2,0x1F),bit.band(BIVs2,0x1F*0x20)/0x20,bit.band(BIVs2,0x1F*0x400)/0x400,bit.band(BIVs2,0x1F*0x8000)/0x8000,bit.band(BIVs2,0x1F*0x100000)/0x100000,bit.band(BIVs2,0x1F*0x2000000)/0x2000000
			Bhpev2,Batkev2,Bdefev2,Bspaev2,Bspdev2,Bspeev2=Bpkm2[0x18],Bpkm2[0x19],Bpkm2[0x1A],Bpkm2[0x1C],Bpkm2[0x1D],Bpkm2[0x1B]
			Bchp2,Bcat2,Bcde2,Bcsp2,Bcsa2,Bcsd2=Bpkm2[0x90]+Bpkm2[0x91]*0x200,Bpkm2[0x92]+Bpkm2[0x93]*0x100,Bpkm2[0x94]+Bpkm2[0x95]*0x100,Bpkm2[0x96]+Bpkm2[0x97]*0x100,Bpkm2[0x98]+Bpkm2[0x99]*0x100,Bpkm2[0x9A]+Bpkm2[0x9B]*0x100
		print(Bhpiv2.."/"..Batkiv2.."/"..Bdefiv2.."/"..Bspatkiv2.."/"..Bspdefiv2.."/"..Bspdiv2.." // "..Bhpev2.."/"..Batkev2.."/"..Bdefev2.."/"..Bspaev2.."/"..Bspdev2.."/"..Bspeev2)
		print("Stats: "..Bchp2.." | "..Bcat2.." | "..Bcde2.." | "..Bcsa2.." | "..Bcsd2.." | "..Bcsp2)	
		print() end
		Bpkm3=getpkm(1,3)
			Bspec3=species(Bpkm3[8]+0x100*Bpkm3[9])
			if Bspec3~="None" then
			Bitem3=helditem(Bpkm3[0xA]+0x100*Bpkm3[0xB])
			Bnature3=naturename[Bpkm3[0x41]+1]
			Bmove31=movenum(Bpkm3[0x28]+0x100*Bpkm3[0x29])
			Bmove32=movenum(Bpkm3[0x2A]+0x100*Bpkm3[0x2B])
			Bmove33=movenum(Bpkm3[0x2C]+0x100*Bpkm3[0x2D])
			Bmove34=movenum(Bpkm3[0x2E]+0x100*Bpkm3[0x2F])
		print(Bspec3.." ("..Bnature3..") @ "..Bitem3)
		print(" - "..Bmove31) print(" - "..Bmove32) print(" - "..Bmove33) print(" - "..Bmove34)
			BIVs3=Bpkm3[0x38]+Bpkm3[0x39]*0x100+Bpkm3[0x3A]*0x10000+Bpkm3[0x3B]*0x1000000
			Bhpiv3,Batkiv3,Bdefiv3,Bspdiv3,Bspatkiv3,Bspdefiv3=bit.band(BIVs3,0x1F),bit.band(BIVs3,0x1F*0x20)/0x20,bit.band(BIVs3,0x1F*0x400)/0x400,bit.band(BIVs3,0x1F*0x8000)/0x8000,bit.band(BIVs3,0x1F*0x100000)/0x100000,bit.band(BIVs3,0x1F*0x2000000)/0x2000000
			Bhpev3,Batkev3,Bdefev3,Bspaev3,Bspdev3,Bspeev3=Bpkm3[0x18],Bpkm3[0x19],Bpkm3[0x1A],Bpkm3[0x1C],Bpkm3[0x1D],Bpkm3[0x1B]
			Bchp3,Bcat3,Bcde3,Bcsp3,Bcsa3,Bcsd3=Bpkm3[0x90]+Bpkm3[0x91]*0x100,Bpkm3[0x92]+Bpkm3[0x93]*0x100,Bpkm3[0x94]+Bpkm3[0x95]*0x100,Bpkm3[0x96]+Bpkm3[0x97]*0x100,Bpkm3[0x98]+Bpkm3[0x99]*0x100,Bpkm3[0x9A]+Bpkm3[0x9B]*0x100
		print(Bhpiv3.."/"..Batkiv3.."/"..Bdefiv3.."/"..Bspatkiv3.."/"..Bspdefiv3.."/"..Bspdiv3.." // "..Bhpev3.."/"..Batkev3.."/"..Bdefev3.."/"..Bspaev3.."/"..Bspdev3.."/"..Bspeev3)
		print("Stats: "..Bchp3.." | "..Bcat3.." | "..Bcde3.." | "..Bcsa3.." | "..Bcsd3.." | "..Bcsp3)	
		print() end
		Bpkm4=getpkm(1,4)
			Bspec4=species(Bpkm4[8]+0x100*Bpkm4[9])
			if Bspec4~="None" then
			Bitem4=helditem(Bpkm4[0xA]+0x100*Bpkm4[0xB])
			Bnature4=naturename[Bpkm4[0x41]+1]
			Bmove41=movenum(Bpkm4[0x28]+0x100*Bpkm4[0x29])
			Bmove42=movenum(Bpkm4[0x2A]+0x100*Bpkm4[0x2B])
			Bmove43=movenum(Bpkm4[0x2C]+0x100*Bpkm4[0x2D])
			Bmove44=movenum(Bpkm4[0x2E]+0x100*Bpkm4[0x2F])
		print(Bspec4.." ("..Bnature4..") @ "..Bitem4)
		print(" - "..Bmove41) print(" - "..Bmove42) print(" - "..Bmove43) print(" - "..Bmove44)
			BIVs4=Bpkm4[0x38]+Bpkm4[0x39]*0x100+Bpkm4[0x3A]*0x10000+Bpkm4[0x3B]*0x1000000
			Bhpiv4,Batkiv4,Bdefiv4,Bspdiv4,Bspatkiv4,Bspdefiv4=bit.band(BIVs4,0x1F),bit.band(BIVs4,0x1F*0x20)/0x20,bit.band(BIVs4,0x1F*0x400)/0x400,bit.band(BIVs4,0x1F*0x8000)/0x8000,bit.band(BIVs4,0x1F*0x100000)/0x100000,bit.band(BIVs4,0x1F*0x2000000)/0x2000000
			Bhpev4,Batkev4,Bdefev4,Bspaev4,Bspdev4,Bspeev4=Bpkm4[0x18],Bpkm4[0x19],Bpkm4[0x1A],Bpkm4[0x1C],Bpkm4[0x1D],Bpkm4[0x1B]
			Bchp4,Bcat4,Bcde4,Bcsp4,Bcsa4,Bcsd4=Bpkm4[0x90]+Bpkm4[0x91]*0x100,Bpkm4[0x92]+Bpkm4[0x93]*0x100,Bpkm4[0x94]+Bpkm4[0x95]*0x100,Bpkm4[0x96]+Bpkm4[0x97]*0x100,Bpkm4[0x98]+Bpkm4[0x99]*0x100,Bpkm4[0x9A]+Bpkm4[0x9B]*0x100
		print(Bhpiv4.."/"..Batkiv4.."/"..Bdefiv4.."/"..Bspatkiv4.."/"..Bspdefiv4.."/"..Bspdiv4.." // "..Bhpev4.."/"..Batkev4.."/"..Bdefev4.."/"..Bspaev4.."/"..Bspdev4.."/"..Bspeev4)
		print("Stats: "..Bchp4.." | "..Bcat4.." | "..Bcde4.." | "..Bcsa4.." | "..Bcsd4.." | "..Bcsp4)	
		print() end
		Bpkm5=getpkm(1,5)
			Bspec5=species(Bpkm5[8]+0x100*Bpkm5[9])
			if Bspec5~="None" then
			Bitem5=helditem(Bpkm5[0xA]+0x100*Bpkm5[0xB])
			Bnature5=naturename[Bpkm5[0x41]+1]
			Bmove51=movenum(Bpkm5[0x28]+0x100*Bpkm5[0x29])
			Bmove52=movenum(Bpkm5[0x2A]+0x100*Bpkm5[0x2B])
			Bmove53=movenum(Bpkm5[0x2C]+0x100*Bpkm5[0x2D])
			Bmove54=movenum(Bpkm5[0x2E]+0x100*Bpkm5[0x2F])
		print(Bspec5.." ("..Bnature5..") @ "..Bitem5)
		print(" - "..Bmove51) print(" - "..Bmove52) print(" - "..Bmove53) print(" - "..Bmove54)
			BIVs5=Bpkm5[0x38]+Bpkm5[0x39]*0x100+Bpkm5[0x3A]*0x10000+Bpkm5[0x3B]*0x1000000
			Bhpiv5,Batkiv5,Bdefiv5,Bspdiv5,Bspatkiv5,Bspdefiv5=bit.band(BIVs5,0x1F),bit.band(BIVs5,0x1F*0x20)/0x20,bit.band(BIVs5,0x1F*0x400)/0x400,bit.band(BIVs5,0x1F*0x8000)/0x8000,bit.band(BIVs5,0x1F*0x100000)/0x100000,bit.band(BIVs5,0x1F*0x2000000)/0x2000000
			Bhpev5,Batkev5,Bdefev5,Bspaev5,Bspdev5,Bspeev5=Bpkm5[0x18],Bpkm5[0x19],Bpkm5[0x1A],Bpkm5[0x1C],Bpkm5[0x1D],Bpkm5[0x1B]
			Bchp5,Bcat5,Bcde5,Bcsp5,Bcsa5,Bcsd5=Bpkm5[0x90]+Bpkm5[0x91]*0x100,Bpkm5[0x92]+Bpkm5[0x93]*0x100,Bpkm5[0x94]+Bpkm5[0x95]*0x100,Bpkm5[0x96]+Bpkm5[0x97]*0x100,Bpkm5[0x98]+Bpkm5[0x99]*0x100,Bpkm5[0x9A]+Bpkm5[0x9B]*0x100
		print(Bhpiv5.."/"..Batkiv5.."/"..Bdefiv5.."/"..Bspatkiv5.."/"..Bspdefiv5.."/"..Bspdiv5.." // "..Bhpev5.."/"..Batkev5.."/"..Bdefev5.."/"..Bspaev5.."/"..Bspdev5.."/"..Bspeev5)
		print("Stats: "..Bchp5.." | "..Bcat5.." | "..Bcde5.." | "..Bcsa5.." | "..Bcsd5.." | "..Bcsp5)	
		print() end
		Bpkm6=getpkm(1,6)
			Bspec6=species(Bpkm6[8]+0x100*Bpkm6[9])
			if Bspec6~="None" then
			Bitem6=helditem(Bpkm6[0xA]+0x100*Bpkm6[0xB])
			Bnature6=naturename[Bpkm6[0x41]+1]
			Bmove61=movenum(Bpkm6[0x28]+0x100*Bpkm6[0x29])
			Bmove62=movenum(Bpkm6[0x2A]+0x100*Bpkm6[0x2B])
			Bmove63=movenum(Bpkm6[0x2C]+0x100*Bpkm6[0x2D])
			Bmove64=movenum(Bpkm6[0x2E]+0x100*Bpkm6[0x2F])
		print(Bspec6.." ("..Bnature6..") @ "..Bitem6)
		print(" - "..Bmove61) print(" - "..Bmove62) print(" - "..Bmove63) print(" - "..Bmove64)
			BIVs6=Bpkm6[0x38]+Bpkm6[0x39]*0x100+Bpkm6[0x3A]*0x10000+Bpkm6[0x3B]*0x1000000
			Bhpiv6,Batkiv6,Bdefiv6,Bspdiv6,Bspatkiv6,Bspdefiv6=bit.band(BIVs6,0x1F),bit.band(BIVs6,0x1F*0x20)/0x20,bit.band(BIVs6,0x1F*0x400)/0x400,bit.band(BIVs6,0x1F*0x8000)/0x8000,bit.band(BIVs6,0x1F*0x100000)/0x100000,bit.band(BIVs6,0x1F*0x2000000)/0x2000000
			Bhpev6,Batkev6,Bdefev6,Bspaev6,Bspdev6,Bspeev6=Bpkm6[0x18],Bpkm6[0x19],Bpkm6[0x1A],Bpkm6[0x1C],Bpkm6[0x1D],Bpkm6[0x1B]
			Bchp6,Bcat6,Bcde6,Bcsp6,Bcsa6,Bcsd6=Bpkm6[0x90]+Bpkm6[0x91]*0x100,Bpkm6[0x92]+Bpkm6[0x93]*0x100,Bpkm6[0x94]+Bpkm6[0x95]*0x100,Bpkm6[0x96]+Bpkm6[0x97]*0x100,Bpkm6[0x98]+Bpkm6[0x99]*0x100,Bpkm6[0x9A]+Bpkm6[0x9B]*0x100
		print(Bhpiv6.."/"..Batkiv6.."/"..Bdefiv6.."/"..Bspatkiv6.."/"..Bspdefiv6.."/"..Bspdiv6.." // "..Bhpev6.."/"..Batkev6.."/"..Bdefev6.."/"..Bspaev6.."/"..Bspdev6.."/"..Bspeev6)
		print("Stats: "..Bchp6.." | "..Bcat6.." | "..Bcde6.." | "..Bcsa6.." | "..Bcsd6.." | "..Bcsp6)	
		print() end

		
		--Arrange a Speed Table
		speedlist={}
		sA1={spe=Acsp1,Aspec1,Acsp1,1} ti(speedlist, sA1)
		if Aspec2~="None" then sA2={spe=Acsp2,Aspec2,Acsp2,1} ti(speedlist, sA2) end
		if Aspec3~="None" then sA3={spe=Acsp3,Aspec3,Acsp3,1} ti(speedlist, sA3) end
		if Aspec4~="None" then sA4={spe=Acsp4,Aspec4,Acsp4,1} ti(speedlist, sA4) end
		if Aspec5~="None" then sA5={spe=Acsp5,Aspec5,Acsp5,1} ti(speedlist, sA5) end
		if Aspec6~="None" then sA6={spe=Acsp6,Aspec6,Acsp6,1} ti(speedlist, sA6) end
		sB1={spe=Bcsp1,Bspec1,Bcsp1,2} ti(speedlist, sB1)
		if Bspec2~="None" then sB2={spe=Bcsp2,Bspec2,Bcsp2,2} ti(speedlist, sB2) end 
		if Bspec3~="None" then sB3={spe=Bcsp3,Bspec3,Bcsp3,2} ti(speedlist, sB3) end
		if Bspec4~="None" then sB4={spe=Bcsp4,Bspec4,Bcsp4,2} ti(speedlist, sB4) end
		if Bspec5~="None" then sB5={spe=Bcsp5,Bspec5,Bcsp5,2} ti(speedlist, sB5) end
		if Bspec6~="None" then sB6={spe=Bcsp6,Bspec6,Bcsp6,2} ti(speedlist, sB6) end
		--Sort the Speed Table from Fastest->Slowest
		ts(speedlist,function (v1, v2)
             return v1.spe > v2.spe
           end)
		--Count the # of Pokemon in the Battle
		pkmcount=tl(speedlist)
		
		--Done with loading of PKM data.
		snagemrdy=0 
		display=0
		end
    end

if (snagemrdy==0 and table.start) then 
	print("==POWERING UP SNAG MACHINE==")
	snagemrdy=2 -- PKMs ripped

	
	

	end

if (display==0 and table.L) then 
			gt(0,0,sf("Turn Ordering (Speed)"))
	for i=1,pkmcount do
			gt(0,i*10,sf("%d: #P%d's %10s @%d",i,speedlist[i][3],speedlist[i][1],speedlist[i][2]))
end
end
	
end


gui.register(main)