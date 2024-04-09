# frozen_string_literal: true

class ClientsController < ApplicationController
  before_action :set_client, only: [:edit, :show]

  def index
    @clients = current_user.clients
  end

  def show
  end

  def new
    @client = Client.new
    @address = @client.build_address
    @modal = params[:modal] == 'true'
  end

  def edit
    @client.build_address unless @client.address # This is especially easy to forget
  end

  def create
    @client = Client.new(client_params.merge(user: current_user))
    respond_to do |format|
      if @client.save
        @clients = current_user.clients
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(
            'invoice_client_id',
            partial: 'invoices/invoice_client_options',
            locals: { clients: @clients, selected: @client.id },
          )
        end
        format.html { redirect_to client_url(@client), notice: i18n.t('record.create.success', object: 'Client') }
      else
        @clients = current_user.clients
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(
            'client_errors',
            partial: 'clients/client_errors',
            locals: { clients: @clients, client: @client },
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
