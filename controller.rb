get '/' do
	# flash[:info] = 'This is a flash message'
  puts settings
  erb :index, locals: { :plaid_public_key => settings.plaid_public_key}
end

post '/authenticate' do
  user = Plaid::User.exchange_token(params['public_token'])

  erb :authenticate, locals: {
    domains: Extractor::Base.extract(user),
    statement: user.transactions}
end
