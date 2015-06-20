Stronglifters.GoogleSyncButton = Ractive.extend
  template: "<button on-click='synchronize'><i class='fa {{icon}}'></i> {{text}}</button>",
  oninit: ->
    @set(text: 'Sync With Google', icon: 'fa-camera-retro')
    @drive = new Stronglifters.GoogleDrive
      client_id: @get('client_id')
      drive_upload_path: @get('drive_upload_path')
    @on 'synchronize', (event) ->
      @synchronize(@drive)

  synchronize: (drive) ->
    @set(text: 'Syncing...', icon: 'fa-spin fa-spinner')
    drive.syncFile()
