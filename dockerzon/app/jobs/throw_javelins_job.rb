class ThrowJavelinsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    sleep 5
    javelins_thrown = rand(1..10)
    Javelin.create!(thrown: javelins_thrown)
  end
end
