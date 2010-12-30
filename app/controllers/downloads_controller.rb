class DownloadsController < ApplicationController
  def show
    attach = Attach.find(params[:id].to_i)
    # checking permissions and incrementing download counter goes here
    head(:x_accel_redirect => attach.file.path.sub(RAILS_ROOT, ''),
         :content_type => attach.file.content_type)
  end
end
