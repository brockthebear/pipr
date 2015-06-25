User.create!(name:  "Demo",
             email: "demo@example.com",
             password:              "password",
             password_confirmation: "password",
             admin:     false,
             activated: true,
             activated_at: Time.zone.now)
