class Panthoot::App < Grape::API
  post do
    Panthoot::Translator.translate! params
  end
end
