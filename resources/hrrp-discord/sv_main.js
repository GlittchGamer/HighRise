const convarGuildId = GetConvar('guild_id', '');

const guildId = convarGuildId;

const botToken = GetConvar('bot_token', '');

var work = true;
const axios = require('axios').default;

const getUserDiscord = (source) => {
  if (typeof source == 'string') return source;
  if (!GetPlayerName(source)) return false;
  let arr = [];
  for (let index = 0; index <= GetNumPlayerIdentifiers(source); index++) {
    if (GetPlayerIdentifier(source, index)) {
      arr.push(GetPlayerIdentifier(source, index));
    }
  }

  const found = arr.find((id) => id.includes('discord:'));

  if (found) {
    return found.replace('discord:', '');
  } else {
    return undefined;
  }
};

setImmediate(async () => {
  let botAccount = await axios({
    method: 'GET',
    url: `https://discord.com/api/v9/users/@me`,
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bot ${botToken}`,
    },
  }).catch(async (err) => {
    console.log(`^1[Discord] ^7Bot token is incorrect, ensure your token is correct. ^1Stopping...^7`);
    work = false;
  });

  if (botAccount.data) {
    await axios({
      method: 'GET',
      url: `https://discord.com/api/v9/guilds/${guildId}`,
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bot ${botToken}`,
      },
    }).catch(async (err) => {
      console.log(`^1[Discord] ^7Guild ID is incorrect or bot isn't in guild. ^1Stopping...^7`);
      console.log(`^1[Discord] ^7Invite: https://discord.com/api/oauth2/authorize?client_id=${botAccount.data.id}&permissions=1024&scope=bot ^7`);
      work = false;
    });

    if (work) console.log(`^1[Discord] ^7Ready! ^2Running...^7`);
  }
});

exports('getRoles', async (src) => {
  if (!work) return;
  const userId = getUserDiscord(src);

  if (userId) {
    try {
      const resDis = await axios({
        method: 'GET',
        url: `https://discord.com/api/v9//guilds/${guildId}/members/${userId}`,
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bot ${botToken}`,
        },
      });
      if (!resDis.data) {
        return false;
      } else {
        return resDis.data.roles;
      }
    } catch (err) {
      return false;
    }
  } else {
    return false;
  }
});
