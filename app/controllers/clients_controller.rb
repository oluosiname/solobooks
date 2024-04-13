# frozen_string_literal: true

class ClientsController < ApplicationController
  before_action :set_client, only: [:edit, :show]

  def index
    @clients = current_user.clients.includes(:address)
  end

  def show
  end

  def new
    @client = current_user.clients.new
    @address = @client.build_address
  end

  def new_modal
    @client = current_user.clients.new
    @address = @client.build_address
    @modal = true
  end

  def edit
    @client.build_address unless @client.address # This is especially easy to forget
  end

  def create
    @client = Client.new(client_params.merge(user: current_user))

    respond_to do |format|
      if @client.save
        format.turbo_stream do
          if params[:client][:modal] == 'true'
            render turbo_stream: turbo_stream.update(
              'invoice_client_id',
              partial: 'invoices/invoice_client_options',
              locals: { clients: current_user.clients, selected: @client.id },
            )
          else

            redirect_to clients_url, notice: t('record.create.success', resource: @client.class.model_name.human)
          end
        end
        format.html do
          redirect_to clients_url,
            notice: i18n.t('record.create.success', resource: @client.class.model_name.human)
        end
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(
            'client_errors',
            partial: 'partials/resource_error_messages',
            locals: { clients: current_user.clients, client: @client, resource: @client },
          ),
            status: :unprocessable_entity
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_client
    @client = current_user.clients.find(params[:id])
  end

  def client_params
    params.require(:client).permit(
      :name,
      :email,
      :phone_number,
      :business_name,
      :business_tax_id,
      :vat_number,
      address_attributes: [:street_address, :city, :state, :postal_code, :country],
    )
  end
end
