import Twitter from 'twitter-lite';
const client = new Twitter({
    subdomain: "api", // "api" is the default (change for other subdomains)
    version: "1.1", // version "1.1" is the default (change for other subdomains)
    consumer_key: process.env.TWITTER_CONSUMER_KEY, // from Twitter.
    consumer_secret: process.env.TWITTER_CONSUMER_SECRET, // from Twitter.
    access_token_key: process.env.ACCESS_TOKEN, // from your User (oauth_token)
    access_token_secret: process.env.ACCESS_TOKEN_SECRET // from your User (oauth_token_secret)
});

async function verifyCredentials(client) {
  client
    .get("account/verify_credentials")
    .then(
        results => {
            console.log("results", results);
        }
    )
    .catch(console.error);
}

async function tweetThreadReply(client, lastTweetID, thread) {
  for (const status of thread) {
    const tweet = await client.post("statuses/update", {
      status: status,
      in_reply_to_status_id_str: lastTweetID,
      auto_populate_reply_metadata: true
    });
    lastTweetID = tweet.id_str;
  }
}

async function tweetThread(client, thread) {
    tweetThreadReply(client, '', thread);
}

const thread = ["First tweet", "Second tweet", "Third tweet"];
tweetThreadReply("", thread).catch(console.error);
