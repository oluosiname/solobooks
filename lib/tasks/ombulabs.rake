# frozen_string_literal: true

namespace :ombulabs do
  desc 'generate invoice for a given period of time'
  # Usage: rake ombulabs:generate_invoice[2021-01-01,2021-01-31]
  task :generate_invoice, [:from_date, :to_date] => :environment do |_, args|
    from_date = args[:from_date].to_date
    to_date = args[:to_date].to_date

    entries = NokoService::EntriesFetcher.call(from: from_date, to: to_date)
    minutes = entries.sum(&:minutes)
    hours = minutes / 60.0

    user = User.find_by(email: ENV['USER_EMAIL'])
    client = user.clients.find_by(email: ENV['CLIENT_EMAIL'])
    invoice = Invoice.create!(
      user: user,
      client: client,
      date: from_date,
      due_date: from_date + 30.days,
      invoice_category: InvoiceCategory.find_by(name: 'service'),
      currency: Currency.find_by(code: 'USD'),
      language: 'en',
      line_items_attributes: [
        {
          description: "Development services for #{from_date} - #{to_date}",
          quantity: hours.to_i,
          unit_price: 55.0,
          unit: 'hr',
        },
      ],
    )

    pdf_file = InvoiceService::PdfGenerator.call(invoice:)
    InvoiceService::PdfAttacher.call(invoice: invoice, pdf: StringIO.new(pdf_file.render))
  end
end
