# Methods added to this helper will be available to all templates in the application.
require 'digest/md5'

module ApplicationHelper

  def format_time(time, format = :iso)
    TimeFormatter.new(time).send(format)
  end
  
  def format_seconds(total_seconds, format = :general)
    DurationFormatter.new(total_seconds).send(format)
  end
  
  def setting_row(label, value, help = '&nbsp;')
    <<-EOL
    <tr>
      <td class='label'>#{label} :</td>
      <td>#{value}</td>
      <td class='help'>#{help}</td>
    </tr>
    EOL
  end

  def link_to_build(project, build)
    text = build_label(build)
    if build.failed?
      text += " FAILED"
    elsif build.incomplete?
      text += " incomplete"
    end
    build_link(text, project, build)
  end

  def build_to_text(build, with_elapsed_time = true)
    text = build_label(build)
    if build.failed?
      text += ' FAILED'
    elsif build.incomplete?
      text += ' incomplete'
    else
      elapsed_time_text = elapsed_time(build)
      text += " took #{elapsed_time_text}" if (with_elapsed_time and !elapsed_time_text.empty?)
    end
    return text
  end
  
  def link_to_build_with_elapsed_time(project, build)
    build_link(build_to_text(build), project, build)
  end
    
  def display_builder_state(state)
    case state
    when 'building', 'builder_down', 'build_requested', 'source_control_error', 'queued', 'timed_out', 'error'
      "<div class=\"builder_status_#{state}\">#{state.gsub('_', ' ')}</div>"
    when 'sleeping', 'checking_for_modifications'
      ''
    else
      "<div class=\"builder_status_unknown\">#{h state}<br/>unknown state</div>"
    end
  end

  def format_changeset_log(log)
    h(log.strip)
  end
  
  def elapsed_time(build, format = :general)
    begin
      "<span>#{format_seconds(build.elapsed_time, format)}</span>"
    rescue
      '' # The build time is not present.
    end
  end
  
  def build_link(text, project, build)
    link_to text, build_path(:project => project.name, :build => build.label),
            :class => build.status, :title => format_changeset_log(build.changeset)
  end
  
  def url_path(url)
    if url.is_a?(Hash)
      url_for(url.merge(:only_path => true))
    else
      url.match(/\/\/.+?(\/.+)/)[1]
    end
  end
        
  private
  
  def build_label(build)
    "#{build.abbreviated_label} (#{format_time(build.time, :human)})"
  end
  def gravatar_url_for(email, options = {})
    url_for({ 
      :gravatar_id => Digest::MD5.hexdigest(email),
      :host => 'www.gravatar.com',
      :protocol => 'http://',
      :only_path => false,
      :controller => 'avatar.php'
      }.merge(options)) 
  end 
  
  def show_mail_builder (email) 
    if email != nil && email != '' && email != 'no-email-yet' then
      email
    else
      " First build or this build don't has an email"
    end
  end
end
