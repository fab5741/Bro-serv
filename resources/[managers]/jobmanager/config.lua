config = {
    jobs = {
        farm = {
            color= 24,
            label= "Fermiers",
            lockers = {
                {
                    coords = vector3(2030.2646484375,4979.7456054688,42.098190307617),
                    sprite = 366,
                    action = "lockers",
                }
            },
            collect = {
                {
                    coords = vector3(2572.38, 4523.48, 35.2),
                    sprite = 496,
                    action = "collect",
                    items = {
                       {name="wheat", label="Blé", amount="1", type="16"},
                    }
                }
            },
            process = {
                {
                    coords = vector3(463.28,3566.37,32.2),
                    sprite = 502,
                    action = "process",
                    items = {
                        {name="wheat", label="Blé", amount="1", type="16", to="15", amountTo="1"},
                    }
                },
                {
                    coords = vector3(470.25,3565.63,32.45),
                    sprite = 503,
                    action = "process",
                    items = {
                        {name="flour", label="Farine", amount="1", type="15", to="13", amountTo="1"},
                    }
                }
             },
            safes = {
                {
                    coords = vector3(2016.3625488281,4986.939453125,42.098285675049),
                    sprite = 568,
                    action = "safe",
                }
            },
            parking = {
                {
                    coords = vector3(2035.1791992188,4989.015625,39.695823669434),
                    spawn = vector3(2036.4399414062,4986.6323242188,40.001270294189),
                    heading = -100.0,
                    sprite = 524,
                    action = "parking",
                }
            },
            grades = {
                stagiaire = {
                    label= "Stagiaire",
                    skin_male = {
                        tshirt_1 = 58,  tshirt_2 = 1,
                        torso_1 = 22,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 0,
                        pants_1 = 10,   pants_2 = 0,
                        shoes_1 = 22,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = -1,    chain_2 = 0,
                        ears_1 = -1,     ears_2 = 0
                    },
                    skin_female = {
                        tshirt_1 = 58,  tshirt_2 = 1,
                        torso_1 = 22,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 0,
                        pants_1 = 10,   pants_2 = 0,
                        shoes_1 = 22,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = -1,    chain_2 = 0,
                        ears_1 = -1,     ears_2 = 0
                    }
               }
            }
        },
        wine = {
            color = 50,
            label= "Vignerons",
            lockers = {
                {
                    coords = vector3(-1921.0443115234,2054.7062988281,140.73498535156),
                    sprite = 496,
                    action = "lockers",
                }
            },
            collect = {
                {
                    coords = vector3(-1819.93,2134.48,123.8),
                    sprite = 502,
                    items = {
                        {name="Raisin", label="Raisin", amount="1", type="18"},
                     }
                }
            },
            process = {
                {
                coords = vector3(1731.98,3031.5,61.5),
				sprite = 503,
                action = "process",
                items = {
                    {name="Raisin", label="Raisin", amount="1", type="18", to="19", amountTo="1"},
                }
            }
            },
            sell = {
                {
                    coords = vector3(1211.98,-1256.05,34.1),
                    sprite = 504,
                    action = "sell",
                    items = {
                        {name="Jus de raisin", label="Jus de raisin", amount="1", type="19", price="2"},
                    }
                }
            },
            parking = {
                {
                    coords = vector3(-1924.4694824219,2041.6114501953,140.73466491699),
                    spawn = vector3(-1921.9117431641,2040.6607666016,140.73532104492),
                    heading = -100.0,
                    sprite = 524,
                }
            },
            grades = {
                stagiaire = {
                    label= "Stagiaire",
                    skin_male = {
                        tshirt_1 = 19,  tshirt_2 = 1,
                        torso_1 = 55,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 41,
                        pants_1 = 5,   pants_2 = 0,
                        shoes_1 = 25,   shoes_2 = 0,
                        helmet_1 = 46,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    },
                    skin_female = {
                        tshirt_1 = 36,  tshirt_2 = 1,
                        torso_1 = 48,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 44,
                        pants_1 = 34,   pants_2 = 0,
                        shoes_1 = 27,   shoes_2 = 0,
                        helmet_1 = 45,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    }
               }
            },
        },
        bennys = {
            label= "Benny's",
            color = 6,
            lockers = {
                {
                    coords = vector3(-207.11326599121,-1338.4561767578,34.894428253174),
                    sprite = 366,
                }
            },
            homes = {
                {
                    coords = vector3(-202.81202697754,-1308.4766845703,31.292528152466),
                    sprite = 446,
                },
            },
            parking = {
                {
                    coords = vector3(-191.55186462402,-1289.8022460938,31.295974731445),
                    spawn = vector3(-189.26739501953,-1289.5209960938,31.295974731445),
                    heading = -15.0,
                    sprite = 357,
                }
            },
            repair = {
                {
                    coords = vector3(-221.8670501709,-1324.2938232422,30.890529632568),
                    sprite = 357,
                },
                {
                    coords = vector3(-222.41114807129,-1329.1971435547,30.890409469604),
                    sprite = 357,
                },                
            },
            custom = {
                {
                    coords= vector3(-199.30871582031,-1324.3264160156,30.715106964111),
                    sprite = 357,
                }
            },
            safes = {
                {
                    coords = vector3(-204.34022521973,-1327.9340820312,34.894428253174),
                    sprite = 568,
                    action = "safe",
                }
            },
            
        },
        lsms = {
            label = "Hopital",
            color = 1, 
            lockers = {
                {
                    coords = vector3(336.27508544922, -580.03137207031, 28.791479110718),
                    blip = {
                    sprite = 51,
                    scale  = 0.4,
                    color  = 5,
                    string = "locker",
                    },
                    action = "lockers",
                }
            },
            parking = {
                {
                    coords = vector3(339.56744384766,-562.45819091797,28.743431091309),
                    spawn = vector3(344.1618347168, -556.84796142578, 28.743431091309),
                    heading = -15.0,
                    blip = {
                        sprite = 357,
                        scale  = 1.2,
                        color  = 5,
                        string = "Parking",
                    },
                    action = "parking",
                }
            },
            homes = {
                {
                    coords = vector3(341.41842651367,-582.73522949219,28.791477203369),
                    sprite = 61,
                },
            },
            grades = {
                stagiaire = {
                    label= "Stagiaire",
                    skin_male = {
                        tshirt_1 = 59,  tshirt_2 = 1,
                        torso_1 = 55,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 41,
                        pants_1 = 25,   pants_2 = 0,
                        shoes_1 = 25,   shoes_2 = 0,
                        helmet_1 = 46,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    },
                    skin_female = {
                        tshirt_1 = 36,  tshirt_2 = 1,
                        torso_1 = 48,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 44,
                        pants_1 = 34,   pants_2 = 0,
                        shoes_1 = 27,   shoes_2 = 0,
                        helmet_1 = 45,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    }
               }
            }
        },
        lspd = {
            label= "LSPD",
            color = 77,
            lockers = {
                {
                    coords = vector3(457.06948852539,-992.75042724609,30.689332962036),
                    sprite = 51,
                }
            },
            parking = {
                {
                    coords = vector3(455.12176513672,-1020.779296875,28.307716369629),
                    spawn = vector3(452.06982421875,-1020.469909668,28.381450653076),
                    heading = 90.0,
                    sprite = 357,
                    action = "parking",
                }
            },
            armories = {
                {
                    coords = vector3(451.75173950195,-980.27758789062,30.689315795898),
                    sprite = 110,
                    action = "armories",
                },
            },
            homes = {
                {
                    coords = vector3(441.18566894531,-981.09637451172,30.689331054688),
                    sprite = 60,
                    action = "homes",
                },
            },
            clothes = {
                {
                    male = {
                        tshirt_1 = 29,  tshirt_2 = 1,
                        torso_1 = 55,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 41,
                        pants_1 = 25,   pants_2 = 0,
                        shoes_1 = 25,   shoes_2 = 0,
                        helmet_1 = 46,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    },
                    female = {
                        tshirt_1 = 36,  tshirt_2 = 1,
                        torso_1 = 48,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 44,
                        pants_1 = 34,   pants_2 = 0,
                        shoes_1 = 27,   shoes_2 = 0,
                        helmet_1 = 45,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    }
                },
            
                {
                    male = {
                        tshirt_1 = 58,  tshirt_2 = 0,
                        torso_1 = 55,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 41,
                        pants_1 = 25,   pants_2 = 0,
                        shoes_1 = 25,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    },
                    female = {
                        tshirt_1 = 35,  tshirt_2 = 0,
                        torso_1 = 48,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 44,
                        pants_1 = 34,   pants_2 = 0,
                        shoes_1 = 27,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    }
                },
            
                {
                    male = {
                        tshirt_1 = 58,  tshirt_2 = 0,
                        torso_1 = 55,   torso_2 = 0,
                        decals_1 = 8,   decals_2 = 1,
                        arms = 41,
                        pants_1 = 25,   pants_2 = 0,
                        shoes_1 = 25,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    },
                    female = {
                        tshirt_1 = 35,  tshirt_2 = 0,
                        torso_1 = 48,   torso_2 = 0,
                        decals_1 = 7,   decals_2 = 1,
                        arms = 44,
                        pants_1 = 34,   pants_2 = 0,
                        shoes_1 = 27,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    }
                },
            
                 {
                    male = {
                        tshirt_1 = 58,  tshirt_2 = 0,
                        torso_1 = 55,   torso_2 = 0,
                        decals_1 = 8,   decals_2 = 2,
                        arms = 41,
                        pants_1 = 25,   pants_2 = 0,
                        shoes_1 = 25,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    },
                    female = {
                        tshirt_1 = 35,  tshirt_2 = 0,
                        torso_1 = 48,   torso_2 = 0,
                        decals_1 = 7,   decals_2 = 2,
                        arms = 44,
                        pants_1 = 34,   pants_2 = 0,
                        shoes_1 = 27,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    }
                },
            
                 {
                    male = {
                        tshirt_1 = 58,  tshirt_2 = 0,
                        torso_1 = 55,   torso_2 = 0,
                        decals_1 = 8,   decals_2 = 3,
                        arms = 41,
                        pants_1 = 25,   pants_2 = 0,
                        shoes_1 = 25,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    },
                    female = {
                        tshirt_1 = 35,  tshirt_2 = 0,
                        torso_1 = 48,   torso_2 = 0,
                        decals_1 = 7,   decals_2 = 3,
                        arms = 44,
                        pants_1 = 34,   pants_2 = 0,
                        shoes_1 = 27,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    }
                },
            
                bullet_wear = {
                    male = {
                        bproof_1 = 11,  bproof_2 = 1
                    },
                    female = {
                        bproof_1 = 13,  bproof_2 = 1
                    }
                },
            
                gilet_wear = {
                    male = {
                        tshirt_1 = 59,  tshirt_2 = 1
                    },
                    female = {
                        tshirt_1 = 36,  tshirt_2 = 1
                    }
                }
            },
            safes = {
                {
                    coords = vector3(455.04360961914,-985.53869628906,30.689321517944),
                    sprite = 568,

                }
            }
        },
        newspapers = {
            color = 38,
            begin = {
                {
                    coords = vector3(-259.20123291016,-843.56219482422,31.425704956055),
                    sprite = 77,
                    vehicle = "faggio2",   
                    points = {
                        vector3(-9.6269121170044,-933.23095703125,28.610500335693),
                        vector3(-204.26544189453,-871.72583007812,28.523958206177),
                        vector3(-246.22706604004,-856.7431640625,30.223611831665),
                        vector3(-208.65725708008,-909.98797607422,28.573404312134),
                        vector3(-266.82562255859,-1070.8291015625,24.429290771484),
                        vector3(-231.29083251953,-972.81317138672,28.48454284668),
                        vector3(-296.35604858398,-1129.5743408203,22.336755752563),
                        vector3(-522.25775146484,-731.19079589844,32.092609405518),
                        vector3(-526.802734375,-669.75030517578,32.579597473145),
                        vector3(-619.23742675781,-430.0544128418,33.96061706543),
                        vector3(-558.88055419922,-384.99124145508,34.304138183594),
                        vector3(-539.65258789062,-346.47631835938,34.442798614502),
                        vector3(-534.94354248047,-299.18493652344,34.543766021729),
                        vector3(-444.06240844727,-269.24722290039,35.15958404541),
                        vector3(-384.9345703125,-316.759765625,32.278335571289),
                        vector3(-37.080657958984,-1378.0031738281,28.639272689819),
                        vector3(147.62913513184,-1422.3087158203,28.494981765747),
                        vector3(334.73934936523,-1126.4512939453,28.61351776123),
                        vector3(411.30270385742,-884.18518066406,28.617965698242),
                        vector3(400.95797729492,-830.55902099609,28.48770904541),
                        vector3(371.31362915039,-867.85681152344,28.482044219971),
                        vector3(318.81301879883,-810.21929931641,28.488475799561),
                        vector3(338.70162963867,-753.50305175781,28.624492645264),
                        vector3(378.11676025391,-597.23791503906,27.965169906616),
                        vector3(256.13455200195,-631.11187744141,40.195751190186),
                        vector3(194.26881408691,-796.43096923828,30.617645263672),
                        vector3(153.6530456543,-796.46130371094,30.403112411499),
                        vector3(143.79684448242,-821.97973632812,30.327301025391),
                        vector3(208.09375,-849.59704589844,29.755325317383),
                        vector3(231.30752563477,-857.87524414062,29.175718307495),
                        vector3(265.41815185547,-879.72076416016,28.332345962524),
                        vector3(289.90130615234,-892.51574707031,28.216381072998),
                        vector3(244.9288482666,-937.8642578125,28.472034454346),
                        vector3(263.20147705078,-966.50274658203,28.563957214355),
                        vector3(248.78988647461,-1004.2907714844,28.458633422852),
                        vector3(196.68772888184,-1022.174987793,28.68963432312),
                        vector3(127.49024200439,-981.8857421875,28.629041671753),
                        vector3(117.23706817627,-929.90173339844,29.04327583313),
                        vector3(154.27522277832,-907.86505126953,29.443170547485),       
                    }               
                }
            }
        },
        taxi = {
            label = "Taxis",
            color = 46,
            lockers = {
                {
                    coords = vector3(895.21557617188,-179.61032104492,74.700332641602),
                    sprite = 51,
                }
            },
            safes = {
                {
                    coords = vector3(902.99401855469,-154.02682495117,83.497840881348),
                    sprite = 568,
                }
            },
            parking = {
                {
                    coords = vector3(899.93090820312,-173.07524108887,74.034690856934),
                    spawn = vector3(906.25860595703,-185.95358276367,74.002990722656),
                    heading = 90.0,
                    sprite = 357,
                }
            },
            homes = {
                {
                    coords = vector3(903.41430664062,-178.53988647461,74.006706237793),
                    sprite = 198,
                },
                {
                    coords = vector3(-1026.3032226562,-2728.6811523438,13.616314888),
                    sprite = 198,
                },
            },
            clothes = {
                {
                    male = {
                        tshirt_1 = 29,  tshirt_2 = 1,
                        torso_1 = 55,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 41,
                        pants_1 = 25,   pants_2 = 0,
                        shoes_1 = 25,   shoes_2 = 0,
                        helmet_1 = 46,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    },
                    female = {
                        tshirt_1 = 36,  tshirt_2 = 1,
                        torso_1 = 48,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 44,
                        pants_1 = 34,   pants_2 = 0,
                        shoes_1 = 27,   shoes_2 = 0,
                        helmet_1 = 45,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    }
                },
            
                {
                    male = {
                        tshirt_1 = 58,  tshirt_2 = 0,
                        torso_1 = 55,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 41,
                        pants_1 = 25,   pants_2 = 0,
                        shoes_1 = 25,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    },
                    female = {
                        tshirt_1 = 35,  tshirt_2 = 0,
                        torso_1 = 48,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 44,
                        pants_1 = 34,   pants_2 = 0,
                        shoes_1 = 27,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    }
                },
            
                {
                    male = {
                        tshirt_1 = 58,  tshirt_2 = 0,
                        torso_1 = 55,   torso_2 = 0,
                        decals_1 = 8,   decals_2 = 1,
                        arms = 41,
                        pants_1 = 25,   pants_2 = 0,
                        shoes_1 = 25,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    },
                    female = {
                        tshirt_1 = 35,  tshirt_2 = 0,
                        torso_1 = 48,   torso_2 = 0,
                        decals_1 = 7,   decals_2 = 1,
                        arms = 44,
                        pants_1 = 34,   pants_2 = 0,
                        shoes_1 = 27,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    }
                },
            
                 {
                    male = {
                        tshirt_1 = 58,  tshirt_2 = 0,
                        torso_1 = 55,   torso_2 = 0,
                        decals_1 = 8,   decals_2 = 2,
                        arms = 41,
                        pants_1 = 25,   pants_2 = 0,
                        shoes_1 = 25,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    },
                    female = {
                        tshirt_1 = 35,  tshirt_2 = 0,
                        torso_1 = 48,   torso_2 = 0,
                        decals_1 = 7,   decals_2 = 2,
                        arms = 44,
                        pants_1 = 34,   pants_2 = 0,
                        shoes_1 = 27,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    }
                },
            
                 {
                    male = {
                        tshirt_1 = 58,  tshirt_2 = 0,
                        torso_1 = 55,   torso_2 = 0,
                        decals_1 = 8,   decals_2 = 3,
                        arms = 41,
                        pants_1 = 25,   pants_2 = 0,
                        shoes_1 = 25,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    },
                    female = {
                        tshirt_1 = 35,  tshirt_2 = 0,
                        torso_1 = 48,   torso_2 = 0,
                        decals_1 = 7,   decals_2 = 3,
                        arms = 44,
                        pants_1 = 34,   pants_2 = 0,
                        shoes_1 = 27,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    }
                },
            
                bullet_wear = {
                    male = {
                        bproof_1 = 11,  bproof_2 = 1
                    },
                    female = {
                        bproof_1 = 13,  bproof_2 = 1
                    }
                },
            
                gilet_wear = {
                    male = {
                        tshirt_1 = 59,  tshirt_2 = 1
                    },
                    female = {
                        tshirt_1 = 36,  tshirt_2 = 1
                    }
                }
            },
        }
    },
    center = {
        color = 37,
        pos = vector3(-234.76637268066,-920.52563476562,32.312194824219),
        sprite = 475,
        jobs = {
            {
                name = "NEWSPAPERS",
                label = "Livreurs de journaux",
            }
        }
    }
}

config.DrawDistance               = 20.0 -- How close do you need to be in order for the markers to be drawn (in GTA units).

config.Marker                     = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}

config.bindings = {
    interact_position = 51, -- E
    use_job_menu = 166, -- F5
    accept_fine = 246, -- Y
    refuse_fine = 45 -- R
}