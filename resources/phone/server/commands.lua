function RegisterChatCommands()
  Chat:RegisterAdminCommand("clearalias", function(source, args, rawCommand)
    if tonumber(args[1]) then
      local plyr = exports['core']:FetchSID(tonumber(args[1]))
      if plyr ~= nil then
        local char = plyr:GetData("Character")
        if char ~= nil then
          local aliases = char:GetData("Alias")
          aliases[args[2]] = nil
          char:SetData("Alias", aliases)
          Chat.Send.System:Single(
            source,
            string.format(
              "Alias Cleared For %s %s (%s) For %s",
              char:GetData("First"),
              char:GetData("Last"),
              char:GetData("SID"),
              args[2]
            )
          )
        else
          Chat.Send.System:Single(source, "Invalid Target")
        end
      else
        Chat.Send.System:Single(source, "Invalid Target")
      end
    else
      Chat.Send.System:Single(source, "Invalid Target")
    end
  end, {
    help = "[Admin] Clear Player App Alias",
    params = {
      {
        name = "SID",
        help = "Target State ID",
      },
      {
        name = "App ID",
        help = "App ID to reset the players alias for",
      },
    },
  }, 2)

  Chat:RegisterStaffCommand("ctwitter", function(source, args, rawCommand)
    ClearAllTweets(tonumber(args[1]))
    Chat.Send.System:Single(source, "All Tweets Removed")
  end, {
    help = "[Admin] Clear All Tweets",
    params = {
      {
        name = "SID",
        help = "(Optional) Target State ID",
      },
    },
  }, -1)

  Chat:RegisterStaffCommand("twitteraccount", function(source, args, rawCommand)
    local twitterName = args[1]

    local fetchTwitterAccount = MySQL.single.await([[
      SELECT * FROM `characters` WHERE JSON_EXTRACT(Alias, '$.twitter') LIKE ?;
    ]], { '%' .. twitterName .. '%' })

    if fetchTwitterAccount then
      local char = exports['core']:FetchSID(fetchTwitterAccount.SID):GetData("Character")
      Chat.Send.System:Single(
        source,
        string.format(
          "Twitter Account Found With Name: %s. %s %s (SID: %s) [User: %s]",
          twitterName,
          char:GetData("First"),
          char:GetData("Last"),
          char:GetData("SID"),
          char:GetData("User")
        )
      )
    else
      Chat.Send.System:Single(source, "No Twitter Account Found")
    end
  end, {
    help = "[Admin] Get Twitter Account Owner",
    params = {
      {
        name = "Account Name",
        help = "Account Name of User You Want to Find",
      },
    },
  }, 1)

  Chat:RegisterAdminCommand("reloadtracks", function(source, args, rawCommand)
    ReloadRaceTracks()
    Chat.Send.System:Single(source, "Reload Vroom Vrooms")
  end, {
    help = "[Admin] Clear All Tweets",
  }, 0)
end
