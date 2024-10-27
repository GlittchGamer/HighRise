_fleetConfig = {
  {
    job = 'police',
    requiredPermission = 'FLEET_MANAGEMENT',
    jobName = 'Police',
    bankAccount = 'police',
    interactionPed = {
      model = `s_f_y_cop_01`,
      coords = vector3(447.019, -996.985, 29.690),
      heading = 265.797,
      scenario = 'WORLD_HUMAN_COP_IDLES',
      range = 15.0,
    },
    vehicles = {
      {
        vehicle = `polalamo2`,
        type = 0,
        make = 'Delclasse',
        model = 'Alamo Police',
        price = 110000,
        class = 'PD',
        liveries = {
          [0] = 'LSPD',
          --[1] = 'LSCSO',
          --[2] = 'SAST',
          --[3] = 'Unmarked',
        },
        defaultProperties = json.decode([[
              {
                  "pearlescentColor": 0,
                  "wheelColor": 27,
                  "neonEnabled": [
                    false,
                    false,
                    false,
                    false
                  ],
                  "livery": 1,
                  "wheels": 0,
                  "color2": {
                    "g": 217,
                    "r": 217,
                    "b": 217
                  },
                  "plateIndex": 4,
                  "extras": {
                    "0": false,
                    "1": true,
                    "2": true,
                    "3": true,
                    "4": false,
                    "5": false,
                    "6": false,
                    "7": false,
                    "8": false,
                    "9": false,
                    "10": false,
                    "11": false,
                    "12": false
                  },
                  "windowTint": -1,
                  "mods": {
                    "aerials": -1,
                    "spoilers": 5,
                    "tank": -1,
                    "struts": -1,
                    "dashboard": -1,
                    "suspension": -1,
                    "exhaust": 1,
                    "armor": -1,
                    "doorSpeaker": -1,
                    "hydrolic": -1,
                    "seats": 0,
                    "speakers": -1,
                    "trunk": 3,
                    "rearBumper": -1,
                    "grille": -1,
                    "plateHolder": -1,
                    "sideSkirt": 5,
                    "brakes": -1,
                    "hood": -1,
                    "turbo": false,
                    "trimB": -1,
                    "xenon": false,
                    "xenonColor": 255,
                    "engineBlock": -1,
                    "aPlate": -1,
                    "windows": -1,
                    "dial": -1,
                    "frontBumper": -1,
                    "shifterLeavers": 0,
                    "archCover": -1,
                    "steeringWheel": -1,
                    "fender": -1,
                    "frame": -1,
                    "vanityPlate": -1,
                    "engine": -1,
                    "rightFender": -1,
                    "frontWheels": -1,
                    "horns": 1,
                    "trimA": -1,
                    "ornaments": -1,
                    "transmission": -1,
                    "backWheels": -1,
                    "airFilter": -1,
                    "roof": 0
                  },
                  "paintType": [
                    0,
                    0
                  ],
                  "tyreSmokeColor": {
                    "g": 255,
                    "r": 255,
                    "b": 255
                  },
                  "tyreSmoke": false,
                  "neonColor": {
                    "g": 0,
                    "r": 255,
                    "b": 255
                  },
                  "color1": {
                    "g": 255,
                    "r": 255,
                    "b": 255
                  },
                  "color2": {
                      "g": 0,
                      "b": 0,
                      "r": 0
                  }
              }
          ]])
      },
      {
        vehicle = `polshinobi`,
        type = 0,
        make = 'Nagasaki',
        model = 'Shinobi Police',
        price = 70000,
        class = 'PD',
        liveries = {
          [0] = 'LSPD',
          --[1] = 'LSCSO',
          --[2] = 'SAST',
          --[3] = 'Unmarked',
        },
        defaultProperties = json.decode([[
              {
                  "pearlescentColor": 0,
                  "wheelColor": 27,
                  "neonEnabled": [
                    false,
                    false,
                    false,
                    false
                  ],
                  "livery": 1,
                  "wheels": 0,
                  "color2": {
                    "g": 217,
                    "r": 217,
                    "b": 217
                  },
                  "plateIndex": 4,
                  "extras": {
                    "0": false,
                    "1": true,
                    "2": true,
                    "3": true,
                    "4": false,
                    "5": false,
                    "6": false,
                    "7": false,
                    "8": false,
                    "9": false,
                    "10": false,
                    "11": false,
                    "12": false
                  },
                  "windowTint": -1,
                  "mods": {
                    "aerials": -1,
                    "spoilers": 5,
                    "tank": -1,
                    "struts": -1,
                    "dashboard": -1,
                    "suspension": -1,
                    "exhaust": 1,
                    "armor": -1,
                    "doorSpeaker": -1,
                    "hydrolic": -1,
                    "seats": 0,
                    "speakers": -1,
                    "trunk": 3,
                    "rearBumper": -1,
                    "grille": -1,
                    "plateHolder": -1,
                    "sideSkirt": 5,
                    "brakes": -1,
                    "hood": -1,
                    "turbo": false,
                    "trimB": -1,
                    "xenon": false,
                    "xenonColor": 255,
                    "engineBlock": -1,
                    "aPlate": -1,
                    "windows": -1,
                    "dial": -1,
                    "frontBumper": -1,
                    "shifterLeavers": 0,
                    "archCover": -1,
                    "steeringWheel": -1,
                    "fender": -1,
                    "frame": -1,
                    "vanityPlate": -1,
                    "engine": -1,
                    "rightFender": -1,
                    "frontWheels": -1,
                    "horns": 1,
                    "trimA": -1,
                    "ornaments": -1,
                    "transmission": -1,
                    "backWheels": -1,
                    "airFilter": -1,
                    "roof": 0
                  },
                  "paintType": [
                    0,
                    0
                  ],
                  "tyreSmokeColor": {
                    "g": 255,
                    "r": 255,
                    "b": 255
                  },
                  "tyreSmoke": false,
                  "neonColor": {
                    "g": 0,
                    "r": 255,
                    "b": 255
                  },
                  "color1": {
                    "g": 255,
                    "r": 255,
                    "b": 255
                  },
                  "color2": {
                      "g": 0,
                      "b": 0,
                      "r": 0
                  }
              }
          ]])
      },
      {
        vehicle = `polstanier2 `,
        type = 0,
        make = 'Vapid',
        model = 'Stanier Police',
        price = 85000,
        class = 'PD',
        liveries = {
          [-1] = 'LSPD',
          [0] = 'Unmarked',
          --[1] = 'LSCSO',
          --[2] = 'SAST',
          --[3] = 'Unmarked',
        },
        defaultProperties = json.decode([[
              {
                  "pearlescentColor": 0,
                  "color2": {
                      "g": 8,
                      "b": 8,
                      "r": 8
                  },
                  "mods": {
                      "turbo": false,
                      "sideSkirt": -1,
                      "seats": -1,
                      "engineBlock": -1,
                      "windows": -1,
                      "tank": -1,
                      "frontWheels": -1,
                      "aPlate": -1,
                      "dashboard": -1,
                      "rightFender": -1,
                      "steeringWheel": -1,
                      "doorSpeaker": -1,
                      "xenonColor": 255,
                      "speakers": -1,
                      "dial": -1,
                      "hood": -1,
                      "struts": -1,
                      "vanityPlate": -1,
                      "armor": -1,
                      "shifterLeavers": -1,
                      "trunk": -1,
                      "roof": -1,
                      "spoilers": -1,
                      "horns": -1,
                      "backWheels": -1,
                      "trimA": -1,
                      "exhaust": -1,
                      "plateHolder": -1,
                      "grille": -1,
                      "trimB": -1,
                      "airFilter": -1,
                      "brakes": -1,
                      "frame": -1,
                      "frontBumper": -1,
                      "hydrolic": -1,
                      "suspension": -1,
                      "archCover": -1,
                      "transmission": -1,
                      "xenon": true,
                      "rearBumper": -1,
                      "fender": -1,
                      "ornaments": -1,
                      "aerials": -1,
                      "engine": -1
                  },
                  "tyreSmokeColor": {
                      "g": 255,
                      "b": 255,
                      "r": 255
                  },
                  "livery": 0,
                  "tyreSmoke": false,
                  "paintType": [1, 1],
                  "windowTint": 0,
                  "plateIndex": 4,
                  "color1": {
                      "g": 8,
                      "b": 8,
                      "r": 8
                  },
                  "neonEnabled": [false, false, false, false],
                  "wheels": 1,
                  "extras": {
                      "1": true,
                      "2": true,
                      "3": true,
                      "4": true,
                      "5": false,
                      "6": true,
                      "7": true,
                      "8": true,
                      "9": false
                  },
                  "wheelColor": 0,
                  "neonColor": {
                      "g": 0,
                      "b": 255,
                      "r": 255
                  }
              }
          ]])
      },

      {
        vehicle = `poltorrence2 `,
        make = 'Vapid',
        model = 'Torrence Police',
        price = 85000,
        class = 'PD',
        liveries = {
          [-1] = 'LSPD',
          [0] = 'Unmarked',
          --[1] = 'LSCSO',
          --[2] = 'SAST',
          --[3] = 'Unmarked',
        },
        defaultProperties = json.decode([[
              {
                  "pearlescentColor": 0,
                  "color2": {
                      "g": 8,
                      "b": 8,
                      "r": 8
                  },
                  "mods": {
                      "turbo": false,
                      "sideSkirt": -1,
                      "seats": -1,
                      "engineBlock": -1,
                      "windows": -1,
                      "tank": -1,
                      "frontWheels": -1,
                      "aPlate": -1,
                      "dashboard": -1,
                      "rightFender": -1,
                      "steeringWheel": -1,
                      "doorSpeaker": -1,
                      "xenonColor": 255,
                      "speakers": -1,
                      "dial": -1,
                      "hood": -1,
                      "struts": -1,
                      "vanityPlate": -1,
                      "armor": -1,
                      "shifterLeavers": -1,
                      "trunk": -1,
                      "roof": -1,
                      "spoilers": -1,
                      "horns": -1,
                      "backWheels": -1,
                      "trimA": -1,
                      "exhaust": -1,
                      "plateHolder": -1,
                      "grille": -1,
                      "trimB": -1,
                      "airFilter": -1,
                      "brakes": -1,
                      "frame": -1,
                      "frontBumper": -1,
                      "hydrolic": -1,
                      "suspension": -1,
                      "archCover": -1,
                      "transmission": -1,
                      "xenon": true,
                      "rearBumper": -1,
                      "fender": -1,
                      "ornaments": -1,
                      "aerials": -1,
                      "engine": -1
                  },
                  "tyreSmokeColor": {
                      "g": 255,
                      "b": 255,
                      "r": 255
                  },
                  "livery": 0,
                  "tyreSmoke": false,
                  "paintType": [1, 1],
                  "windowTint": 0,
                  "plateIndex": 4,
                  "color1": {
                      "g": 8,
                      "b": 8,
                      "r": 8
                  },
                  "neonEnabled": [false, false, false, false],
                  "wheels": 1,
                  "extras": {
                      "1": true,
                      "2": true,
                      "3": true,
                      "4": true,
                      "5": false,
                      "6": true,
                      "7": true,
                      "8": true,
                      "9": false
                  },
                  "wheelColor": 0,
                  "neonColor": {
                      "g": 0,
                      "b": 255,
                      "r": 255
                  }
              }
          ]])
      },
      {
        vehicle = `polmav3`,
        make = 'Buckingham',
        model = 'Maverick',
        type = 2,
        price = 80000,
        liveries = {
          [1] = 'Police',
        },
        defaultProperties = json.decode([[
              {
                  "pearlescentColor": 156,
                  "color2": {
                      "g": 255,
                      "b": 255,
                      "r": 255
                  },
                  "mods": {
                      "turbo": false,
                      "sideSkirt": -1,
                      "seats": -1,
                      "engineBlock": -1,
                      "windows": -1,
                      "tank": -1,
                      "frontWheels": -1,
                      "aPlate": -1,
                      "dashboard": -1,
                      "rightFender": -1,
                      "steeringWheel": -1,
                      "doorSpeaker": -1,
                      "xenonColor": 255,
                      "speakers": -1,
                      "dial": -1,
                      "hood": -1,
                      "struts": -1,
                      "vanityPlate": -1,
                      "armor": -1,
                      "shifterLeavers": -1,
                      "trunk": -1,
                      "roof": -1,
                      "spoilers": -1,
                      "horns": -1,
                      "backWheels": -1,
                      "trimA": -1,
                      "exhaust": -1,
                      "plateHolder": -1,
                      "grille": -1,
                      "trimB": -1,
                      "airFilter": -1,
                      "brakes": -1,
                      "frame": -1,
                      "frontBumper": -1,
                      "hydrolic": -1,
                      "suspension": -1,
                      "fender": -1,
                      "transmission": -1,
                      "xenon": true,
                      "rearBumper": -1,
                      "archCover": -1,
                      "ornaments": -1,
                      "aerials": -1,
                      "engine": -1
                  },
                  "tyreSmokeColor": {
                      "g": 255,
                      "b": 255,
                      "r": 255
                  },
                  "livery": 0,
                  "tyreSmoke": false,
                  "paintType": [0, 0],
                  "windowTint": 0,
                  "plateIndex": 4,
                  "color1": {
                      "g": 255,
                      "b": 255,
                      "r": 255
                  },
                  "neonEnabled": [false, false, false, false],
                  "wheels": 1,
                  "extras": {
                      "0": true,
                      "1": true,
                      "2": true,
                      "3": true,
                      "4": true,
                      "5": true,
                      "6": true,
                      "7": true,
                      "8": true,
                      "9": true,
                      "10": true,
                      "11": true,
                      "12": true
                  },
                  "wheelColor": 156,
                  "neonColor": {
                      "g": 0,
                      "b": 255,
                      "r": 255
                  }
              }
          ]])
      },
    }
  },
  {
    job = 'ems',
    workplace = 'safd',
    requiredPermission = 'FLEET_MANAGEMENT',
    jobName = 'EMS',
    bankAccount = 'ems',
    interactionPed = {
      model = `s_m_m_paramedic_01`,
      coords = vector3(-501.060, -339.506, 68.523),
      heading = 356.190,
      scenario = 'WORLD_HUMAN_COP_IDLES',
      range = 15.0,
    },
    vehicles = {
      {
        vehicle = `20ramambo`,
        make = 'Dodge',
        model = 'Ram Ambulance',
        price = 80000,
        liveries = {
          [0] = 'Fire & Rescue',
        },
        defaultProperties = json.decode([[
                    {
                        "pearlescentColor": 156,
                        "color2": {
                            "g": 255,
                            "b": 255,
                            "r": 255
                        },
                        "mods": {
                            "turbo": false,
                            "sideSkirt": -1,
                            "seats": -1,
                            "engineBlock": -1,
                            "windows": -1,
                            "tank": -1,
                            "frontWheels": -1,
                            "aPlate": -1,
                            "dashboard": -1,
                            "rightFender": -1,
                            "steeringWheel": -1,
                            "doorSpeaker": -1,
                            "xenonColor": 255,
                            "speakers": -1,
                            "dial": -1,
                            "hood": -1,
                            "struts": -1,
                            "vanityPlate": -1,
                            "armor": -1,
                            "shifterLeavers": -1,
                            "trunk": -1,
                            "roof": -1,
                            "spoilers": -1,
                            "horns": -1,
                            "backWheels": -1,
                            "trimA": -1,
                            "exhaust": -1,
                            "plateHolder": -1,
                            "grille": -1,
                            "trimB": -1,
                            "airFilter": -1,
                            "brakes": -1,
                            "frame": -1,
                            "frontBumper": -1,
                            "hydrolic": -1,
                            "suspension": -1,
                            "fender": -1,
                            "transmission": -1,
                            "xenon": true,
                            "rearBumper": -1,
                            "archCover": -1,
                            "ornaments": -1,
                            "aerials": -1,
                            "engine": -1
                        },
                        "tyreSmokeColor": {
                            "g": 255,
                            "b": 255,
                            "r": 255
                        },
                        "livery": 0,
                        "tyreSmoke": false,
                        "paintType": [0, 0],
                        "windowTint": 0,
                        "plateIndex": 4,
                        "color1": {
                            "g": 255,
                            "b": 255,
                            "r": 255
                        },
                        "neonEnabled": [false, false, false, false],
                        "wheels": 1,
                        "extras": {
                            "0": false,
                            "1": true,
                            "2": true,
                            "3": true,
                            "4": true,
                            "5": true,
                            "6": true,
                            "7": false,
                            "8": true,
                            "9": false,
                            "10": true,
                            "11": false,
                            "12": false
                        },
                        "wheelColor": 156,
                        "neonColor": {
                            "g": 0,
                            "b": 255,
                            "r": 255
                        }
                    }
                ]])
      },
    }
  }
}
