class Payment
  KEY   = 'sk_test_kHE9Z9taFDTG4Xa0k8Zhv0J9'
  
  def initialize(token, email, plan, stripe_customer_id)
    @token                = token
    @email                = email 
    @plan                 = plan
    @stripe_customer_id   = stripe_customer_id
  end
  
  def self.create_customer(email, token)
    Stripe.api_key = KEY
    
    Stripe::Customer.create({
      email: email,
      description: "Customer for #{email}",
      source: token
    })
  end
  
  def self.retrieve_customer(stripe_customer_id)
    Stripe.api_key = KEY
    
    Stripe::Customer.retrieve(stripe_customer_id)
  end
  
  def save
    Stripe.api_key = KEY
  
    customer = Stripe::Customer.retrieve(@stripe_customer_id)
    
    # Rails.logger.info customer.inspect
    
    # We add a card to the customer
    
    if @token
      card = customer.sources.create(card: @token)
    end
    
    # Then, we create a subscription to the customer
    
    subscription = customer.subscriptions.create(plan: @plan)
    
    Rails.logger.info subscription.inspect
  
    customer
  rescue Stripe::CardError => e
    # Since it's a decline, Stripe::CardError will be caught
    Rails.logger.info e.inspect
  rescue Stripe::InvalidRequestError => e
    # Invalid parameters were supplied to Stripe's API
    Rails.logger.info e.inspect
  rescue Stripe::AuthenticationError => e
    # Authentication with Stripe's API failed
    # (maybe you changed API keys recently)
    Rails.logger.info e.inspect
  rescue Stripe::APIConnectionError => e
    # Network communication with Stripe failed
    Rails.logger.info e.inspect
  rescue Stripe::StripeError => e
    # Display a very generic error to the user, and maybe send
    # yourself an email
    Rails.logger.info e.inspect
  rescue => e
    # Something else happened, completely unrelated to Stripe
    Rails.logger.info e.message
  end
end