# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :set_profile, except: [:create]

  def show
  end

  def create
    @profile = Profile.new(profile_params.merge(user: current_user))
    if @profile.save
      redirect_to profile_path, notice: I18n.t('record.create.success', resource: @profile.class.model_name.human)
    else
      render :show, status: :unprocessable_entity
    end
  end

  def update
    if @profile.update(profile_params)
      redirect_to profile_path, notice: I18n.t('record.update.success', resource: @profile.class.model_name.human)
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_profile
    @profile = current_user.profile || current_user.build_profile
    @profile.build_address unless @profile.address
  end

  def profile_params
    params.require(:profile).permit(
      :legal_status,
      :full_name,
      :phone_number,
      :date_of_birth,
      :nationality,
      :country,
      :business_name,
      :tax_number,
      :vat_id,
      :invoice_currency_id,
      :invoice_language,
      :logo,
      address_attributes: [:id, :street_address, :city, :state, :postal_code, :country],
    )
  end
end
