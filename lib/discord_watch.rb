require 'bundler/setup'
Bundler.require

# Load all models
Dir["lib/model/*.rb"].each { |file| require_relative file.sub("lib/", "") }

unless ENV["DISCORD_TOKEN"]
  Dotenv.load
end

bot = Discordrb::Bot.new token: ENV["DISCORD_TOKEN"]

bot.register_application_command(:channel_picker, 'Setup notification channel') do |cmd|
  cmd.channel('channel', 'Select a channel to keep in touch about Ruby\'s things', types: [:text], required: true)

end

bot.channel_select do |event|
  user_choice = event.values.first
  event.interaction.respond(
    content: "**[CHANNEL_SELECT]**\nYou have chosen channel: **#{user_choice.name}**",
    ephemeral: true
  )
bot.application_command(:channel_picker) do |event|
  server_id = event.server.id
  channel_id = event.options["channel"]
  puts "[USER INPUT] channel_picker() { server_id: #{server_id}, channel_id: #{channel_id}}"

  channel = Channel.find_or_initialize_by(server_id: server_id)
  channel.id = channel_id

  embed = if channel.save
            { description: ":white_check_mark: Your channel is saved
            :partying_face: You will stay in informed of Ruby's things" }
          else
            { description: ":cry: An error has occurred, your choice hasn't been saved" }
          end
  event.respond(embeds: [embed], ephemeral:true)
end

bot.run