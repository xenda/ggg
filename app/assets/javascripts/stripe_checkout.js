var stripe_pk = 'pk_test_VO3K5UNsu4JPCbUBCPGDnaWA',
    email = 'demo+stripe@codepicnic.com';

$(document).on('click', '.subscribe-button', function(e){
  e.preventDefault();
  
  var subscriptionName   = $(this).data('subscription-name'),
      subscriptionPrice  = $(this).data('subscription-price'),
      subscriptionPlanId = $(this).data('subscription-plan-id');
  
  var handler = StripeCheckout.configure({
    key: stripe_pk,
    image: 'https://s3.amazonaws.com/stripe-uploads/acct_15B8juJ7ltyW6zz6merchant-icon-1424563884754-cp_isotipe.png',
    name: 'CodePicnic',
    email: email,
    token: function(token) {
      $.post("/payments/subscribe", {
        token: token.id,
        email: token.email,
        plan: subscriptionPlanId
      });
    },
    description: subscriptionName + " Plan (" +  subscriptionPrice + " per month)",
    panelLabel: "Subscribe",
    allowRememberMe: false
  });

  handler.open();
});