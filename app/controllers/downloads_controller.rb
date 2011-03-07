class DownloadsController < ApplicationController
  def show
    attach = Attach.find(params[:id].to_i)

    # checking permissions and incrementing download counter goes here
    attach.add_log(current_user, request.remote_addr)

    head(:x_accel_redirect => attach.file.path.sub(Rails.root, ''),
         :content_type => attach.file.content_type)
  end
end
