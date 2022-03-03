Config = {}

Config.PawnLocation = vector3(412.34, 314.81, 103.13)
Config.BankMoney = false -- Set to true if you want the money to go into the players bank
Config.UseTimes = false -- Set to false if you want the pawnshop open 24/7
Config.TimeOpen = 7 -- Opening Time
Config.TimeClosed = 17 -- Closing Time
Config.SendMeltingEmail = true

Config.EmailSender = "Pawn Shop"
Config.EmailSubject = "Melting Items"
Config.EmailMessage = "We finished melting your items. You can come pick them up at any time."

Config.PawnItems = {
    [1] = {
        item = "goldchain",
        price = math.random(250,350)
    },
    [2] = {
        item = "diamond_ring",
        price = math.random(500,800)
    },
    [3] = {
        item = "rolex",
        price = math.random(85,125)
    },
    [4] = {
        item = "10kgoldchain",
        price = math.random(150,200)
    },
    [5] = {
        item = "tablet",
        price = math.random(50,100)
    }
    ,
    [6] = {
        item = "iphone",
        price = math.random(50,100)
    }
    ,
    [7] = {
        item = "samsungphone",
        price = math.random(50,100)
    }
    ,
    [8] = {
        item = "laptop",
        price = math.random(50,100)
    }
    ,
    [8] = {
        item = "goldbar",
        price = math.random(1000,4000)
    },
    [9] = {
        item = 'cryptostick',
        price = math.random(1,100)
    }
}

Config.MeltingItems = { -- meltTime is amount of time in minutes per item
    [1] = {
        item = "goldchain",
        rewards = {
            [1] = {
                item = "goldnug",
                amount = 2
            }
        },
        meltTime = 1
    },
    [2] = {
        item = "diamond_ring",
        rewards = {
            [1] = {
                item = "diamond",
                amount = 1
            },
            [2] = {
                item = "goldnug",
                amount = 1
            }
        },
        meltTime = 1
    },
    [3] = {
        item = "rolex",
        rewards = {
            [1] = {
                item = "diamond",
                amount = 1
            },
            [2] = {
                item = "goldnug",
                amount = 1
            },
            [3] = {
                item = "electronickit",
                amount = 1
            }
        },
        meltTime = 1
    },
    [4] = {
        item = "10kgoldchain",
        rewards = {
            [1] = {
                item = "diamond",
                amount = 5
            },
            [2] = {
                item = "goldnug",
                amount = 3
            }
        },
        meltTime = 1
    },
}