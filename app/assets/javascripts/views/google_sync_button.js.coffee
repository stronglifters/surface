Stronglifters.GoogleSyncButton = Ractive.extend
  template: "<button on-click='synchronize'><i class='fa {{icon}}'></i> {{text}}</button>",
  oninit: ->
    @set(text: 'Sync with Google', icon: 'fa-camera-retro')
    @on 'synchronize', (event) ->
      @synchronize()

  synchronize: ->
    @set(text: 'Syncing...', icon: 'fa-spin fa-spinner')
    @drive().syncFile()

  drive: ->
    @drive ||= new Stronglifters.GoogleDrive
      client_id: @get('client_id')
      drive_upload_path: @get('drive_upload_path')

