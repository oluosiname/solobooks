# frozen_string_literal: true

class ProcessOverdueInvoicesJob
  include Sidekiq::Job

  def perform
    Invoice.sent.where('due_date < ?', Time.zone.today).find_each(&:mark_overdue!)
  end
end
