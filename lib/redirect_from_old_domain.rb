class RedirectFromOldDomain
  def initialize(app)
    @app = app
  end

  def call(env)
    # if coming from bsuir-helper.ru
    if env['HTTP_HOST'] == AppConfig.old_domain || env['HTTP_HOST'] == "www.#{AppConfig.old_domain}"
      log = RedirectionHistory.new(:ip => env['REMOTE_ADDR'],
                                   :user_agent => env['HTTP_USER_AGENT'],
                                   :http_host => env['HTTP_HOST'],
                                   :request_uri => env['REQUEST_URI'],
                                   :env => Marshal.dump(env.to_yaml))

      destination = AppConfig.host

      unless env['REQUEST_URI'] == '/'
        new = RedirectionRule.first(:conditions => ['old_path = ?', env['REQUEST_URI']])
        if new
          destination = "#{new.subdomain}.#{destination}" if new.subdomain
          log.redirection_rule = new
          case new.object_type
          when 'User'
            destination << "/users/#{new.object_id}"
          when 'Newsitem'
            destination << "/news/#{new.object_id}"
          when 'Material'
            destination << "/materials/#{new.object_id}"
          when 'Discipline'
            destination << "/disciplines/#{new.object_id}"
          when 'Teacher'
            destination << "/lectors/#{new.object_id}"
          when 'Forum'
            destination << "/forums/#{new.object_id}"
          when 'Topic'
            destination << "/topics/#{new.object_id}"
          end
        end
      end
      destination = "http://#{destination}"
      log.destination = destination
      log.save

      [301, {'Location' => destination}]
    else
      @app.call(env)
    end
  end
end
