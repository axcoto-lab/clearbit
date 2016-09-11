get '/' do
	# flash[:info] = 'This is a flash message'
  puts settings
  erb :index, locals: { :plaid_public_key => settings.plaid_public_key}
end

post '/authenticate' do
  puts params["account"]
  user = Plaid::User.create(:connect, 'wells', 'plaid_test', 'plaid_good')

  statement = []

  erb :authenticate, locals: {user: user, statement: statement}
end
