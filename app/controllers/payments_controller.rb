class PaymentsController < ApplicationController
  def subscribe
    email = params[:email].present? ? params[:email] : 'demo+stripe@codepicnic.com'
    token = params[:token]
    plan = params[:plan]
    
    if cookies.signed[:stripe_customer_id].present? #if is the first time a customer will pay
      customer = Payment.retrieve_customer(cookies.signed[:stripe_customer_id])
    else
      customer = Payment.create_customer(email, token)
      
      cookies.signed[:stripe_customer_id] = customer['id']
    end
    
    payment = Payment.new(token, email, plan, customer['id'])
    payment.save
    
    respond_to do |format|
      format.js   { render js: "alert('Purchase successfully!');" }    
      format.html { redirect_to root_path }
    end
  end
end
