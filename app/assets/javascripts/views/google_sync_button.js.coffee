Stronglifters.GoogleSyncButton = Ractive.extend
  template: "<button on-click='synchronize'><i class='fa {{icon}}'></i> {{text}}</button>",
  oninit: ->
    @set(text: 'Sync With Google', icon: 'fa-camera-retro')
    @on 'synchronize', (event) =>
      @synchronize()

  synchronize: ->
    @set(text: 'Syncing...', icon: 'fa-spin fa-spinner')
    new Stronglifters.GoogleDrive({
      client_id: @get('client_id')
      drive_upload_path: @get('drive_upload_path')
    }).syncFile()
