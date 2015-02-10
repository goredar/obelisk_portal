class AsteriskController < ApplicationController

  def make_call
    if session[:user_id]
      ami = RubyAsterisk::AMI.new(ASTERISK_CONFIG["host"], ASTERISK_CONFIG["port"])
      ami.login(ASTERISK_CONFIG["username"], ASTERISK_CONFIG["password"])
      begin
        message = ami.send(:execute, 'Originate', \
          {
            'Channel' => "SIP/#{session[:user_login]}",
            'Exten' => params["callee"],
            'Context' => "from-internal",
            'Priority' => "1",
            'Timeout' => '60000',
            'Callerid' => session[:user_login],
            'Async' => "false"
          }
        ).success ? t("call_queued") : t("failed_to_queue_call")
        ami.disconnect
      rescue
        message = t("call_unknown")
      end
    else
      message = t("should_login_to_call")
    end
    respond_to do |format|
      format.json { render json: { :message => message } }
      format.html { render nothing: true }
    end
  end
end