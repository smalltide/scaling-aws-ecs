class PagesController < ApplicationController
  def home
    @total_hits = Rails.cache.increment('total_hits')
    @hostname   = Socket.gethostname

    ThrowJavelinsJob.perform_later
  end

  def health_check
    head :ok
  end
end
