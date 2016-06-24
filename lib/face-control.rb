require 'singleton'
require 'timerizer'
require 'securerandom'

class FaceControl
  include Singleton

  def auth(params)
    logaded?(params[:user], params[:hash])
    user = User.find_by_id_facebook(params[:hash])
    unless(user)
      user = create_user(params)
    end
    hash_random = SecureRandom.hex
    Token.create(hash_random:hash_random, user: user)
    hash_random
  end

  def logaded?(id_user, hash)
    #checa se o usuario ta logado e com esse
    #hash.
    true
  end

  def create_user(params)
    user_hash = {}
    user_hash[:id_facebook] = params[:hash]
    user_hash[:name] = params[:name]
    user_hash[:email] = params[:email]
    user_hash[:url_photo] = params[:url_photo]
    user_hash[:url_facebook] = params[:url_face]
    User.create(user_hash)
  end

end
