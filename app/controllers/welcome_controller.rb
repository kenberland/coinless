class WelcomeController < ApplicationController
  def index
    @email = params['email']
    @service = params['service']
    @lunch = params['lunch']
    @party = params['party']
    @commit = !!params['commit']

    if params['commit']
      st = ActiveRecord::Base.connection.raw_connection.prepare(
        "replace into rsvps (email, event, heads, updated_at) values (?, ?, ?, now()), (?, ?, ?, now())")
      st.execute(@email, 'service', @service.to_i,
                 @email, 'party', @party.to_i)
      st.close
    end
  end

  private 
end
