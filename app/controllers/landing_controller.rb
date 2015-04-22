class LandingController < ApplicationController
  def index
    if cookies.signed[:stripe_customer_id].present? #if is the first time a customer will pay
      @current_customer = Payment.retrieve_customer(cookies.signed[:stripe_customer_id])
    end
  end
end
