def create_tester(num)
  user = User.new(first_name: "Twitch #{num}", last_name: "Maokai #{num}", username: "Crow#{num}",email: "tester#{num}@something.com", password: '12344321',
    password_confirmation: '12344321',role:'tester')
  user.save!
  user
end
