namespace :admin do
  desc 'Create the first admin user. Usage: rails admin:create_first_admin EMAIL=admin@example.com PASSWORD=secret123 NAME=Admin'
  task create_first_admin: :environment do
    email = ENV['EMAIL'].to_s.strip.downcase
    password = ENV['PASSWORD'].to_s
    name = ENV.fetch('NAME', 'Initial Admin').to_s.strip

    abort 'EMAIL is required' if email.blank?
    abort 'PASSWORD is required' if password.blank?
    abort 'An admin user already exists' if User.admin.exists?

    user = User.create!(
      email: email,
      password: password,
      password_confirmation: password,
      name: name,
      role: 'admin',
      status: 'active'
    )

    puts "Created admin user ##{user.id}: #{user.email}"
  end
end
