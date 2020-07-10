import {} from 'dotenv/config.js'


import pkg from 'twitter-autohook';
const { Autohook } = pkg;

async function sayHi(event) => {
  // We check that the message is a direct message
  if (!event.direct_message_events) {
    return;
  }

  // Messages are wrapped in an array, so we'll extract the first element
  const message = event.direct_message_events.shift();

  // We check that the message is valid
  if (typeof message === 'undefined' || typeof message.message_create === 'undefined') {
    return;
  }

  // We filter out message you send, to avoid an infinite loop
  if (message.message_create.sender_id === message.message_create.target.recipient_id) {
    return;
  }

  // Prepare and send the message reply
  const senderScreenName = event.users[message.message_create.sender_id].screen_name;

  const requestConfig = {
    url: 'https://api.twitter.com/1.1/direct_messages/events/new.json',
    oauth: oAuthConfig,
    json: {
      event: {
        type: 'message_create',
        message_create: {
          target: {
            recipient_id: message.message_create.sender_id,
          },
          message_data: {
            text: `Hi @${senderScreenName}! 👋`,
          },
        },
      },
    },
  };
  await post(requestConfig);
}
async function markAsRead(messageId, senderId, auth) {
  const requestConfig = {
    url: 'https://api.twitter.com/1.1/direct_messages/mark_read.json',
    form: {
      last_read_event_id: messageId,
      recipient_id: senderId,
    },
    oauth: auth,
};

async function indicateTyping(senderId, auth) {
  const requestConfig = {
    url: 'https://api.twitter.com/1.1/direct_messages/indicate_typing.json',
    form: {
      recipient_id: senderId,
    },
    oauth: auth,
};

(async start => {
  try {
    const webhook = new Autohook();

    // Removes existing webhooks
    await webhook.removeWebhooks();

    // Listens to incoming activity
    webhook.on('event', event => async event => {
      if (event.direct_message_events) {
        await sayHi(event);
      }

      console.log('Something happened:', event));
    }

    // Starts a server and adds a new webhook
    await webhook.start();

    // Subscribes to your own user's activity
    await webhook.subscribe({oauth_token: process.env.TWITTER_ACCESS_TOKEN, oauth_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET});
  } catch (e) {
    // Display the error and quit
    console.error(e);
    process.exit(1);
  }
})();

// https://dev.to/alexluong/comprehensive-guide-to-twitter-webhook-1cd3
// https://classic.yarnpkg.com/blog/2016/11/24/offline-mirror/
