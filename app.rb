require "roda"
require "vite_roda"
require "logger"
require "json"

LOGGER = Logger.new($stdout)
JSON_RESUME = JSON.parse(File.read("resume.json"))

class App < Roda
  plugin :common_logger, LOGGER
  plugin :json
  plugin :type_routing
  plugin :vite

  route do |r|
    r.root do
      <<~HTML
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Smol Roda</title>
          #{vite_client_tag}
          #{vite_stylesheet_tag "entrypoints/application.css"}
          #{vite_javascript_tag "entrypoints/application.js"}
        </head>
        <body class="bg-gradient-to-br from-purple-900 to-indigo-900 min-h-screen flex items-center justify-center">
          <div class="bg-white/10 backdrop-blur-lg rounded-2xl p-8 shadow-2xl text-center max-w-md">
            <h1 class="text-4xl font-bold text-white mb-4">Smol Roda</h1>
            <p class="text-purple-200 text-lg mb-6">Look behind you, a three headed monkey!</p>
            <div class="flex gap-3 justify-center">
              <a href="/say/Guybrush" class="bg-purple-500 hover:bg-purple-600 text-white px-4 py-2 rounded-lg transition-colors">
                Say Hello
              </a>
              <a href="/resume" class="bg-indigo-500 hover:bg-indigo-600 text-white px-4 py-2 rounded-lg transition-colors">
                View Resume
              </a>
            </div>
          </div>
        </body>
        </html>
      HTML
    end

    r.on "say" do
      r.is String do |name|
        "Hello, #{name}!"
      end
    end

    r.get "resume" do
      JSON_RESUME
    end
  end
end
