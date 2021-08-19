# Lngnr

Lngnr (read: "longener") is a tiny Ruby app (Sinatra) to lengthen a shortened URL server-side. Prefix a URL with l.shalvah.me, and it will follow redirects on the server, as opposed to client-side redirects. This is useful if the shortened URL is inaccessible on your local network.

## Development
Requires Ruby 2.7+ and Bundler

- Install dependencies: `bundle install`
- Start app: `ruby ./app.rb`. This will start the app on localhost:4567 with hot reloading.
- Run tests: `rake test`