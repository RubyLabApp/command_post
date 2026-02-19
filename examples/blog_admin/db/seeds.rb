admin = User.find_or_create_by!(email: "admin@example.com") do |u|
  u.name = "Admin User"
  u.role = "admin"
  u.admin = true
end

editor = User.find_or_create_by!(email: "editor@example.com") do |u|
  u.name = "Jane Editor"
  u.role = "editor"
  u.admin = false
end

author = User.find_or_create_by!(email: "author@example.com") do |u|
  u.name = "John Author"
  u.role = "author"
  u.admin = false
end

[admin, editor, author].each do |user|
  3.times do |i|
    post = Post.find_or_create_by!(title: "#{user.name}'s Post ##{i + 1}") do |p|
      p.body = "This is a sample blog post by #{user.name}."
      p.published = i.even?
      p.user = user
    end

    2.times do |j|
      Comment.find_or_create_by!(author_name: "Reader #{j + 1}", post: post) do |c|
        c.content = "Great post, #{user.name}! Comment ##{j + 1}."
      end
    end
  end
end

## Projects — showcase all 7 new field types
Project.find_or_create_by!(name: "Website Redesign") do |p|
  p.status = "active"
  p.permissions = "read,write,deploy"
  p.cover_image_url = "https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=600"
  p.progress = 72
  p.config = '{"framework":"Rails 8","database":"PostgreSQL","cache":"Redis","cdn":"CloudFront"}'
  p.deploy_script = "#!/bin/bash\nbundle exec rails db:migrate\nbundle exec rails assets:precompile\nrails server -e production"
  p.api_key = "sk_live_abc123xyz789"
  p.user = admin
end

Project.find_or_create_by!(name: "Mobile App") do |p|
  p.status = "paused"
  p.permissions = "read,write"
  p.cover_image_url = "https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=600"
  p.progress = 35
  p.config = '{"platform":"iOS + Android","language":"Swift / Kotlin","api_version":"v2"}'
  p.deploy_script = "fastlane ios release\nfastlane android release"
  p.api_key = "sk_live_mobile_456"
  p.user = editor
end

Project.find_or_create_by!(name: "Legacy Migration") do |p|
  p.status = "archived"
  p.permissions = "read"
  p.cover_image_url = nil
  p.progress = 100
  p.config = '{"source":"MySQL 5.7","target":"PostgreSQL 16","records_migrated":"1.2M"}'
  p.deploy_script = nil
  p.api_key = "sk_test_legacy_789"
  p.user = author
end

Project.find_or_create_by!(name: "API Gateway") do |p|
  p.status = "active"
  p.permissions = "read,write,deploy,admin"
  p.cover_image_url = "https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=600"
  p.progress = 89
  p.config = '{"rate_limit":"1000/min","auth":"JWT","regions":"us-east-1,eu-west-1"}'
  p.deploy_script = "terraform plan\nterraform apply -auto-approve\naws ecs update-service --force-new-deployment"
  p.api_key = "sk_live_gateway_012"
  p.user = admin
end

puts "Seeded #{User.count} users, #{Post.count} posts, #{Comment.count} comments, #{Project.count} projects."
