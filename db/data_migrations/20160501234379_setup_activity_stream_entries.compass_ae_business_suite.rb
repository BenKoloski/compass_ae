# This migration comes from compass_ae_business_suite (originally 20140519180236)
class SetupActivityStreamEntries
  
  def self.up
    ActivityStreamEntryType.find_or_create('note', 'Note')

    note = RoleType.find_or_create('note', 'Note')

    RoleType.find_or_create('note_creator', 'Creator', note)
    RoleType.find_or_create('noted_party', 'Noted Party', note)

    ActivityStreamEntryType.find_or_create('call', 'Call')

    call = RoleType.find_or_create('call', 'Call')

    RoleType.find_or_create('caller', 'Caller', call)
    RoleType.find_or_create('callee', 'Callee', call)

    ActivityStreamEntryType.find_or_create('email', 'Email')

    email = RoleType.find_or_create('email', 'Email')

    RoleType.find_or_create('email_to', 'To', email)
    RoleType.find_or_create('email_from', 'From', email)
  end
  
  def self.down
    #remove data here
  end

end
