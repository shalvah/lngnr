# Lngnr

Lngnr (read: "longener") is a tiny Ruby app (Sinatra) to lengthen a shortened URL server-side. Prefix a shortened URL with the Lngnr URL, and it will follow redirects on the server and return the final page to you, as opposed to client-side redirects. This is useful if the shortened URL is inaccessible on your local network.

## Usage
Lngnr runs at [l.shalvah.me](http://l.shalvah.me) in production, and localhost:4567 in development. To resolve a shortened URL, prefix it with the Lngnr URL. For example, http://localhost:4567/https://t.co/9I3KMLe2q2 or [http://l.shalvah.me/t.co/9I3KMLe2q2](http://l.shalvah.me/t.co/9I3KMLe2q2) will take you to the final URL that the t.co link points to.

## Development
Requires Ruby 2.7+ and Bundler

- Install dependencies (Windows): `bundle install`
- Install dependencies (other OSes): `bundle install --without windows`
- Start app: `ruby ./app.rb`. This will start the app on localhost:4567 with hot reloading.
- Run tests: `rake spec` (Tests are written in RSpec, in the spec/ folder)