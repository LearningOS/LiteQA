class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable,
         :recoverable, :rememberable, :validatable #, :confirmable, :lockable

  has_many :posts
  has_many :comments

  store_accessor :payload, :preferences
end
