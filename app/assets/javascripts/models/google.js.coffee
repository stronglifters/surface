class Stronglifters.GoogleDrive
  constructor: () ->
    console.log("GOOGLE DRIVE")

  initialize: () ->
    @drive = new gapi.drive.share.ShareClient('241601222378')
    @drive.setItemIds(["<FILE_ID>"])

  showSettingDialog: () ->
    @drive.showSettingsDialog()
