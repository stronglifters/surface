#= require models/google_drive
Stronglifters.GoogleSyncButton = Ractive.extend
  template: RactiveTemplates["templates/google_sync_button"]
  oninit: ->
    @set(text: 'Sync with Google', icon: 'fa-camera-retro')
    @on 'synchronize', (event) ->
      @synchronize()

  synchronize: ->
    @set(text: 'Syncing...', icon: 'fa-spin fa-spinner')
    @drive().syncFile()

  drive: ->
    @_drive ||= new Stronglifters.GoogleDrive
      client_id: @get('client_id')
      drive_upload_path: @get('drive_upload_path')

