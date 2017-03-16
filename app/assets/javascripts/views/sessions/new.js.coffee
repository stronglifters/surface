Vue.component "login",
  data: () ->
    username: ''
    password: ''
  computed:
    canSubmit: ->
      @username.length > 0 && @password.length > 0
