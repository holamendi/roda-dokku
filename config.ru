require "roda"

class App < Roda
  route do |r|
    r.root do
      "Look behind you, a three headed monkey! (test)"
    end
  end
end

run App.freeze.app
