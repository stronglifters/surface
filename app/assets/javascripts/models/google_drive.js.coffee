class Stronglifters.GoogleDrive
  constructor: (options) ->
    @google = gapi
    @client_id = options.client_id
    @drive_upload_path = options.drive_upload_path
    @scopes = [
      'https://www.googleapis.com/auth/drive',
      'https://www.googleapis.com/auth/drive.install',
      'https://www.googleapis.com/auth/drive.file',
      'https://www.googleapis.com/auth/drive.readonly',
      'https://www.googleapis.com/auth/drive.apps.readonly',
    ]

  syncFile: =>
    query = "title contains '.stronglifts' and title contains 'backup'"
    @searchFor query, @uploadFile

  searchFor: (query, callback) =>
    @loadDrive =>
      @google.client.drive.files.list({ 'q': query }).execute(callback)

  uploadFile: (response) =>
    item = response.items[0]
    $.post(@drive_upload_path, {
      accessToken: @google.auth.getToken().access_token,
      data: item
    }).done (data) ->
      window.location.reload()

  authorize: (callback) ->
    @google.auth.authorize({
      'client_id': @client_id,
      'scope': @scopes,
      'immediate': false
    }, callback)

  loadDrive: (callback) =>
    @authorize (response) =>
      @google.load 'drive-share', =>
        @google.client.load 'drive', 'v2', callback
