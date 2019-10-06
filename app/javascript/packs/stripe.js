console.log('stripe.js loaded')
const elements = stripe.elements()
const style = {
          base: {
          color: '#32325d',
          fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
          fontSmoothing: 'antialiased',
          fontSize: '16px',
          '::placeholder': {
          color: '#aab7c4'
          }
          },
          invalid: {
          color: '#fa755a',
          iconColor: '#fa755a'
          }
          }

const card = stripe.elements().create('card', {style: style})
card.mount('#card-element')

card.addEventListener('change', event => {
    const displayError = document.getElementById('card-errors')
    if (event.error) {
        console.log('Error: ', event.error)
        displayError.textContent = event.error.message
    } else {
        displayError.textContent = ''
    }
})

$('#payment-form').submit(event => {
    const $stripeToken = $('#user_stripe_token')
    if ($stripeToken.val().length) {
        return true
    }
    event.preventDefault()
    stripe.createToken(card).then(result => {
        if (result.error) {
            const errorElement = document.getElementById('card-errors')
            errorElement.textContent = result.error.message
        } else {
            $stripeToken.val(result.token.id)
            $(event.target).submit()
        }
    })
})
