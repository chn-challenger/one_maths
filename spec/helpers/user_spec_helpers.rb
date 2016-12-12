def create_admin
  user = User.new(first_name: 'Black', last_name: 'Widow', username: 'Angel',email: 'admin@something.com', password: '12344321',
    password_confirmation: '12344321',role:'admin')
  user.save
  user
end

def create_super_admin
  user = User.new(first_name: 'Bruce', last_name: 'Wayne', username: 'Batman', email: 'super_admin@something.com', password: '12344321',
    password_confirmation: '12344321',role:'super_admin')
  user.save
  user
end

def create_student
  user = User.new(first_name: 'Roger', last_name: 'Dodger', username: 'IronMan', email: 'student@something.com', password: '12344321',
    password_confirmation: '12344321',role:'student')
  user.save
  user
end

def create_student_2
  user = User.new(first_name: 'Ray', last_name: 'Donovan', username: 'Mandarin', email: 'student.2@something.com', password: '12344321',
    password_confirmation: '12344321',role:'student')
  user.save
  user
end
