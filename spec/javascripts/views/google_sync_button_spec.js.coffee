#= require views/google_sync_button
describe "GoogleSyncButton", ->
  beforeEach ->
    @subject = new Stronglifters.GoogleSyncButton()

  it 'displays the correct button text', ->
    expect(@subject.get('text')).toEqual("Sync with Google")

  describe "synchronize", ->
    beforeEach ->
      @drive = { syncFile: null }
      spyOn(@drive, 'syncFile')
      spyOn(@subject, 'drive').and.returnValue(@drive)

    it 'synchronizes the drive', ->
      @subject.synchronize(@drive)
      expect(@drive.syncFile).toHaveBeenCalled()

    it 'changes the text on the button', ->
      @subject.synchronize(@drive)
      expect(@subject.get('text')).toEqual('Syncing...')

    it 'changes the button icon', ->
      @subject.synchronize(@drive)
      expect(@subject.get('icon')).toContain('fa-spin')
      expect(@subject.get('icon')).toContain('fa-spinner')

