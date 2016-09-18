# Tools for querying the MBTA's performance API data

The Massachusetts Bay Transportation Authority (MBTA), also known as "the T", has an API for querying information about service performance.

## How do I use it?

1. Clone this repository
2. Install Ruby if you don't already have it
3. Follow the instructions on http://realtime.mbta.com/portal to get an API key (there's an open development key you can use to get started, but please don't abuse it)
4. Run `API_KEY={your api key} ruby last_train.rb`