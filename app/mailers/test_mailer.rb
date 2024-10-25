# frozen_string_literal: true

class TestMailer < ApplicationMailer
  default from: 'dev@solobooks.de'

  def hello
    mail(
      subject: 'Hello from Postmark',
      to: 'dev@solobooks.de',
      from: 'dev@solobooks.de',
      html_body: '<strong>Hello</strong> dear Postmark user.',
      track_opens: 'true',
      message_stream: 'outbound',
    )
  end
end
