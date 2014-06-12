class Spotlight::Fcrepo4::LdpathController < Spotlight::ApplicationController
  load_resource :exhibit, class: Spotlight::Exhibit, prepend: true
  
  def show
    render text: current_exhibit.program, content_type: "text/plain"
  end

end
