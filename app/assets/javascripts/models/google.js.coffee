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
      #console.dir(authResult)
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
      console.dir(response)
      if !response.error
        item = response.items[0]
        console.log('Title: ' + item.title)
        console.log('Description: ' + item.description)
        console.log('MIME type: ' + item.mimeType)
        fileId = item.id
        downloadUrl = item.downloadUrl
        $.post( "/training_sessions/drive_upload", item)
          .done (data) ->
            console.dir(data)
      else if (item.error.code == 401)
        #// Access token might have expired.
        @checkAuth()
      else
        console.log('An error occured: ' + response.error.message)
