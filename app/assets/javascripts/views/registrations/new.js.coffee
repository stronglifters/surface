Vue.component "registration",
  data: () ->
    terms_and_conditions: ''
    email: ''
    password: ''
    username: ''
  computed:
    validation: ->
      username: @username.length > 0
      email: @email.length > 0
      password: @password.length > 0
      terms_and_conditions: @terms_and_conditions

    isValid: ->
      validation = @validation
      Object.keys(validation).every (key) =>
        validation[key]
