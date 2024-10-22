# frozen_string_literal: true

class User < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :clients, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_one :payment_detail, dependent: :destroy
  has_one :setting, through: :profile
  has_one :vat_status, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :incomes, dependent: :destroy
  has_many :financial_transactions, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
    :registerable,
    :confirmable,
    :recoverable,
    :rememberable,
    :validatable,
    :trackable

  def can_create_invoice?
    profile.present? && profile.complete? && payment_detail.present?
  end
end
