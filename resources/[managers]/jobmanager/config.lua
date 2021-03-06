Config = {
    jobs = {
        farm = {
            color= 24,
            red = 10,
            blue = 10,
            green = 250,
            lockers = {
                {
                    coords = vector3(2030.2646484375,4979.7456054688,42.098190307617),
                    sprite = 366,
                }
            },
            collect = {
                {
                    coords = vector3(2572.7346191406,4524.150390625,36.249584197998),
                    sprite = 496,
                    items = {
                       {name="wheat", label="Blé", amount=5, type="1"},
                    }
                }
            },
            process = {
                {
                    coords = vector3(461.15081787109,3566.9060058594,33.441032409668),
                    sprite = 502,
                    items = {
                        {name="wheat", label="Blé -> Farine", amount=5, type="1", to="2", amountTo=5},
                    }
                },
                {
                    coords = vector3(470.29010009766,3566.115234375,33.238590240479),
                    sprite = 503,
                    items = {
                        {name="flour", label="Farine -> Bro'Bab", amount=5, type="2", to="3", amountTo=5},
                    }
                }
             },
             sell = {
                sprite = 366,
                items = {
                    {label = "Bro'Bab", type = 3, amount = 5, price = 5}
                },
                maxSold = 100,
                pos = {
                    {
                        coords = vector3(25.886821746826,-1339.4995117188,29.497024536133),
                    },
                    {
                        coords = vector3(25.886821746826,-1339.4995117188,29.497024536133)
                    },
                    {
                        coords = vector3(25.886821746826,-1339.4995117188,29.497024536133)
                    },
                    {
                        coords = vector3(-43.329521179199,-1749.0797119141,29.421012878418)
                    },
                    {
                        coords = vector3(-1483.8095703125,-375.59802246094,40.163425445557)
                    },
                    {
                        coords = vector3(1159.9201660156,-314.15371704102,69.205108642578)
                    },
                    {
                        coords = vector3(1706.5498046875,4919.9799804688,42.063640594482)
                    },
                }
            },
            safes = {
                {
                    coords = vector3(2016.3625488281,4986.939453125,42.098285675049),
                    sprite = 568,
                    action = "safe",
                }
            },
            clothes = {
                {
                male = {
                    tshirt_1 = -1,  tshirt_2 = -1,
                    torso_1 = 16,   torso_2 = 0,
                    decals_1 = 0,   decals_2 = 0,
                    arms = 0,
                    pants_1 = 90,   pants_2 = 0,
                    shoes_1 = 56,   shoes_2 = 0,
                    helmet_1 = -1,  helmet_2 = 0,
                    chain_1 = -1,    chain_2 = 0,
                    ears_1 = -1,     ears_2 = 0
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
                        tshirt_1 = -1,  tshirt_2 = -1,
                        torso_1 = 16,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 0,
                        pants_1 = 90,   pants_2 = 0,
                        shoes_1 = 56,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = -1,    chain_2 = 0,
                        ears_1 = -1,     ears_2 = 0
                    },
                    female = {
                        tshirt_1 = -1,  tshirt_2 = -1,
                        torso_1 = 16,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 0,
                        pants_1 = 90,   pants_2 = 0,
                        shoes_1 = 56,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = -1,    chain_2 = 0,
                        ears_1 = -1,     ears_2 = 0
                    }
                },
                {
                    male = {
                        tshirt_1 = -1,  tshirt_2 = -1,
                        torso_1 = 16,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 0,
                        pants_1 = 90,   pants_2 = 0,
                        shoes_1 = 56,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = -1,    chain_2 = 0,
                        ears_1 = -1,     ears_2 = 0
                    },
                    female = {
                        tshirt_1 = -1,  tshirt_2 = -1,
                        torso_1 = 16,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 0,
                        pants_1 = 90,   pants_2 = 0,
                        shoes_1 = 56,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = -1,    chain_2 = 0,
                        ears_1 = -1,     ears_2 = 0
                    }
                },
                {
                male = {
                    tshirt_1 = -1,  tshirt_2 = -1,
                    torso_1 = 16,   torso_2 = 0,
                    decals_1 = 0,   decals_2 = 0,
                    arms = 0,
                    pants_1 = 90,   pants_2 = 0,
                    shoes_1 = 56,   shoes_2 = 0,
                    helmet_1 = -1,  helmet_2 = 0,
                    chain_1 = -1,    chain_2 = 0,
                    ears_1 = -1,     ears_2 = 0
                },
                female = {
                    tshirt_1 = -1,  tshirt_2 = -1,
                    torso_1 = 16,   torso_2 = 0,
                    decals_1 = 0,   decals_2 = 0,
                    arms = 0,
                    pants_1 = 90,   pants_2 = 0,
                    shoes_1 = 56,   shoes_2 = 0,
                    helmet_1 = -1,  helmet_2 = 0,
                    chain_1 = -1,    chain_2 = 0,
                    ears_1 = -1,     ears_2 = 0
                }
                },
                {
                male = {
                    tshirt_1 = -1,  tshirt_2 = -1,
                    torso_1 = 16,   torso_2 = 0,
                    decals_1 = 0,   decals_2 = 0,
                    arms = 0,
                    pants_1 = 90,   pants_2 = 0,
                    shoes_1 = 56,   shoes_2 = 0,
                    helmet_1 = -1,  helmet_2 = 0,
                    chain_1 = -1,    chain_2 = 0,
                    ears_1 = -1,     ears_2 = 0
                },
                female = {
                    tshirt_1 = -1,  tshirt_2 = -1,
                    torso_1 = 16,   torso_2 = 0,
                    decals_1 = 0,   decals_2 = 0,
                    arms = 0,
                    pants_1 = 90,   pants_2 = 0,
                    shoes_1 = 56,   shoes_2 = 0,
                    helmet_1 = -1,  helmet_2 = 0,
                    chain_1 = -1,    chain_2 = 0,
                    ears_1 = -1,     ears_2 = 0
                }
                },
            },
        },
        wine = {
            color = 50,
            label= "Vignerons",
            lockers = {
                {
                    coords = vector3(-1921.0443115234,2054.7062988281,140.73498535156),
                    sprite = 496,
                }
            },
            collect = {
                {
                    coords = vector3(-1819.93,2134.48,123.8),
                    sprite = 502,
                    items = {
                        {name="Raisin", label="Raisin", amount="5", type="18"},
                     }
                }
            },
            process = {
                {
                coords = vector3(1731.98,3031.5,61.5),
				sprite = 503,
                items = {
                    {name="Raisin", label="Raisin", amount="5", type="18", to="19", amountTo="1"},
                }
            }
            },
            sell = {
                sprite = 366,
                items = {
                    {label = "Le jus des bros", type = 3, amount = 5, price = 5}
                },
                maxSold = 20,
                pos = {
                    {
                        coords = vector3(25.886821746826,-1339.4995117188,29.497024536133),
                    },
                    {
                        coords = vector3(25.886821746826,-1339.4995117188,29.497024536133)
                    },
                    {
                        coords = vector3(25.886821746826,-1339.4995117188,29.497024536133)
                    },
                    {
                        coords = vector3(-43.329521179199,-1749.0797119141,29.421012878418)
                    },
                    {
                        coords = vector3(-1483.8095703125,-375.59802246094,40.163425445557)
                    },
                    {
                        coords = vector3(1159.9201660156,-314.15371704102,69.205108642578)
                    },
                    {
                        coords = vector3(1706.5498046875,4919.9799804688,42.063640594482)
                    },
                }
            },
            clothes = {
                {
                male = {
                    tshirt_1 = -1,  tshirt_2 = -1,
                    torso_1 = 16,   torso_2 = 0,
                    decals_1 = 0,   decals_2 = 0,
                    arms = 0,
                    pants_1 = 90,   pants_2 = 0,
                    shoes_1 = 56,   shoes_2 = 0,
                    helmet_1 = -1,  helmet_2 = 0,
                    chain_1 = -1,    chain_2 = 0,
                    ears_1 = -1,     ears_2 = 0
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
                        tshirt_1 = -1,  tshirt_2 = -1,
                        torso_1 = 16,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 0,
                        pants_1 = 90,   pants_2 = 0,
                        shoes_1 = 56,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = -1,    chain_2 = 0,
                        ears_1 = -1,     ears_2 = 0
                    },
                    female = {
                        tshirt_1 = -1,  tshirt_2 = -1,
                        torso_1 = 16,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 0,
                        pants_1 = 90,   pants_2 = 0,
                        shoes_1 = 56,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = -1,    chain_2 = 0,
                        ears_1 = -1,     ears_2 = 0
                    }
                },
                {
                    male = {
                        tshirt_1 = -1,  tshirt_2 = -1,
                        torso_1 = 16,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 0,
                        pants_1 = 90,   pants_2 = 0,
                        shoes_1 = 56,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = -1,    chain_2 = 0,
                        ears_1 = -1,     ears_2 = 0
                    },
                    female = {
                        tshirt_1 = -1,  tshirt_2 = -1,
                        torso_1 = 16,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 0,
                        pants_1 = 90,   pants_2 = 0,
                        shoes_1 = 56,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = -1,    chain_2 = 0,
                        ears_1 = -1,     ears_2 = 0
                    }
                },
                {
                male = {
                    tshirt_1 = -1,  tshirt_2 = -1,
                    torso_1 = 16,   torso_2 = 0,
                    decals_1 = 0,   decals_2 = 0,
                    arms = 0,
                    pants_1 = 90,   pants_2 = 0,
                    shoes_1 = 56,   shoes_2 = 0,
                    helmet_1 = -1,  helmet_2 = 0,
                    chain_1 = -1,    chain_2 = 0,
                    ears_1 = -1,     ears_2 = 0
                },
                female = {
                    tshirt_1 = -1,  tshirt_2 = -1,
                    torso_1 = 16,   torso_2 = 0,
                    decals_1 = 0,   decals_2 = 0,
                    arms = 0,
                    pants_1 = 90,   pants_2 = 0,
                    shoes_1 = 56,   shoes_2 = 0,
                    helmet_1 = -1,  helmet_2 = 0,
                    chain_1 = -1,    chain_2 = 0,
                    ears_1 = -1,     ears_2 = 0
                }
                },
                {
                male = {
                    tshirt_1 = -1,  tshirt_2 = -1,
                    torso_1 = 16,   torso_2 = 0,
                    decals_1 = 0,   decals_2 = 0,
                    arms = 0,
                    pants_1 = 90,   pants_2 = 0,
                    shoes_1 = 56,   shoes_2 = 0,
                    helmet_1 = -1,  helmet_2 = 0,
                    chain_1 = -1,    chain_2 = 0,
                    ears_1 = -1,     ears_2 = 0
                },
                female = {
                    tshirt_1 = -1,  tshirt_2 = -1,
                    torso_1 = 16,   torso_2 = 0,
                    decals_1 = 0,   decals_2 = 0,
                    arms = 0,
                    pants_1 = 90,   pants_2 = 0,
                    shoes_1 = 56,   shoes_2 = 0,
                    helmet_1 = -1,  helmet_2 = 0,
                    chain_1 = -1,    chain_2 = 0,
                    ears_1 = -1,     ears_2 = 0
                }
                },
            },
        },
        bennys = {
            label= "Benny's",
            color = 6,
            red = 250,
            green = 10,
            blue = 10,
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
            repair = {
                {
                    coords = vector3(-223.45896911621,-1330.2464599609,30.890396118164),
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
                }
            },
            fourriere = {
                {
                    coords= vector3(-163.99496459961,-1297.2322998047,31),
                    sprite = 568,
                }
            },
            clothes = {
                {
                        male = {
                            tshirt_1 = -1,  tshirt_2 = -1,
                            torso_1 = 16,   torso_2 = 0,
                            decals_1 = 0,   decals_2 = 0,
                            arms = 0,
                            pants_1 = 90,   pants_2 = 0,
                            shoes_1 = 56,   shoes_2 = 0,
                            helmet_1 = -1,  helmet_2 = 0,
                            chain_1 = -1,    chain_2 = 0,
                            ears_1 = -1,     ears_2 = 0
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
                            tshirt_1 = -1,  tshirt_2 = -1,
                            torso_1 = 16,   torso_2 = 0,
                            decals_1 = 0,   decals_2 = 0,
                            arms = 0,
                            pants_1 = 90,   pants_2 = 0,
                            shoes_1 = 56,   shoes_2 = 0,
                            helmet_1 = -1,  helmet_2 = 0,
                            chain_1 = -1,    chain_2 = 0,
                            ears_1 = -1,     ears_2 = 0
                        },
                        female = {
                            tshirt_1 = -1,  tshirt_2 = -1,
                            torso_1 = 16,   torso_2 = 0,
                            decals_1 = 0,   decals_2 = 0,
                            arms = 0,
                            pants_1 = 90,   pants_2 = 0,
                            shoes_1 = 56,   shoes_2 = 0,
                            helmet_1 = -1,  helmet_2 = 0,
                            chain_1 = -1,    chain_2 = 0,
                            ears_1 = -1,     ears_2 = 0
                        }
                    },
                    {
                        male = {
                            tshirt_1 = -1,  tshirt_2 = -1,
                            torso_1 = 16,   torso_2 = 0,
                            decals_1 = 0,   decals_2 = 0,
                            arms = 0,
                            pants_1 = 90,   pants_2 = 0,
                            shoes_1 = 56,   shoes_2 = 0,
                            helmet_1 = -1,  helmet_2 = 0,
                            chain_1 = -1,    chain_2 = 0,
                            ears_1 = -1,     ears_2 = 0
                        },
                        female = {
                            tshirt_1 = -1,  tshirt_2 = -1,
                            torso_1 = 16,   torso_2 = 0,
                            decals_1 = 0,   decals_2 = 0,
                            arms = 0,
                            pants_1 = 90,   pants_2 = 0,
                            shoes_1 = 56,   shoes_2 = 0,
                            helmet_1 = -1,  helmet_2 = 0,
                            chain_1 = -1,    chain_2 = 0,
                            ears_1 = -1,     ears_2 = 0
                        }
                    },
                     {
                        male = {
                            tshirt_1 = -1,  tshirt_2 = -1,
                            torso_1 = 16,   torso_2 = 0,
                            decals_1 = 0,   decals_2 = 0,
                            arms = 0,
                            pants_1 = 90,   pants_2 = 0,
                            shoes_1 = 56,   shoes_2 = 0,
                            helmet_1 = -1,  helmet_2 = 0,
                            chain_1 = -1,    chain_2 = 0,
                            ears_1 = -1,     ears_2 = 0
                        },
                        female = {
                            tshirt_1 = -1,  tshirt_2 = -1,
                            torso_1 = 16,   torso_2 = 0,
                            decals_1 = 0,   decals_2 = 0,
                            arms = 0,
                            pants_1 = 90,   pants_2 = 0,
                            shoes_1 = 56,   shoes_2 = 0,
                            helmet_1 = -1,  helmet_2 = 0,
                            chain_1 = -1,    chain_2 = 0,
                            ears_1 = -1,     ears_2 = 0
                        }
                    },
                     {
                        male = {
                            tshirt_1 = -1,  tshirt_2 = -1,
                            torso_1 = 16,   torso_2 = 0,
                            decals_1 = 0,   decals_2 = 0,
                            arms = 0,
                            pants_1 = 90,   pants_2 = 0,
                            shoes_1 = 56,   shoes_2 = 0,
                            helmet_1 = -1,  helmet_2 = 0,
                            chain_1 = -1,    chain_2 = 0,
                            ears_1 = -1,     ears_2 = 0
                        },
                        female = {
                            tshirt_1 = -1,  tshirt_2 = -1,
                            torso_1 = 16,   torso_2 = 0,
                            decals_1 = 0,   decals_2 = 0,
                            arms = 0,
                            pants_1 = 90,   pants_2 = 0,
                            shoes_1 = 56,   shoes_2 = 0,
                            helmet_1 = -1,  helmet_2 = 0,
                            chain_1 = -1,    chain_2 = 0,
                            ears_1 = -1,     ears_2 = 0
                        }
                    },
                },
        },
        lsms = {
            label = "Hopital",
            color = 1, 
            red = 255,
            green  = 51,
            blue = 51,
            lockers = {
                {
                    coords = vector3(336.27508544922, -580.03137207031, 28.791479110718),
                    sprite = 366,
                }
            },
            homes = {
                {
                    coords = vector3(341.41842651367,-582.73522949219,28.791477203369),
                    sprite = 61,
                },
            },
            clothes = {
                {
                    male = {
                        tshirt_1 = 15,  tshirt_2 = 0,
                        torso_1 = 13,   torso_2 = 0,
                        decals_1 = 60,   decals_2 = 0,
                        arms = 92,
                        pants_1 = 24,   pants_2 = 5,
                        shoes_1 = 9,   shoes_2 = 0,
                        helmet_1 = 8,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0,
                    },
                    female = {
                        tshirt_1 = 75,  tshirt_2 = 3,
                        torso_1 = 73,   torso_2 = 0,
                        decals_1 = 60,   decals_2 = 0,
                        arms = 14,
                        pants_1 = 37,   pants_2 = 5,
                        shoes_1 = 1,   shoes_2 = 0,
                        helmet_1 = 57,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0,
                    }
               },
               {
                male = {
                    tshirt_1 = 15,  tshirt_2 = 0,
                    torso_1 = 95,   torso_2 = 0,
                    decals_1 = 60,   decals_2 = 0,
                    arms = 92,
                    pants_1 = 24,   pants_2 = 5,
                    shoes_1 = 9,   shoes_2 = 0,
                    helmet_1 = 8,  helmet_2 = 0,
                    chain_1 = 0,    chain_2 = 0,
                    ears_1 = 2,     ears_2 = 0,
                },
                female = {
                    tshirt_1 = 75,  tshirt_2 = 3,
                    torso_1 = 73,   torso_2 = 0,
                    decals_1 = 60,   decals_2 = 0,
                    arms = 14,
                    pants_1 = 37,   pants_2 = 5,
                    shoes_1 = 1,   shoes_2 = 0,
                    helmet_1 = 57,  helmet_2 = 0,
                    chain_1 = 126, chain_2 = 0,
                    ears_1 = 2,     ears_2 = 0,
                }
                },
                {
                    male = {
                        tshirt_1 = 15,  tshirt_2 = 0,
                        torso_1 = 95,   torso_2 = 0,
                        decals_1 = 60,   decals_2 = 0,
                        arms = 92,
                        pants_1 = 24,   pants_2 = 5,
                        shoes_1 = 9,   shoes_2 = 0,
                        helmet_1 = 8,  helmet_2 = 0,
                        chain_1 = 126, chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0,
                    },
                    female = {
                        tshirt_1 = 75,  tshirt_2 = 3,
                        torso_1 = 73,   torso_2 = 0,
                        decals_1 = 60,   decals_2 = 0,
                        arms = 14,
                        pants_1 = 37,   pants_2 = 5,
                        shoes_1 = 1,   shoes_2 = 0,
                        helmet_1 = 57,  helmet_2 = 0,
                        chain_1 = 126, chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0,

                    }
                },
                {
                    male = {
                        tshirt_1 = 15,  tshirt_2 = 0,
                        torso_1 = 95,   torso_2 = 0,
                        decals_1 = 60,   decals_2 = 0,
                        arms = 92,
                        pants_1 = 24,   pants_2 = 5,
                        shoes_1 = 9,   shoes_2 = 0,
                        helmet_1 = 8,  helmet_2 = 0,
                        chain_1 = 126, chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0,
                    },
                    female = {
                        tshirt_1 = 75,  tshirt_2 = 3,
                        torso_1 = 73,   torso_2 = 0,
                        decals_1 = 60,   decals_2 = 0,
                        arms = 14,
                        pants_1 = 37,   pants_2 = 5,
                        shoes_1 = 1,   shoes_2 = 0,
                        helmet_1 = 57,  helmet_2 = 0,
                        chain_1 = 126, chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0,

                    }
                },
                {
                    male = {
                        tshirt_1 = 15,  tshirt_2 = 0,
                        torso_1 = 95,   torso_2 = 0,
                        decals_1 = 60,   decals_2 = 0,
                        arms = 92,
                        pants_1 = 24,   pants_2 = 5,
                        shoes_1 = 9,   shoes_2 = 0,
                        helmet_1 = 8,  helmet_2 = 0,
                        chain_1 = 126, chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0,
                    },
                    female = {
                        tshirt_1 = 75,  tshirt_2 = 3,
                        torso_1 = 73,   torso_2 = 0,
                        decals_1 = 60,   decals_2 = 0,
                        arms = 14,
                        pants_1 = 37,   pants_2 = 5,
                        shoes_1 = 1,   shoes_2 = 0,
                        helmet_1 = 57,  helmet_2 = 0,
                        chain_1 = 126, chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0,
                    }
                },
            },
            safes = {
                    {
                        coords = vector3(327.28048706055,-598.31335449219,28.791481018066),
                        sprite = 568,
                    }
                },
            },
        lspd = {
            label= "LSPD",
            color = 77,
            red = 77,
            green = 166,
            blue = 255,
            lockers = {
                {
                    coords = vector3(456.48355102539,-992.94378662109,30.689331054688),
                    sprite = 51,
                }
            },
            armories = {
                {
                    coords = vector3(451.75173950195,-980.27758789062,30.689315795898),
                    sprite = 110,
                },
            },
            homes = {
                {
                    coords = vector3(441.18566894531,-981.09637451172,30.689331054688),
                    sprite = 60,
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
            },
            fourriere = {
                {
                    coords= vector3(-163.99496459961,-1297.2322998047,31),
                    sprite = 568,
                }
            },
            dirty = {
                {
                    coords = vector3(458.79364013672,-976.42529296875,24.914712905884),
                    sprite = 60
                }
            },
        --    frigo ={
          --      {
            --        coords = vector3(464.92498779297,-989.96105957031,30.689645767212),
              --      sprite = 3
                --}
         --   }
        },
        newspapers = {
            color = 38,
            begin = {
                {
                    coords = vector3(-259.20123291016,-843.56219482422,31.425704956055),
                    sprite = 77,
                    vehicle = "faggio2",
                },
            },
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
                        tshirt_1 = 70,  tshirt_2 = 0,
                        torso_1 = 25,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 41,
                        pants_1 = 7,   pants_2 = 0,
                        shoes_1 = 3,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    },
                    female = {
                        tshirt_1 = 70,  tshirt_2 = 0,
                        torso_1 = 25,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 41,
                        pants_1 = 7,   pants_2 = 0,
                        shoes_1 = 3,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    }
                },
                {
                    male = {
                        tshirt_1 = 70,  tshirt_2 = 0,
                        torso_1 = 25,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 41,
                        pants_1 = 7,   pants_2 = 0,
                        shoes_1 = 3,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    },
                    female = {
                        tshirt_1 = 70,  tshirt_2 = 0,
                        torso_1 = 25,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 41,
                        pants_1 = 7,   pants_2 = 0,
                        shoes_1 = 3,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    }
                },
                {
                    male = {
                        tshirt_1 = 70,  tshirt_2 = 0,
                        torso_1 = 25,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 41,
                        pants_1 = 7,   pants_2 = 0,
                        shoes_1 = 3,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    },
                    female = {
                        tshirt_1 = 70,  tshirt_2 = 0,
                        torso_1 = 25,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 41,
                        pants_1 = 7,   pants_2 = 0,
                        shoes_1 = 3,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    }
                },
                 {
                    male = {
                        tshirt_1 = 70,  tshirt_2 = 0,
                        torso_1 = 25,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 41,
                        pants_1 = 7,   pants_2 = 0,
                        shoes_1 = 3,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    },
                    female = {
                        tshirt_1 = 70,  tshirt_2 = 0,
                        torso_1 = 25,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 41,
                        pants_1 = 7,   pants_2 = 0,
                        shoes_1 = 3,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    }
                },
                {
                    male = {
                        tshirt_1 = 70,  tshirt_2 = 0,
                        torso_1 = 25,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 41,
                        pants_1 = 7,   pants_2 = 0,
                        shoes_1 = 3,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    },
                    female = {
                        tshirt_1 = 70,  tshirt_2 = 0,
                        torso_1 = 25,   torso_2 = 0,
                        decals_1 = 0,   decals_2 = 0,
                        arms = 41,
                        pants_1 = 7,   pants_2 = 0,
                        shoes_1 = 3,   shoes_2 = 0,
                        helmet_1 = -1,  helmet_2 = 0,
                        chain_1 = 0,    chain_2 = 0,
                        ears_1 = 2,     ears_2 = 0
                    }
                },
            },
        },
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

Config.DrawDistance               = 20.0 -- How close do you need to be in order for the markers to be drawn (in GTA units).

Config.Marker                     = {type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false}

Config.bindings = {
    interact_position = 51, -- E
    use_job_menu = 166, -- F5
    accept_fine = 246, -- Y
    refuse_fine = 140 -- R
}

Config.tva = 0.20