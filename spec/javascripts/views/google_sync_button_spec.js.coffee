#= require views/google_sync_button
describe "GoogleSyncButton", ->
  beforeEach ->
    @subject = new Stronglifters.GoogleSyncButton()

  describe "synchronize", ->
    it 'synchronizes the drive', ->
      drive = { syncFile: null }
      spyOn(drive, 'syncFile')
      @subject.synchronize(drive)
      expect(drive).to haveCalled('syncFile')

