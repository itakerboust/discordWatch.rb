require 'bundler/setup'
Bundler.require

# Load all models
Dir["lib/model/*.rb"].each { |file| require_relative file.sub("lib/", "") }

unless ENV["DISCORD_TOKEN"]
  Dotenv.load
end

bot = Discordrb::Bot.new token: ENV["DISCORD_TOKEN"]

bot.message do |event|
  if event.message.content == '!channel'

    event.channel.send_message(
      'Select a channel to keep in touch about Ruby\'s things' , false, nil, nil, nil, nil,
      Discordrb::Components::View.new do |builder|
        builder.row do |row|
          row.channel_select(custom_id: 'channel_choice', placeholder: 'Choose one channel', channel_types: [:text])
        end
      end
    )
  end
end

bot.channel_select do |event|
  user_choice = event.values.first
  event.interaction.respond(
    content: "**[CHANNEL_SELECT]**\nYou have chosen channel: **#{user_choice.name}**",
    ephemeral: true
  )
end

bot.run