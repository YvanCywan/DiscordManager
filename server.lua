notWhitelistedMessage = "You are not whitelisted for this server.")
whitelistRoles = {
  "DISCORD_ROLE_ID",
}
blacklistRole = {
  "DISCORD_ROLE_ID",
}

bannedMessage = "You are currently banned from the server"
AddEventHandler("playerConnecting", function(name, setCallback, deferrals)
    local src = source
    local passAuth = false
    deferrals.defer()
    deferrals.update("Checking Permissions...")

    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            identifierDiscord = v
        end
    end

    if identifierDiscord then
        usersRoles = exports.discord_perms:GetRoles(src)
        local function has_value(table, val)
            if table then
                for index, value in ipairs(table) do
                    if value == val then
                        return true
                    end
                end
            end
            return false
        end
        for index, valueReq in ipairs (blacklistRole) do
          if has_value(usersRoles, valueReq) then
            passAuth = false
            deferrals.done(bannedMessage)
          else
            for index, valueReq in ipairs (whitelistRoles) do
              if has_value(usersRoles, valueReq) then
                passAuth = true
              if next(whitelistRoles, index) == nil then
                if passAuth == true then
                  deferrals.done()
                else
                  deferrals.done(notWhitelistedMessage)
                end
              end
            end
          end
        end
        else
           deferrals.done("Discord was not detected. Please make sure Discord is running and installed.")
        end
    end)