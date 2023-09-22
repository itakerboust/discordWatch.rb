require 'bundler/setup'
Bundler.require

unless ENV["DISCORD_TOKEN"]
  Dotenv.load
end

bot = Discordrb::Bot.new token: ENV["DISCORD_TOKEN"]

bot.run