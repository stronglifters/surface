class Stronglifters.GoogleDrive
  constructor: () ->
    @client_id = "241601222378-kscpfqhpmc6059704mfcq8ckcp799dvn.apps.googleusercontent.com"
    @scopes = [
      'https://www.googleapis.com/auth/drive',
      'https://www.googleapis.com/auth/drive.install',
      'https://www.googleapis.com/auth/drive.file',
      'https://www.googleapis.com/auth/drive.readonly',
      'https://www.googleapis.com/auth/drive.apps.readonly',
    ]

  initializeDrive: () =>
    @loadClient =>
      @printFile()

  checkAuth: () ->
    gapi.auth.authorize({'client_id': @client_id, 'scope': @scopes, 'immediate': false}, @handleAuthResult)

  handleAuthResult: (authResult) =>
    if (authResult)
      gapi.load('drive-share', @initializeDrive)
    else
      @checkAuth()

  loadClient: (callback) ->
    gapi.client.load('drive', 'v2', callback)

  printFile: () =>
    request = gapi.client.drive.files.list({
      'q': "title contains '.stronglifts' and title contains 'backup'"
    })
    request.execute (response) =>
      if !response.error
        item = response.items[0]
        $.post("/training_sessions/drive_upload", {
          accessToken: gapi.auth.getToken().access_token,
          data: item
        }).done (data) ->
          window.location.reload()
      else if (item.error.code == 401)
        @checkAuth()
      else
        console.log('An error occured: ' + response.error.message)
