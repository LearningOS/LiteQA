class User < ApplicationRecord
  acts_as_tagger
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable,
         :recoverable, :rememberable, :validatable,  # :confirmable, :lockable
         :omniauthable, omniauth_providers: %i[github]

  has_many :posts
  has_many :comments

  store_accessor :payload, :preferences
end
