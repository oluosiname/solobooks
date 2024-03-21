# frozen_string_literal: true

class User < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :clients, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
    :registerable,
    :confirmable,
    :recoverable,
    :rememberable,
    :validatable,
    :trackable
end
