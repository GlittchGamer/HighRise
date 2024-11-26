# HighRiseRP

**calling my 1 year old daughter a smackhead lmao i own the sql rights i did 95% of the sql convert** your welcome 

# Server Functionality

**Exports (Components)**
We have changed the back-end of the Core Mythic Framework at HRRP to better suit our wants and needs, opting for a more performant server,
the Component system for fetching/registering has been scrapped and replaced with a more efficient export handler.

Instead of the regular fetching components then calling for example **_Middleware:TriggerEvent('event_name', {})_**
You can now call this with **_exports['hrrp-base']:MiddlewareTriggerEvent('event_name', {})_**

The usage is -> **_exports['hrrp-base']:_** as standard for any core component,
The first word is the Component IE _Middleware_ and the rest is the function IE _TriggerEvent_

**Database**
We have also changed the database system, we are no longer use MongoDB and/or MySQL... but we have opted for PGSQL.
It's much more performative and gives us the ability to step into TypeScript with Prisma as we see fit, very mindful, very demure.

An example query below would be

```
  local offlineCharFetch = exports['hrrp-base']:DatabaseSingle({
    query = [[SELECT * FROM "Characters" WHERE "SID" = $1]],
    values = { stateId }
  })

  if offlineCharFetch.err then
    return nil
  end

  local charData = offlineCharFetch.result
  print(charData.First)
```

We no longer have the need to encode/decode our JSON tables with PGSQL, thus allowing more valuable time for codies.

# In game commands below

**User Management**

/admin
/staff
/unban
/unbanid
/banid
/addmdtsysadmin
/removemdtsysadmin

**Teleportation and Movement**

/noclip
/tpm
/tp
/staffcam

**Coordinates and Location**

/lookup
/marker
/cpcoords
/cpproperty
/location

**Character and Pedestrian Management**

/setped
/zsetped
/setcallsign
/reclaimcallsign

**Debugging and Testing**

/debugdamage
/die
/debug
/testbilling
/screenshot

**Inventory and Items**

/giveitem
/giveweapon
/vanityitem
/printinv
/printinv2
/closeinv
/clearinventory
/clearinventory2

**Financial and Economy**

/setstock
/incstock
/setprice
/addcash
/storebank
/payphone

**Property and Assets**

/addprop
/delprop
/ownproperty
/unownproperty
/setpropdata
/addgarage
/removegarage
/addbd
/addfd
/addstate
/clearbeds
/addoxyrun

**Weather and Time**

/freezetime
/freezeweather
/time

**Communication and Broadcasting**

/broadcast
/email
Miscellaneous

/setbillboard
/firework
/unitadd
/unitcopy
/unitdelete
/unitown
/forceroulette
/acam
/addrep
/remrep
/phoneperm
/printqueue
/server
/system
/doorhelp
/lasers
/addobj
/addtobj
/deleteobj
/wardrobe
/clearalias
/reloadtracks
/choplists
/refreshfurniture
/resetfurniture
/resetheist
/disablepower
/checkheist
/checkshitlord
/resetshitlord
/togglerobbery
/disablelockdown
/eventloot
/resetmb
/togglemoneytruck
/reset
/setint
/setupgrade
/setlabel

** Police Commans **
/jail
/unjail
