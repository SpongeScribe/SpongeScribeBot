import Twitter from 'twitter-lite';
const client = new Twitter({
    subdomain: "api", // "api" is the default (change for other subdomains)
    version: "1.1", // version "1.1" is the default (change for other subdomains)
    consumer_key: process.env.TWITTER_API_KEY, // from Twitter.
    consumer_secret: process.env.TWITTER_API_SECRET_KEY, // from Twitter.
    access_token_key: process.env.TWITTER_ACCESS_TOKEN, // from your User (oauth_token)
    access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET // from your User (oauth_token_secret)
});

client
    .get("account/verify_credentials")
    .then(
        results => {
            console.log("results", results);
        }
    )
    .catch(console.error);
