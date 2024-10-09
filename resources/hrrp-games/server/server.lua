local _uircd = {}

AddEventHandler("Hud:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
  Fetch = exports["hrrp-base"]:FetchComponent("Fetch")
  Logger = exports["hrrp-base"]:FetchComponent("Logger")
  Chat = exports["hrrp-base"]:FetchComponent("Chat")
  Callbacks = exports["hrrp-base"]:FetchComponent("Callbacks")
  Execute = exports["hrrp-base"]:FetchComponent("Execute")
  RegisterChatCommands()
end

local setupEvent = nil
setupEvent = AddEventHandler("Core:Shared:Ready", function()
  exports["hrrp-base"]:RequestDependencies("Hud", {
    "Fetch",
    "Logger",
    "Chat",
    "Callbacks",
    "Execute",
  }, function(error)
    if #error > 0 then
      return
    end -- Do something to handle if not all dependencies loaded
    RetrieveComponents()
    RemoveEventHandler(setupEvent)
  end)
end)

function RegisterChatCommands()
  -- Chat:RegisterAdminCommand("notif", function(source, args, rawCommand)
  -- 	exports["hrrp-base"]:FetchComponent("Execute"):Client(source, "Notification", "Success", "This is a test, lul")
  -- end, {
  -- 	help = "Test Notification",
  -- })

  -- Chat:RegisterAdminCommand("list", function(source, args, rawCommand)
  -- 	TriggerClientEvent("ListMenu:Client:Test", source)
  -- end, {
  -- 	help = "Test List Menu",
  -- })

  -- Chat:RegisterAdminCommand("input", function(source, args, rawCommand)
  -- 	TriggerClientEvent("Input:Client:Test", source)
  -- end, {
  -- 	help = "Test Input",
  -- })

  -- Chat:RegisterAdminCommand("confirm", function(source, args, rawCommand)
  -- 	TriggerClientEvent("Confirm:Client:Test", source)
  -- end, {
  -- 	help = "Test Confirm Dialog",
  -- })

  -- Chat:RegisterAdminCommand("skill", function(source, args, rawCommand)
  -- 	TriggerClientEvent("Minigame:Client:Skillbar", source)
  -- end, {
  -- 	help = "Test Skill Bar",
  -- })

  -- Chat:RegisterAdminCommand("scan", function(source, args, rawCommand)
  -- 	TriggerClientEvent("Minigame:Client:Scanner", source)
  -- end, {
  -- 	help = "Test Scanner",
  -- })

  -- Chat:RegisterAdminCommand("sequencer", function(source, args, rawCommand)
  -- 	TriggerClientEvent("Minigame:Client:Sequencer", source)
  -- end, {
  -- 	help = "Test Sequencer",
  -- })

  -- Chat:RegisterAdminCommand("keypad", function(source, args, rawCommand)
  -- 	TriggerClientEvent("Minigame:Client:Keypad", source)
  -- end, {
  -- 	help = "Test Keypad",
  -- })

  -- Chat:RegisterAdminCommand("scrambler", function(source, args, rawCommand)
  -- 	TriggerClientEvent("Minigame:Client:Scrambler", source)
  -- end, {
  -- 	help = "Test Scrambler",
  -- })

  -- Chat:RegisterAdminCommand("memory", function(source, args, rawCommand)
  -- 	TriggerClientEvent("Minigame:Client:Memory", source)
  -- end, {
  -- 	help = "Test Memory",
  -- })
end
