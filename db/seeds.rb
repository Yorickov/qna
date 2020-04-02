# This file should contain all the record creation needed to seed the database with its
# default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database
# with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Question.destroy_all
User.destroy_all

admin = User.create(
  email: 'ivanov.dharmabum@yandex.ru',
  password: 'secret1',
  password_confirmation: 'secret1',
  confirmed_at: Time.now,
  admin: true
)

user = User.create(
  email: 'test0guru@yandex.ru',
  password: 'secret2',
  password_confirmation: 'secret2',
  confirmed_at: Time.now
)

q1, q2, q3 = Question.create(
  [
    {
      title: 'First programming language',
      body: 'Which programming language is best to learn first?',
      user: admin
    },
    {
      title: 'Programming book for a beginner?',
      body: 'What programming book would you recommend for learning Elixir?',
      user: admin
    },
    {
      title: 'Framework for REST API',
      body: 'What are the best framework to create a REST API in a very short time?',
      user: user
    }
  ]
)

Answer.create(
  [
    {
      body: 'I have no idea',
      question: q2,
      user: user
    },
    {
      body: 'What is REST API?',
      question: q3,
      user: admin
    },
    {
      body: 'Structure and Interpretation of Computer Programs',
      question: q1,
      user: user
    },
    {
      body: 'Ruby on Rails',
      question: q3,
      user: admin
    },
    {
      body: 'Cobol',
      question: q1,
      user: user
    },
    {
      body: 'Structure and Interpretation of Computer Programs',
      question: q2,
      user: user
    }
  ]
)
