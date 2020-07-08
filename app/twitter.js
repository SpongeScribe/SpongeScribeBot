import Twitter from 'twitter-lite';
const client = new Twitter({
    subdomain: "api", // "api" is the default (change for other subdomains)
    version: "1.1", // version "1.1" is the default (change for other subdomains)
    consumer_key: process.env.TWITTER_CONSUMER_KEY, // from Twitter.
    consumer_secret: process.env.TWITTER_CONSUMER_SECRET, // from Twitter.
    access_token_key: process.env.ACCESS_TOKEN, // from your User (oauth_token)
    access_token_secret: process.env.ACCESS_TOKEN_SECRET // from your User (oauth_token_secret)
});

// client
//     .get("account/verify_credentials")
//     .then(
//         results => {
//             console.log("results", results);
//         }
//     )
//     .catch(console.error);

async function tweetThreadReply(lastTweetID, thread) {
  for (const status of thread) {
    const tweet = await client.post("statuses/update", {
      status: status,
      in_reply_to_status_id_str: lastTweetID,
      auto_populate_reply_metadata: true
    });
    lastTweetID = tweet.id_str;
  }
}
async function tweetThread(thread) {
    tweetThreadReply('', thread);
}

const thread = ["First tweet", "Second tweet", "Third tweet"];
tweetThreadReply("", thread).catch(console.error);
// 100,000 requests per day to the /statuses/mentions_timeline endpoint. This is in addition to existing user-level rate limits (75 requests / 15-minutes
1279945534917263361

// client
//     .get("statuses/mentions_timeline.json")
//     .then(
//         results => {
//             console.log("results", results);
//         }
//     )
//     .catch(console.error);
