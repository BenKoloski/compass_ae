# This migration comes from compass_ae_business_suite (originally 20150203165313)
class CompileAllUiComponents
  
  def self.up
    OrganizerView.all.each do |organizer_view|
      organizer_view.compile
    end
  end
  
  def self.down
    #remove data here
  end

end
