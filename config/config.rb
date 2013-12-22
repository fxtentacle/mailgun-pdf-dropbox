# filename: config.rb
# desc: add configurations to class App
#       including api keys for external services
#       and directory path for saving access token, pdf files

class App
  ########### KEYS FOR MAILGUN API ###############
  MAILGUN_API_KEY = 'key-21ayc-i-p20k9aw9gcg2toueux58r2p4'   
  MAILGUN_DOMAIN = 'sandbox10211.mailgun.org'
  ########### KEYS FOR DROPBOX API ################
  DROPBOX_APP_KEY = 'twhnjq4nptnjlhp'
  DROPBOX_APP_SECRET = 'n8sdjssf58mve2q'
  ########### PATH TO SAVE PDF FILES ################
  APPROOT = '/home/hieusun/programming/projects/mailgun_pdf'
  DROPBOX_ACCESS_TOKEN_CACHE = File.join(APPROOT, 'config/access_token.dat')
  FILE_DIR = File.join(APPROOT,'files')
  ##################################################
end
