class DownloadFromDriveJob < ActiveJob::Base
  queue_as :default
  require 'google/api_client'

  CLIENT_ID = "241601222378-kscpfqhpmc6059704mfcq8ckcp799dvn.apps.googleusercontent.com"
  CLIENT_SECRET = ENV['GOOGLE_CLIENT_SECRET']
  REDIRECT_URI = ENV['GOOGLE_REDIRECT_URI']
  SCOPES = [
    'https://www.googleapis.com/auth/drive',
    'https://www.googleapis.com/auth/drive.install',
    'https://www.googleapis.com/auth/drive.file',
    'https://www.googleapis.com/auth/drive.readonly',
    'https://www.googleapis.com/auth/drive.apps.readonly',
  ]

  def perform(params)
    puts params.inspect

    drive = GoogleDrive.new
    drive.build_client(drive.get_credentials())

    #Dir.mktmpdir do |dir|
      #download_path = File.join(dir, params[:title])
      #`wget -O #{download_path} #{params[:downloadUrl]}`
    #end
  end
end

 
