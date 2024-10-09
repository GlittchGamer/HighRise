-- MRPD Door List

addDoorsListToConfig({
  -- First Floor
  {
    id = "MRPD_1STFLOOR_RECEPTION",
    model = 1079515784,
    coords = vector3(471.75701, -1007.38, 26.386087),
    locked = true,
    restricted = {
      { type = 'job', job = 'police',     workplace = false,         gradeLevel = 0,  jobPermission = false, reqDuty = false },
      { type = 'job', job = 'government', workplace = 'doj',         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'medical',    workplace = false,         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'prison',     workplace = 'corrections', gradeLevel = 30, jobPermission = false, reqDuty = true },
    },
  },

  {
    id = "MRPD_1STFLOOR_ROOM_301_LEFT",
    model = 1239973900,
    coords = vector3(445.96, -998.34, 31.15),
    locked = true,
    double = 'MRPD_1STFLOOR_ROOM_301_RIGHT',
    restricted = {
      { type = 'job', job = 'police',     workplace = false,         gradeLevel = 0,  jobPermission = false, reqDuty = false },
      { type = 'job', job = 'government', workplace = 'doj',         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'medical',    workplace = false,         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'prison',     workplace = 'corrections', gradeLevel = 30, jobPermission = false, reqDuty = true },
    },
  },

  {
    id = "MRPD_1STFLOOR_ROOM_301_RIGHT",
    model = -1095702117,
    double = 'MRPD_1STFLOOR_ROOM_301_LEFT',
    coords = vector3(443.48, -998.34, 31.15),
    locked = true,
    restricted = {
      { type = 'job', job = 'police',     workplace = false,         gradeLevel = 0,  jobPermission = false, reqDuty = false },
      { type = 'job', job = 'government', workplace = 'doj',         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'medical',    workplace = false,         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'prison',     workplace = 'corrections', gradeLevel = 30, jobPermission = false, reqDuty = true },
    },
  },

  {
    id = "MRPD_1STFLOOR_ROOM_302",
    model = -884650166,
    coords = vector3(448.67, -998.31, 31.15),
    locked = true,
    restricted = {
      { type = 'job', job = 'police',     workplace = false,         gradeLevel = 0,  jobPermission = false, reqDuty = false },
      { type = 'job', job = 'government', workplace = 'doj',         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'medical',    workplace = false,         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'prison',     workplace = 'corrections', gradeLevel = 30, jobPermission = false, reqDuty = true },
    },
  },

  {
    id = "MRPD_1STFLOOR_ROOM_303_LEFT",
    model = -1710985036,
    double = 'MRPD_ROOM_303_RIGHT',
    coords = vector3(459.8, -998.36, 31.15),
    locked = true,
    restricted = {
      { type = 'job', job = 'police',     workplace = false,         gradeLevel = 0,  jobPermission = false, reqDuty = false },
      { type = 'job', job = 'government', workplace = 'doj',         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'medical',    workplace = false,         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'prison',     workplace = 'corrections', gradeLevel = 30, jobPermission = false, reqDuty = true },
    },
  },

  {
    id = "MRPD_1STFLOOR_ROOM_303_RIGHT",
    model = -1710985036,
    double = 'MRPD_ROOM_303_LEFT',
    coords = vector3(459.8, -998.36, 31.15),
    locked = true,
    restricted = {
      { type = 'job', job = 'police',     workplace = false,         gradeLevel = 0,  jobPermission = false, reqDuty = false },
      { type = 'job', job = 'government', workplace = 'doj',         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'medical',    workplace = false,         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'prison',     workplace = 'corrections', gradeLevel = 30, jobPermission = false, reqDuty = true },
    },
  },

  {
    id = "MRPD_1STFLOOR_STAIRS",
    model = 541222087,
    coords = vector3(447.37, -980.63, 31.15),
    locked = true,
    restricted = {
      { type = 'job', job = 'police',     workplace = false,         gradeLevel = 0,  jobPermission = false, reqDuty = false },
      { type = 'job', job = 'government', workplace = 'doj',         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'medical',    workplace = false,         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'prison',     workplace = 'corrections', gradeLevel = 30, jobPermission = false, reqDuty = true },
    },
  },

  {
    id = "MRPD_2NDFLOOR_STAIRS",
    model = 541222087,
    coords = vector3(447.37, -980.62, 35.92),
    locked = true,
    restricted = {
      { type = 'job', job = 'police',     workplace = false,         gradeLevel = 0,  jobPermission = false, reqDuty = false },
      { type = 'job', job = 'government', workplace = 'doj',         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'medical',    workplace = false,         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'prison',     workplace = 'corrections', gradeLevel = 30, jobPermission = false, reqDuty = true },
    },
  },

  {
    id = "MRPPD_2NDFLOOR_ROOM_333_LEFT",
    model = -1710985036,
    coords = vector3(472.75, -1010.39, 35.92),
    locked = false,
    restricted = {
      { type = 'job', job = 'police',     workplace = false,         gradeLevel = 0,  jobPermission = false, reqDuty = false },
      { type = 'job', job = 'government', workplace = 'doj',         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'medical',    workplace = false,         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'prison',     workplace = 'corrections', gradeLevel = 30, jobPermission = false, reqDuty = true },
    },
  },

  {
    id = "MRPD_2NDFLOOR_ROOM_333_RIGHT",
    model = -1710985036,
    coords = vector3(470.27, -1010.39, 35.92),
    restricted = {
      { type = 'job', job = 'police',     workplace = false,         gradeLevel = 0,  jobPermission = false, reqDuty = false },
      { type = 'job', job = 'government', workplace = 'doj',         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'medical',    workplace = false,         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'prison',     workplace = 'corrections', gradeLevel = 30, jobPermission = false, reqDuty = true },
    },
  },

  {
    id = "MRPD_2NDFLOOR_BRIEFING_ROOM",
    model = -884650166,
    coords = vector3(473.41, -1009.58, 35.92),
    restricted = {
      { type = 'job', job = 'police',     workplace = false,         gradeLevel = 0,  jobPermission = false, reqDuty = false },
      { type = 'job', job = 'government', workplace = 'doj',         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'medical',    workplace = false,         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'prison',     workplace = 'corrections', gradeLevel = 30, jobPermission = false, reqDuty = true },
    },
  },

  {
    id = "MRPD_2NDFLOOR_ROOM_331_LEFT",
    model = -1710985036,
    coords = vector3(468.58, -998.23, 35.92),
    restricted = {
      { type = 'job', job = 'police',     workplace = false,         gradeLevel = 0,  jobPermission = false, reqDuty = false },
      { type = 'job', job = 'government', workplace = 'doj',         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'medical',    workplace = false,         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'prison',     workplace = 'corrections', gradeLevel = 30, jobPermission = false, reqDuty = true },
    },
  },

  {
    id = "MRPD_2NDFLOOR_ROOM_331_RIGHT",
    model = -1710985036,
    coords = vector3(471.06, -998.23, 35.92),
    restricted = {
      { type = 'job', job = 'police',     workplace = false,         gradeLevel = 0,  jobPermission = false, reqDuty = false },
      { type = 'job', job = 'government', workplace = 'doj',         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'medical',    workplace = false,         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'prison',     workplace = 'corrections', gradeLevel = 30, jobPermission = false, reqDuty = true },
    },
  },

  {
    id = "no_name",
    model = -884650166,
    coords = vector3(463.21, -1002.0, 35.92),
    restricted = {
      { type = 'job', job = 'police',     workplace = false,         gradeLevel = 0,  jobPermission = false, reqDuty = false },
      { type = 'job', job = 'government', workplace = 'doj',         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'medical',    workplace = false,         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'prison',     workplace = 'corrections', gradeLevel = 30, jobPermission = false, reqDuty = true },
    },
  },

  {
    id = "MRPD_2NDFLOOR_ROOM_334",
    model = -884650166,
    coords = vector3(463.21, -1002.0, 35.92),
    restricted = {
      { type = 'job', job = 'police',     workplace = false,         gradeLevel = 0,  jobPermission = false, reqDuty = false },
      { type = 'job', job = 'government', workplace = 'doj',         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'medical',    workplace = false,         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'prison',     workplace = 'corrections', gradeLevel = 30, jobPermission = false, reqDuty = true },
    },
  },

  {
    id = "MRPD_2NDFLOOR_ROOM_335",
    model = -884650166,
    coords = vector3(456.13, -1002.0, 35.92),
    restricted = {
      { type = 'job', job = 'police',     workplace = false,         gradeLevel = 0,  jobPermission = false, reqDuty = false },
      { type = 'job', job = 'government', workplace = 'doj',         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'medical',    workplace = false,         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'prison',     workplace = 'corrections', gradeLevel = 30, jobPermission = false, reqDuty = true },
    },
  },

  {
    id = "MRPD_2NDFLOOR_ROOM_336",
    model = -884650166,
    coords = vector3(442.02, -1002.0, 35.92),
    restricted = {
      { type = 'job', job = 'police',     workplace = false,         gradeLevel = 0,  jobPermission = false, reqDuty = false },
      { type = 'job', job = 'government', workplace = 'doj',         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'medical',    workplace = false,         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'prison',     workplace = 'corrections', gradeLevel = 30, jobPermission = false, reqDuty = true },
    },
  },

  {
    id = "MRPD_2NDFLOOR_ROOM_337_LEFT",
    model = -1710985036,
    coords = vector3(438.71, -1001.33, 35.92),
    restricted = {
      { type = 'job', job = 'police',     workplace = false,         gradeLevel = 0,  jobPermission = false, reqDuty = false },
      { type = 'job', job = 'government', workplace = 'doj',         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'medical',    workplace = false,         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'prison',     workplace = 'corrections', gradeLevel = 30, jobPermission = false, reqDuty = true },
    },
  },

  {
    id = "MRPD_2NDFLOOR_ROOM_337_RIGHT",
    model = -1710985036,
    coords = vector3(438.71, -998.85, 35.92),
    restricted = {
      { type = 'job', job = 'police',     workplace = false,         gradeLevel = 0,  jobPermission = false, reqDuty = false },
      { type = 'job', job = 'government', workplace = 'doj',         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'medical',    workplace = false,         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'prison',     workplace = 'corrections', gradeLevel = 30, jobPermission = false, reqDuty = true },
    },
  },

  {
    id = "MRPD_2NDFLOOR_ROOM_350_LEFT",
    model = -1710985036,
    coords = vector3(438.74, -984.21, 35.92),
    restricted = {
      { type = 'job', job = 'police',     workplace = false,         gradeLevel = 0,  jobPermission = false, reqDuty = false },
      { type = 'job', job = 'government', workplace = 'doj',         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'medical',    workplace = false,         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'prison',     workplace = 'corrections', gradeLevel = 30, jobPermission = false, reqDuty = true },
    },
  },

  {
    id = "MRPD_2NDFLOOR_ROOM_350_RIGHT",
    model = -1710985036,
    coords = vector3(438.74, -981.73, 35.92),
    restricted = {
      { type = 'job', job = 'police',     workplace = false,         gradeLevel = 0,  jobPermission = false, reqDuty = false },
      { type = 'job', job = 'government', workplace = 'doj',         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'medical',    workplace = false,         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'prison',     workplace = 'corrections', gradeLevel = 30, jobPermission = false, reqDuty = true },
    },
  },

  {
    id = "MRPD_ROOF_ACCESS",
    model = -340230128,
    coords = vector3(451.11, -981.13, 45.12),
    restricted = {
      { type = 'job', job = 'police',     workplace = false,         gradeLevel = 0,  jobPermission = false, reqDuty = false },
      { type = 'job', job = 'government', workplace = 'doj',         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'medical',    workplace = false,         gradeLevel = 10, jobPermission = false, reqDuty = true },
      { type = 'job', job = 'prison',     workplace = 'corrections', gradeLevel = 30, jobPermission = false, reqDuty = true },
    },
  },



  ----- GOT TO SET UP POLYZONES FOR THIS SHIT I DONT FEEL LIKE DOING ALLAT
  {
    id = "MRPD_GATE_1",
    model = -246583363,
    coords = vector3(451.18801, -1000.755, 25.765163),
    locked = true,
    special = true,
    restricted = {
      { type = 'job', job = 'police',     workplace = false, gradeLevel = 0,  jobPermission = false, reqDuty = false },
      { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
    },
  },

  {
    id = "MRPD_GATE_2",
    model = -246583363,
    coords = vector3(432.60177, -1000.678, 25.773921),
    locked = true,
    special = true,
    restricted = {
      { type = 'job', job = 'police',     workplace = false, gradeLevel = 0,  jobPermission = false, reqDuty = false },
      { type = 'job', job = 'government', workplace = 'doj', gradeLevel = 10, jobPermission = false, reqDuty = true },
    },
  },

})
