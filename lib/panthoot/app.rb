class Panthoot::App
  def call(env)
    Panthoot::Translator.translate! Rack::Request.new(env).params

    [200, {}, [' ']]
  end
end
